unit License;

interface

//------------------------------------------------------------------------------

type
  TProductInfo = record
    Name: String;
    Value1: Integer;
    Value2: Integer;
  end;

//------------------------------------------------------------------------------

const
  ProductCount = 7;
  ProductList: array[0..ProductCount - 1] of TProductInfo = (
    (
      Name: 'UEStudio 18.x';
      Value1: $3231;
      Value2: $00200202;
    ),
    (
      Name: 'UltraCompare 18.x';
      Value1: $212C;
      Value2: $10111280;
    ),
    (
      Name: 'UltraCompare Mobile 18.x';
      Value1: $6258;
      Value2: $00310002;
    ),
    (
      Name: 'UltraEdit 25.x';
      Value1: $7B3C;
      Value2: $10210200;
    ),
    (
      Name: 'UltraEdit Mobile 25.x';
      Value1: $272A;
      Value2: $10101280;
    ),
    (
      Name: 'UltraFinder 17.x';
      Value1: $BDF2;
      Value2: $10300080;
    ),    
    (
      Name: 'UltraFTP 18.x';
      Value1: $8814;
      Value2: $10110280;
    )
  );

//------------------------------------------------------------------------------

function GenerateAuthCodes(const ProductInfo: TProductInfo;
  const UserCode1, UserCode2: String; var AuthCode1, AuthCode2: String): Integer;
function IsHostsFilePatched: Boolean;
function PatchHostsFile: Boolean;

//------------------------------------------------------------------------------

implementation

uses
  Windows,
  SysUtils;

//------------------------------------------------------------------------------

const
  HostEntries: array[0..1] of String = (
    'licensing.ultraedit.com',
    'licensing2.ultraedit.com'
  );

//------------------------------------------------------------------------------
// Return Codes:
// 0 - Success
// 1 - UserCode1 is not valid.
// 2 - UserCode2 is not valid.
//------------------------------------------------------------------------------
function GenerateAuthCodes(const ProductInfo: TProductInfo;
  const UserCode1, UserCode2: String; var AuthCode1, AuthCode2: String): Integer;
const
  Count = $1B;
var
  Code1, Code2, Value: Integer;
begin
  if not TryStrToInt(Trim(UserCode1), Code1) then
  begin
    Result := 1;
    Exit;
  end;

  if not TryStrToInt(Trim(UserCode2), Code2) then
  begin
    Result := 2;
    Exit;
  end;

  Value := ProductInfo.Value1;

  asm
    pushad
    mov     ebx, Value
    add     ebx, 34h
    mov     ecx, Code1
    mov     eax, ecx
    mov     edx, ecx
    sar     edx, 8
    sar     eax, 13h
    and     edx, 1Fh
    and     eax, 0Fh
    imul    edx, 0F3h
    mov     esi, ecx
    imul    eax, 108h
    mov     edi, ecx
    sar     esi, 0Dh
    and     ecx, 0FFh
    sar     edi, 0Fh
    add     eax, edx
    and     esi, 3Fh
    add     esi, 7BCh
    and     edi, 0FF00h
    add     edi, ecx
    mov     ecx, esi
    shl     ecx, 4
    lea     edx, [edi+ebx*2]
    add     edx, ebx
    add     edx, Code2
    add     ecx, esi
    lea     ecx, [eax+ecx*4]
    mov     eax, ecx
    lea     edx, [edi+edx*2]
    shl     eax, 5
    add     edx, ebx
    sub     eax, ecx
    mov     ebx, 1
    lea     edi, [ecx+ecx]
    mov     esi, ebx
    add     eax, edx
    mov     edi, edi

  @Loop:
    mov     edx, eax
    and     edx, 7FFFFFFFh
    add     esi, ebx
    add     eax, edi
    cmp     esi, Count
    jle     @Loop
    and     eax, 7FFFFFFFh
    mov     Value, eax
    popad
  end;

  AuthCode1 := IntToStr(Value);

  repeat
    Value := Random(MaxInt) + 1;
  until ((Value and $C2842429) = $42042021) and ((Value and $10311282) = ProductInfo.Value2);

  AuthCode2 := IntToStr(Value);
  Result := 0;
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
