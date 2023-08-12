unit Licensing;

interface

//------------------------------------------------------------------------------

type
  TProductInfo = record
    Id: LongWord;  
    Name: String;
    Key: String;
  end;

const
  ProductCount = 6;
  ProductList: array[0..ProductCount - 1] of TProductInfo = (
    (
      Id: $D186279A;
      Name: 'Driver Updater';
      Key: 'SOFTWARE\Classes\CLSID\{6A64D095-F0C3-0D12-49F1-FB71EE14F01B}\Version';
    ),
    (
      Id: $E482279A;
      Name: 'File Recovery';
      Key: 'SOFTWARE\Classes\CLSID\{6A64D095-6FD1-0D12-49F1-6A797418B38E}\Version';
    ),
    (
      Id: $BE00279A;
      Name: 'PC Repair';
      Key: 'SOFTWARE\Classes\CLSID\{6A64D095-2CFB-0D12-49F1-63EE068BA436}\Version';
    ),
    (
      Id: $B4F5279A;
      Name: 'PCBooster';
      Key: 'SOFTWARE\Classes\CLSID\{6A64D095-FF05-0D12-49F1-AC1553196BF9}\Version';
    ),
    (
      Id: $248A279A;
      Name: 'PCRepairKit';
      Key: 'SOFTWARE\Classes\CLSID\{6A64D095-F26B-0D12-49F1-0C0B98DAE86C}\Version';
    ),
    (
      Id: $57AB279A;
      Name: 'PCSuite';
      Key: 'SOFTWARE\Classes\CLSID\{6A64D095-1A18-0D12-49F1-D841C714A8A5}\Version';
    )
  );

//------------------------------------------------------------------------------

function ClearKey(const ProductInfo: TProductInfo): Boolean;
function GenerateKey(const ProductInfo: TProductInfo): String;
function IsActivated(const ProductInfo: TProductInfo): Boolean;
function IsHostsFilePatched: Boolean;
function PatchHostsFile: Boolean;

//------------------------------------------------------------------------------

implementation

uses
  Windows,
  SHA1,
  SysUtils;

//------------------------------------------------------------------------------

const
  HostEntries: array[0..0] of String = (
    'www.tweakbit.com'
  );

//------------------------------------------------------------------------------

function CRC16CCITT(Buf: PChar; BufSize: Integer): Word;
const
  Polynomial = $1021;
var
  Crc: Word;
  I, J: Integer;
  B: Byte;
  Bit, C15: Boolean;
begin
  Crc := $FFFF;

  for I := 0 to BufSize - 1 do
  begin
    B := Byte(Buf[i]);

    for J := 0 to 7 do
    begin
      Bit := (((B shr (7 - J)) and 1) = 1);
      C15 := (((Crc shr 15) and 1) = 1);
      Crc := Crc shl 1;

      if (C15 xor Bit) then
        Crc := Crc xor Polynomial;
    end;
  end;

  Result := Crc and $FFFF;
end;

//------------------------------------------------------------------------------

function EncodeStr4(const S1, S2: String): String;
begin
  Result := S1;

  if (Length(S1) = 25) and (Length(S2) = 4) then
  begin
    Result[6] := S2[1];
    Result[7] := S2[2];
    Result[19] := S2[3];
    Result[20] := S2[4];
  end;
end;

//------------------------------------------------------------------------------

function EncodeStr8(const S1, S2: String): String;
begin
  Result := S1;

  if (Length(S1) = 25) and (Length(S2) = 8) then
  begin
    Result[12] := S2[1];
    Result[14] := S2[2];
    Result[3] := S2[3];
    Result[23] := S2[4];
    Result[2] := S2[5];
    Result[10] := S2[6];
    Result[16] := S2[7];
    Result[24] := S2[8];
  end;
end;

//------------------------------------------------------------------------------

function RandomHexStr(Len: Integer): String;
var
  I: Integer;
begin
  SetLength(Result, Len);
  for I := 1 to Len do
    Result[I] := IntToHex(Random($10), 1)[1];
end;

//------------------------------------------------------------------------------

function ClearKey(const ProductInfo: TProductInfo): Boolean;
var
  Key: HKEY;
begin
  Result := RegOpenKeyEx(HKEY_LOCAL_MACHINE, PChar(ProductInfo.Key), 0,
              KEY_WRITE, Key) = ERROR_SUCCESS;

  if Result then
  begin
    Result := RegDeleteValue(Key, 'Assembly') = ERROR_SUCCESS;
    RegCloseKey(Key);
  end;
end;

//------------------------------------------------------------------------------

function GenerateKey(const ProductInfo: TProductInfo): String;
var
  S: String;
  Digest: TSHA1Digest;
begin
  S := EncodeStr8(RandomHexStr(25), IntToHex(ProductInfo.Id, 8));
  Result := S;
  Delete(Result, 6, 2);
  Delete(Result, 17, 2);
  Result := Result + '@df3sdG_#$%(';
  Digest := SHA1FromBuffer(UTF8Decode(Result)[1], Length(Result) * SizeOf(WideChar));
  Result := EncodeStr4(S, IntToHex(CRC16CCITT(@Digest, SizeOf(Digest)), 4));
  Insert('-', Result, 6);
  Insert('-', Result, 12);
  Insert('-', Result, 18);
  Insert('-', Result, 24);
end;

//------------------------------------------------------------------------------

function GetHostsFileName: String;
var
  Path: array[0..MAX_PATH - 1] of Char;
begin
  GetSystemDirectory(Path, MAX_PATH);
  Result := IncludeTrailingPathDelimiter(Path) + 'drivers\etc\hosts';
end;

//------------------------------------------------------------------------------

function IsActivated(const ProductInfo: TProductInfo): Boolean;
var
  Key: HKEY;
  DataType: DWORD;
begin
  Result := RegOpenKeyEx(HKEY_LOCAL_MACHINE, PChar(ProductInfo.Key), 0,
              KEY_READ, Key) = ERROR_SUCCESS;

  if Result then
  begin
    Result := RegQueryValueEx(Key, 'Assembly', nil, @DataType, nil, nil) = ERROR_SUCCESS;
    RegCloseKey(Key);
  end;
end;

//------------------------------------------------------------------------------

function IsHostsFilePatched: Boolean;
var
  HostFound: array of Boolean;
  F: TextFile;
  S: String;
  I, Count: Integer;
begin
  AssignFile(F, GetHostsFileName);

  try
    FileMode := fmOpenRead;
    Reset(F);

    try
      // Read all text lines one at a time. Loop ends when EOF is reached or
      // all hosts entries were found.
      SetLength(HostFound, Length(HostEntries));
      Count := 0;
      Result := False;

      while (not Eof(F)) and (not Result) do
      begin
        ReadLn(F, S);
        S := Trim(S);

        // Skip blank lines.
        if S <> '' then
        begin
          // Skip comment lines.
          if S[1] <> '#' then
          begin
            S := LowerCase(S);

            // Check for the presence of any host entry in this line.
            for I := Low(HostEntries) to High(HostEntries) do
            begin
              // If a host entry is present also make sure that it was not found
              // already.
              if (Pos(HostEntries[I], S) > 0) and (not HostFound[I]) then
              begin
                HostFound[I] := True;
                Inc(Count);
              end;
            end;

            // Check if all host entries were found.
            Result := Count = Length(HostEntries);
          end;
        end;
      end;

    finally
      CloseFile(F);
    end;

  except
    Result := False;
  end;
end;

//------------------------------------------------------------------------------

{$WARN SYMBOL_PLATFORM OFF}
function PatchHostsFile: Boolean;
var
  F: TextFile;
  FileName: String;
  Attr, I: Integer;
begin
  FileName := GetHostsFileName;

  try
    // Save original file attributes and remove read-only, system and hidden
    // attributes (to avoid any access error).
    Attr := FileGetAttr(FileName);
    FileSetAttr(FileName, Attr and (not faReadOnly) and (not faSysFile) and
      (not faHidden));

    AssignFile(F, FileName);

    try
      FileMode := fmOpenReadWrite;
      Append(F);

      try
        // Write all host entries.
        for I := Low(HostEntries) to High(HostEntries) do
          WriteLn(F, '127.0.0.1 ' + HostEntries[I]);

        Flush(F);
        Result := True;

      finally
        CloseFile(F);
      end;

    finally
      // Always restore original file attributes.
      FileSetAttr(FileName, Attr);
    end;

  except
    Result := False;
  end;
end;
{$WARN SYMBOL_PLATFORM ON}

end.
