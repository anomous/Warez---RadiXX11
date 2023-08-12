unit Licensing;

interface

function CreateRegInfoFile(const FileName: String; ValidDays: Word;
  const StrLicense: String = ''): Boolean;
function GetMaxValidDays: Word;  
function GetRegInfoFileName: String;

implementation

{$WARN UNIT_PLATFORM OFF}

uses
  Windows,
  FileCtrl,
  DateUtils,
  DIMime,
  MD5,
  Registry,
  SysUtils;

const
  ProgramExeName    = 'cmtray.exe';
  RegInfoFileDir    = 'data\';
  RegInfoFileName   = 'register_v2.dat';
  RegInfoFileFormat = '{'#10#09 +
                      '"status":'#09'1,'#10#09 +
                      '"time":'#09'%d,'#10#09 +
                      '"validDay":'#09'%d,'#10#09 +
                      '"type":'#09'0,'#10#09 +
                      '"version":'#09'1,'#10#09 +
                      '"strlicence":'#09'"%s",'#10#09 +
                      '"expiretime":'#09'%d,'#10#09 +
                      '"uuid":'#09'"%s"'#10 +
                      '}';

// Generates an UUID (Universal Unique Identifier) string. This function follows
// the same procedure than the program to create an UUID when none was defined.
function GenerateUUID: String;
var
  Buffer: array[0..MAX_PATH] of Char;
  GUID: TGUID;
  ST: SYSTEMTIME;
  TF: ULARGE_INTEGER;
  FA, TS: Int64;
  Size: DWORD;
begin
  // 1. Generates a base random number of 5 digits.
  Result := Format('%.5d', [Random(100000)]);

  // 2. Concatenates a generated GUID formatted as a 40-digit hex value.
  CreateGUID(GUID);
  Result := Result + Format('%.8X%.4X%.4x%.2X%.2X%.2X%.2X%.2X%.2X%.2X%.2X',
    [GUID.D1, GUID.D2, GUID.D3, GUID.D4[0], GUID.D4[1], GUID.D4[2], GUID.D4[3],
      GUID.D4[4], GUID.D4[5], GUID.D4[6], GUID.D4[7]]);

  // 3. Concatenates the local time formatted in a special value of 17 digits.
  GetLocalTime(ST);
  Result := Result + Format('%.3d%.2d%.2d%.4d%.2d%.2d%.2d',
    [ST.wMilliseconds, ST.wMinute, ST.wDay, ST.wYear, ST.wHour, ST.wSecond, ST.wMonth]);

  // 4. Concatenates the MD5 value of the computer's name.
  Size := SizeOf(Buffer);
  GetComputerName(Buffer, Size);
  Result := Result + MD5ToString(MD5FromBuffer(Buffer, Size));

  // 5. Concatenates the free space value (low part) of the system drive as a
  // 10-digit number.
  GetSystemDirectory(Buffer, SizeOf(Buffer));
  GetDiskFreeSpaceEx(Buffer, FA, TS, @TF);
  Result := Result + Format('%.10u', [TF.LowPart]);

  // The returned UUID is the MD5 value of the resulting string from the above
  // steps.
  Result := MD5ToString(MD5FromString(Result));
end;

// Returns the current UUID value generated and stored in the registry by the
// program. If no UUID value exists, generates a new one and writes it to the
// registry.
function GetUUID: String;
begin
  Result := '';

  try
    with TRegistry.Create do
    try
      RootKey := HKEY_CLASSES_ROOT;

      if OpenKey('CLSID\{8AB9CCC4-75EC-438b-B6C0-D8D78882A12D}\Implemented Categories\{6BC04964-67B7-4d50-BB9B-3653A5C305B3}', True) then
      begin
        Result := ReadString('idex');

        if Result = '' then
        begin
          Result := GenerateUUID;
          WriteString('idex', Result);
        end;

        CloseKey;
      end;

    finally
      Free;
    end;
  except
    Result := '';
  end;
end;

// Returns a valid full path and name to the reg info file.
function GetRegInfoFileName: String;
var
  Dir: String;
begin
  Result := '';
  Dir := '';

  // Try to get program path from registry.
  try
    with TRegistry.Create(KEY_READ) do
    try
      RootKey := HKEY_LOCAL_MACHINE;

      if OpenKey('SOFTWARE\cmpc', False) then
      begin
        Dir := ReadString('ProgramPath');
        CloseKey;
      end;

    finally
      Free;
    end;
  except
    Dir := '';
  end;

  // If it was not available, then try to use the current dir.
  if Dir = '' then
    Dir := ExtractFileDir(ParamStr(0));

  // Verify if the path is valid, otherwise ask to the user for a valid one.
  if not FileExists(IncludeTrailingPathDelimiter(Dir) + ProgramExeName) then
  begin
    while True do
    begin
      // Show folder selection dialog and exit on user cancellation.
      if SelectDirectory('Select installation folder:', '', Dir) then
      begin
        if FileExists(IncludeTrailingPathDelimiter(Dir) + ProgramExeName) then
          Break
        else
          MessageBox(0, PChar(Format('Selected folder is invalid: %s'#13#10#13#10'File %s not found.', [Dir, ProgramExeName])), 'Wrong folder', MB_ICONWARNING or MB_OK);
      end
      else
        Exit;
    end;
  end;

  // Return full path and file name.
  Result := IncludeTrailingPathDelimiter(Dir) + RegInfoFileDir + RegInfoFileName;
end;

// Returns the max number of valid days until max expiration date supported.
function GetMaxValidDays: Word;
begin
  Result := DaysBetween(Today, EncodeDate(2038, 1, 18)) + 1;
end;

// Checks if the specified number of days until expiration is valid.
function IsCorrectValidDays(Value: Word): Boolean;
begin
  Result := (Value >= 1) and (Value <= GetMaxValidDays);
end;

// Creates a file with the registration info data.
function CreateRegInfoFile(const FileName: String; ValidDays: Word;
  const StrLicense: String = ''): Boolean;
var
  Time, ExpireTime: Int64;
  F: TextFile;
  S: String;
  I: Integer;
begin
  Result := False;

  // Must specify a filename.
  if FileName = '' then Exit;

  // Check for an incorrect number of days until expiration.
  if not IsCorrectValidDays(ValidDays) then Exit;

  // Encode current date to UNIX format and calculate expiration date.
  Time := DateTimeToUnix(Today);
  ExpireTime := Time + ValidDays * 86400; // 86400 = number of seconds in a day.

  // If no license string was specified, create a random one.
  if StrLicense = '' then
    S := MD5ToString(MD5FromString(IntToStr(Random(MaxInt))))
  else
    S := StrLicense;

  // Format reg info to a string.
  S := Format(RegInfoFileFormat, [Time, ValidDays, S, ExpireTime, GetUUID]);

  // XOR encrypt the reg info string.
  for I := 1 to Length(S) do
    S[I] := Char(Byte(S[I]) xor $4E);

  // BASE64 encoding of the encrypted reg info string.
  S := MimeEncodeStringNoCRLF(S);

  // Check if target file exists, ask to overwrite it if needed.
  if FileExists(FileName) then
  begin
    if MessageBox(0, PChar(Format('File %s already exists.'#13#10#13#10'Overwrite?',
      [FileName])), 'Warning', MB_ICONWARNING or MB_YESNO) = IDNO then Exit;
  end
  else
  begin
    // Try to create path to file if does not exists.
    if not ForceDirectories(ExtractFileDir(FileName)) then Exit;
  end;

  // Try to create the file and write the reg info to it.
  try
    AssignFile(F, FileName);

    FileMode := fmOpenWrite;

    Rewrite(F);
    Write(F, S);
    CloseFile(F);

    Result := True;
  except
    Result := False;
  end;
end;

end.
