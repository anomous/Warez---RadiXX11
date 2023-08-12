//------------------------------------------------------------------------------
// NOTE: This code is based on MobaXterm-Keygen.py by Double Sine
// https://github.com/DoubleLabyrinth
//------------------------------------------------------------------------------

unit Licensing;

interface

//------------------------------------------------------------------------------

type
  TLicenseType = (
    ltEducational,
    ltPersonal,
    ltProfessional
  );

const
  LicenseTypes: array[TLicenseType] of String = (
    'Educational',
    'Personal',
    'Professional'
  );

const
  AppExeName = 'MobaXterm.exe';

//------------------------------------------------------------------------------

function GenerateLicenseFile(const AppPath, UserName: String; UserCount: Integer;
  LicenseType: TLicenseType; VersionMajor, VersionMinor: Integer): Boolean;
function GetAppPath: String;
function GetAppVersion(const AppPath: String;
  var VersionMajor, VersionMinor: Integer): Boolean;
function IsValidAppPath(const AppPath: String): Boolean;

implementation

uses
  Windows,
  Math,
  Registry,
  SynZip,
  SysUtils,
  Utils;

//------------------------------------------------------------------------------

procedure Encrypt(Key: Integer; Buffer: PChar; Len: Integer);
var
  I: Integer;
begin
  for I := 0 to Len - 1 do
  begin
    Buffer[I] := Char(Byte(Buffer[I]) xor (Key shr 8 and 255));
    Key := (Byte(Buffer[I]) and Key) or 18477;
  end;
end;

//------------------------------------------------------------------------------

function VariantBase64Encode(Buffer: PChar; Len: Integer): String;
const
  VariantBase64Table: PChar = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
var
  I, J, CodingInt: Integer;
  BlocksCount, LeftBytes: Word;
begin
  Result := '';

  DivMod(Len, 3, BlocksCount, LeftBytes);

  for I := 0 to BlocksCount - 1 do
  begin
    J := I * 3;
    CodingInt := StrToInt('$' + IntToHex(Byte(Buffer[J + 2]), 2) +
                  IntToHex(Byte(Buffer[J + 1]), 2) + IntToHex(Byte(Buffer[J]), 2));
    Result := Result + VariantBase64Table[CodingInt and 63];
    Result := Result + VariantBase64Table[CodingInt shr 6 and 63];
    Result := Result + VariantBase64Table[CodingInt shr 12 and 63];
    Result := Result + VariantBase64Table[CodingInt shr 18 and 63];
  end;

  if LeftBytes = 0 then Exit;

  if LeftBytes = 1 then
  begin
    CodingInt := StrToInt('$' + IntToHex(Byte(Buffer[BlocksCount * 3]), 2));
    Result := Result + VariantBase64Table[CodingInt and 63];
    Result := Result + VariantBase64Table[CodingInt shr 6 and 63];
  end
  else
  begin
    CodingInt := StrToInt('$' + IntToHex(Byte(Buffer[BlocksCount * 3]), 2));
    Result := Result + VariantBase64Table[CodingInt and 63];
    Result := Result + VariantBase64Table[CodingInt shr 6 and 63];
    Result := Result + VariantBase64Table[CodingInt shr 12 and 63];
  end;
end;

//------------------------------------------------------------------------------

function GenerateLicenseFile(const AppPath, UserName: String; UserCount: Integer;
  LicenseType: TLicenseType; VersionMajor, VersionMinor: Integer): Boolean;
const
  LicenseTypeValue: array[TLicenseType] of Integer = (3, 4, 1);
var
  S: String;
begin
  try
    if (UserCount < 1) or (UserCount > 99) then
      UserCount := 99;

    S := Format('%d#%s|%d%d#%d#%d3%d6%d#%d#%d#%d#',
          [LicenseTypeValue[LicenseType], Trim(UserName), VersionMajor, VersionMinor,
          UserCount, VersionMajor, VersionMinor, VersionMinor, 0, 0, 0]);

    Encrypt(1927, @S[1], Length(S));

    S := VariantBase64Encode(@S[1], Length(S));

    with TZipWrite.Create(IncludeTrailingPathDelimiter(AppPath) + '\Custom.mxtpro') do
    try
      AddDeflated('Pro.key', @S[1], Length(S), 6, DateTimeToFileDate(Now));
      Result := True;

    finally
      Free;
    end;
  except
    Result := False;
  end;
end;

//------------------------------------------------------------------------------

function GetAppPath: String;
begin
  try
    Result := '';

    with TRegistry.Create(KEY_READ) do
    try
      RootKey := HKEY_LOCAL_MACHINE;

      if OpenKey('SOFTWARE\Mobatek\MobaXterm', False) then
      begin
        Result := ReadString('InstallDir');

        if Result <> '' then
          Result := ExcludeTrailingPathDelimiter(Result);

        CloseKey;
      end;

    finally
      Free;
    end;
  except
    Result := '';
  end;
end;

//------------------------------------------------------------------------------

function GetAppVersion(const AppPath: String;
  var VersionMajor, VersionMinor: Integer): Boolean;
var
  Version: TVersionNumber;
begin
  Result := GetFileVersion(IncludeTrailingPathDelimiter(AppPath) + AppExeName, Version);

  if Result then
  begin
    VersionMajor := Version.Major;
    VersionMinor := Version.Minor;
  end;
end;

//------------------------------------------------------------------------------

function IsValidAppPath(const AppPath: String): Boolean;
begin
  Result := FileExists(IncludeTrailingPathDelimiter(AppPath) + AppExeName);
end;

end.
