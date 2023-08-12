unit License;

interface

type
  TLicenseType = (ltSite, ltBusiness, lptPersonal);

  TCreateKeyFileProc = function(const Path, Name, Key: String;
                          LicenseType: TLicenseType): Boolean;

  TGenerateKeyProc = function(const Name: String;
                          LicenseType: TLicenseType): String;

  TProductInfo = record
    Name: String;
    EXEName: String;  // Used to validate the installation folder
    CreateKeyFile: TCreateKeyFileProc;
    GenerateKey: TGenerateKeyProc;
  end;

// Forward declarations ////////////////////////////////////////////////////////

function CreateKeyFileLV(const Path, Name, Key: String;
  LicenseType: TLicenseType): Boolean;
function CreateKeyFileUVP(const Path, Name, Key: String;
  LicenseType: TLicenseType): Boolean;
function GenerateKeyLV(const Name: String; LicenseType: TLicenseType): String;
function GenerateKeyUVP(const Name: String; LicenseType: TLicenseType): String;

////////////////////////////////////////////////////////////////////////////////

const
  LicenseTypes: array[TLicenseType] of String = (
    'Site', 'Business', 'Personal'
  );

  ProductList: array[0..1] of TProductInfo = (
    (
      Name: 'LogViewer';
      EXEName: 'LogView.exe';
      CreateKeyFile: CreateKeyFileLV;
      GenerateKey: GenerateKeyLV;
    ),
    (
      Name: 'Universal Viewer Pro';
      EXEName: 'Viewer.exe';
      CreateKeyFile: CreateKeyFileUVP;
      GenerateKey: GenerateKeyUVP;
    )
  );

function IsInstallationDir(const ProductInfo: TProductInfo;
  const Path: String): Boolean;

implementation

uses
  IniFiles,
  SysUtils;

//------------------------------------------------------------------------------  

const
  Charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

//------------------------------------------------------------------------------

function CreateKeyFileLV(const Path, Name, Key: String;
  LicenseType: TLicenseType): Boolean;
var
  S: String;
begin
  S := Trim(Name);

  // Append license type identifier string to the name. It will be removed by
  // the program later.
  case LicenseType of
    ltBusiness:
      S := S + '[B]';
    ltSite:
      S := S + '[S]';
  end;

  try
    with TIniFile.Create(IncludeTrailingPathDelimiter(Path) + 'Key.txt') do
    try
      WriteString('Key', 'Name', S);
      WriteString('Key', 'Str', Key);
      Result := True;
    finally
      Free;
    end;
  except
    Result := False;
  end;
end;

//------------------------------------------------------------------------------

function CreateKeyFileUVP(const Path, Name, Key: String;
  LicenseType: TLicenseType): Boolean;
begin
  // Note: LicenseType parameter is unused in here since it's already specified
  // in the key format.
  try
    with TIniFile.Create(IncludeTrailingPathDelimiter(Path) + 'Key.txt') do
    try
      WriteString('Key', 'Name', Name);
      WriteString('Key', 'Key', Key);
      Result := True;
    finally
      Free;
    end;
  except
    Result := False;
  end;
end;

//------------------------------------------------------------------------------

function GenerateKeyLV(const Name: String; LicenseType: TLicenseType): String;
var
  S: String;
  I: Integer;
begin
  S := Trim(Name);

  if Length(S) >= 3 then
  begin
    // Append license type identifier string to the name. It will be removed by
    // the program later but it's needed here to correctly calculate the name hash.
    case LicenseType of
      ltBusiness:
        S := S + '[B]';
      ltSite:
        S := S + '[S]';
    end;

    SetLength(Result, 14);

    // Keep generating random chars until all conditions are met.
    repeat
      for I := 1 to Length(Result) do
        Result[I] := Charset[Random(Length(Charset)) + 1];
    until (((Ord(Result[1]) + Ord(Result[2]) + Ord(Result[3]) + Ord(Result[4])) mod ((Ord(S[1]) mod 15) + 11)) = 2) and
          (((Ord(Result[6]) + Ord(Result[7]) + Ord(Result[8]) + Ord(Result[9])) mod ((Ord(S[(Length(S) div 2) + 1]) mod 15) + 11)) = 3) and
          (((Ord(Result[11]) + Ord(Result[12]) + Ord(Result[13]) + Ord(Result[14])) mod ((Ord(S[Length(S)]) mod 15) + 11)) = 4);

    Result[5] := '-';
    Result[10] := '-';
  end
  else
    Result := '3';
end;

//------------------------------------------------------------------------------

function GenerateKeyUVP(const Name: String; LicenseType: TLicenseType): String;
var
  S: String;
  I: Integer;
begin
  if Length(Name) >= 2 then
  begin
    // Remove non allowed chars in the name.
    S := StringReplace(Name, ' ', '', [rfReplaceAll]);
    S := StringReplace(S, '_', '', [rfReplaceAll]);
    S := StringReplace(S, '.', '', [rfReplaceAll]);
    S := StringReplace(S, ',', '', [rfReplaceAll]);
    S := StringReplace(S, ';', '', [rfReplaceAll]);
    S := StringReplace(S, '-', '', [rfReplaceAll]);
    S := StringReplace(S, '/', '', [rfReplaceAll]);
    S := StringReplace(S, '\', '', [rfReplaceAll]);
    S := StringReplace(S, '"', '', [rfReplaceAll]);
    S := StringReplace(S, '''', '', [rfReplaceAll]);
    S := StringReplace(S, '(', '', [rfReplaceAll]);
    S := StringReplace(S, ')', '', [rfReplaceAll]);
    S := StringReplace(S, '[', '', [rfReplaceAll]);
    S := StringReplace(S, ']', '', [rfReplaceAll]);

    SetLength(Result, 19);

    // Keep generating random chars until all conditions are met.
    repeat
      for I := 1 to Length(Result) do
        Result[I] := Charset[Random(Length(Charset)) + 1];

      case LicenseType of
        ltBusiness:
          Result[1] := 'B';
        ltSite:
          Result[1] := 'S';
        lptPersonal:
          Result[1] := 'U';
      end;

      Result[2] := UpCase(S[1]);
      Result[6] := UpCase(S[Length(S) div 2]);
      Result[11] := UpCase(S[(Length(S) div 2) + 1]);
      Result[16] := UpCase(S[Length(S)]);

    until ((Ord(Result[4]) + Ord(Result[3]) + Ord(Result[2]) + Ord(Result[1])) mod 20 = 14) and
          ((Ord(Result[9]) + Ord(Result[8]) + Ord(Result[7]) + Ord(Result[6])) mod 40 = 15) and
          ((Ord(Result[14]) + Ord(Result[13]) + Ord(Result[12]) + Ord(Result[11])) mod 40 = 17) and
          ((Ord(Result[19]) + Ord(Result[18]) + Ord(Result[17]) + Ord(Result[16])) mod 40 = 20);

    Result[5] := '-';
    Result[10] := '-';
    Result[15] := '-';
  end
  else
    Result := '2';
end;

//------------------------------------------------------------------------------

function IsInstallationDir(const ProductInfo: TProductInfo;
  const Path: String): Boolean;
begin
  Result := FileExists(IncludeTrailingPathDelimiter(Path) + ProductInfo.EXEName);
end;

end.
