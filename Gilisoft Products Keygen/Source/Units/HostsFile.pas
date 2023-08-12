unit HostsFile;

interface

type
  THostsEntry = record
    IP: String;
    Host: String;
  end;

  TArrayOfHostsEntry = array of THostsEntry;

procedure AddHostsEntry(const IP, Host: String);
function GetHostsEntries: TArrayOfHostsEntry;
function HostsEntryExists(const Host: String): Boolean;

implementation

uses
  Windows,
  SysUtils;

function GetHostsFileName: String;
var
  Buffer: array[0..MAX_PATH] of Char;
begin
  if GetSystemDirectory(Buffer, MAX_PATH) = 0 then
    RaiseLastOSError;

  Result := IncludeTrailingPathDelimiter(Buffer) + 'drivers\etc\hosts';
end;

//------------------------------------------------------------------------------

{$WARN SYMBOL_PLATFORM OFF}
procedure AddHostsEntry(const IP, Host: String);
var
  F: TextFile;
  FileName: String;
  FileAttr: Word;
  FileOk: Boolean;
  OldFileMode: Byte;
begin
  FileAttr := 0;
  FileName := GetHostsFileName;
  FileOk := FileExists(FileName);

  // if the hosts file exists, change its attributes to ensure access
  if FileOk then
  begin
    // save original attributes
    FileAttr := FileGetAttr(FileName);

    // remove read-only, hidden and system file attributes
    if FileSetAttr(FileName, FileAttr and (not faReadOnly) and (not faHidden) and
      (not faSysFile)) <> 0 then
      RaiseLastOSError;
  end;

  try
    // save old file mode and change it to read-write access
    OldFileMode := FileMode;
    FileMode := fmOpenReadWrite;

    AssignFile(F, GetHostsFileName);

    // append to or create the hosts file
    if FileOk then
      Append(F)
    else
      ReWrite(F);

    try
      // write new entry
      WriteLn(F, Trim(IP) + ' ' + Trim(Host));

    finally
      CloseFile(F);

      // restore old file mode
      FileMode := OldFileMode;
    end;

  finally
    // restore original file attributes
    if FileOk then
      FileSetAttr(FileName, FileAttr);
  end;
end;
{$WARN SYMBOL_PLATFORM ON}

//------------------------------------------------------------------------------

function GetHostsEntries: TArrayOfHostsEntry;
var
  F: TextFile;
  S: String;
  I, J: Integer;
  OldFileMode: Byte;
begin
  SetLength(Result, 0);

  // save old file mode and change it to read-only access
  OldFileMode := FileMode;
  FileMode := fmOpenRead;

  // try to open the hosts file
  AssignFile(F, GetHostsFileName);
  Reset(F);

  try
    // while there are lines to read...
    while not Eof(F) do
    begin
      // read line and remove any trailing spaces and/or control characters
      ReadLn(F, S);
      S := Trim(S);

      // process non-empty lines only
      if S <> '' then
      begin
        // skip commentary lines
        if S[1] <> '#' then
        begin
          // search for first tab character
          I := Pos(#9, S);

          // no tab character, search for first space character
          if I = 0 then
            I := Pos(' ', S);

          // split line and add a new entry to the array
          if I > 0 then
          begin
            J := Length(Result);
            SetLength(Result, J + 1);

            with Result[J] do
            begin
              IP := Trim(Copy(S, 1, I - 1));
              Host := Trim(Copy(S, I + 1, MaxInt));
            end;
          end;
        end;
      end;
    end;

  finally
    CloseFile(F);
    
    // restore old file mode
    FileMode := OldFileMode;
  end;
end;

//------------------------------------------------------------------------------

function HostsEntryExists(const Host: String): Boolean;
var
  HostsEntries: TArrayOfHostsEntry;
  I: Integer;
begin
  HostsEntries := GetHostsEntries;

  for I := Low(HostsEntries) to High(HostsEntries) do
  begin
    // does this entry matches with the hostname?
    if SameText(HostsEntries[I].Host, Trim(Host)) then
    begin
      Result := True;
      Exit;
    end;
  end;

  Result := False;
end;

end.
 