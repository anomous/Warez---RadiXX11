unit Licensing;

interface

type
  TLicenseType = (
    ltBackupEdition,
    ltOEMEdition,
    ltPhotoEdition,
    ltProfessionalEdition,
    ltStandardEdition
  );

const
  LicenseTypes: array[TLicenseType] of String = (
    'Backup Edition',
    'OEM Edition',
    'Photo Edition',
    'Professional Edition',
    'Standard Edition'
  );

function ActivateProduct(const Name, Key: String): Boolean;
function GenerateKey(const Name, Modulus, Exponent: String): String;
function GetParamsFromMUI(const FileName: String; LicenseType: TLicenseType;
  var Modulus, Exponent: String): Boolean;

implementation

uses
  Windows,
  Base64,
  FGInt,
  Registry,
  SHA1,
  SysUtils,
  Utils;

//------------------------------------------------------------------------------
  
const
  Charset = 'ACDEFGHJKLMNPQRTUVWXYZ0123456789';

//------------------------------------------------------------------------------

function Checksum(const S: String): String;
var
  Value1, Value2, Value3, Value4: Integer;
  Value5, Value6: Byte;
begin
  Value6 := 0;
	Value1 := 0;
	Value2 := 7;
	Value3 := 7;

  while Value2 <> 2 do
  begin
    if (Value2 <> 7) and (Value2 <> 6) and (Value2 <> 5) and (Value2 <> 4) then
      Value4 := 20
    else
      Value4 := 25;

    Value5 := 1;

    repeat
      if (Byte(128 shr (Value1 mod 8)) and Byte(S[(Value1 div 8) + 1])) <> 0 then
        Inc(Value5);

      Inc(Value1);
      Dec(Value4);
    until Value4 = 0;

		Value6 := Value6 or ((Value5 mod 2) shl Value3);
		Value2 := Value3 - 1;
    
    Dec(Value3);
  end;

	Result := Charset[(Value6 shr 3) + 1];
end;

//------------------------------------------------------------------------------

function Encode(const S: String): String;
var
  I: Integer;
begin
  Result := '';
  
  for I := 0 to (Length(S) div 5) - 1 do
  begin
    Result := Result + Charset[((Byte(S[(I * 5) + 1]) shr 3) and $1F) + 1];
    Result := Result + Charset[((Byte(4 * (Byte(S[(I * 5) + 1]) and 7)) or Byte(Byte(S[(I * 5) + 2]) shr 6)) and $1F) + 1];
    Result := Result + Charset[((Byte(S[(I * 5) + 2]) shr 1) and $1F) + 1];
    Result := Result + Charset[((Byte(16 * (Byte(S[(I * 5) + 2]) and 1)) or Byte(Byte(S[(I * 5) + 3]) shr 4)) and $1F) + 1];
    Result := Result + Charset[((Byte(Byte(S[(I * 5) + 4]) shr 7) or 2 * Byte(S[(I * 5) + 3]) and $1F) and $1F) + 1];
    Result := Result + Charset[((Byte(S[(I * 5) + 4]) shr 2) and $1F) + 1];
    Result := Result + Charset[((Byte(8 * (Byte(S[(I * 5) + 4]) and 3)) or Byte(Byte(S[(I * 5) + 5]) shr 5)) and $1F) + 1];
    Result := Result + Charset[(Byte(S[(I * 5) + 5]) and $1F) + 1];
  end;
end;

//------------------------------------------------------------------------------

function HexToDecimal(const Value: String): String;
var
  FGI: TFGInt;
begin
  ConvertHexStringToBase256String(Value, Result);
  Base256StringToFGInt(Result, FGI);
  FGIntToBase10String(FGI, Result);
  FGIntDestroy(FGI);
end;

//------------------------------------------------------------------------------

function Factor(const Value: String; var Factor1, Factor2: String): Boolean;
var
  FileName, Output: String;
  I: Integer;
begin
  Result := False;

  // Extract the factoring program (a console app) from resources to a temporary
  // folder and run it with the specified value as parameter. We must wait its
  // execution and capture the std output to get the calculated prime factors.

  // Note: the program used in here, originaly it's part of the MIRACL Crypto
  // SDK library (https://github.com/miracl/MIRACL).

  FileName := GetTempDirectory;

  if FileName = '' then
    FileName := GetCurrentDir;

  FileName := IncludeTrailingPathDelimiter(FileName) + 'factor.exe';

  if ExtractResource(HInstance, 'FACTOR', RT_RCDATA, FileName) then
  begin
    if GetConsoleOutput(FileName + ' ' + HexToDecimal(Value), nil, Output) then
    begin
      // We have a resulting output from the console, now extract the factors.

      // Locate first prime factor.
      I := Pos('PRIME FACTOR', Output);

      if I > 0 then
      begin
        Output := Trim(Copy(Output, I + 12, MaxInt));
        // Locate second prime factor.
        I := Pos('PRIME FACTOR', Output);

        if I > 0 then
        begin
          // Extract the 2 prime factors.
          Factor1 := Trim(Copy(Output, 1, I - 1));
          Factor2 := Trim(Copy(Output, I + 12, MaxInt));
          Result := True;
        end;
      end;
    end;

    DeleteFile(FileName);
  end;
end;

//------------------------------------------------------------------------------

function GetModulusFromMUI(const FileName: String; LicenseType: TLicenseType;
  var Modulus: String): Boolean;
const
  ResType: array[TLicenseType] of PChar = (
    'SU_BAK',
    'SU_OEM',
    'SU_IMG',
    'SU_PRO',
    'SU_STD'
  );
var
  LibModule: HMODULE;
  ResInfo: HRSRC;
  ResData: HGLOBAL;
  ResSize: DWORD;
  P: PChar;
  I: Integer;
begin
  Result := False;

  // *.MUI files are just resource files that can be loaded as any ordinary
  // DLL library. We must find and extract the public key from the correct
  // resource, based on the license type selected.

  if FileExists(FileName) then
  begin
    Modulus := '';
    LibModule := LoadLibraryEx(PChar(FileName), 0, LOAD_LIBRARY_AS_DATAFILE);

    if LibModule <> 0 then
    begin
      ResInfo := FindResource(LibModule, 'WZ_LIC', ResType[LicenseType]);

      if ResInfo <> 0 then
      begin
        ResData := LoadResource(LibModule, ResInfo);

        if ResData <> 0 then
        begin
          P := LockResource(ResData);

          if P <> nil then
          begin
            ResSize := SizeofResource(LibModule, ResInfo);
            SetLength(Modulus, ResSize);
            Move(P^, Modulus[1], ResSize);
          end;
        end;
      end;

      FreeLibrary(LibModule);
    end;

    // If we have a public key block then we can extract the modulus from it.

    if Modulus <> '' then
    begin
      // Locate the begin of the public key block.
      I := Pos('-----BEGIN RSA PUBLIC KEY-----', Modulus);

      if I > 0 then
      begin
        // Locate the end of the public key block.
        Modulus := Trim(Copy(Modulus, I + 30, MaxInt));
        I := Pos('-----END RSA PUBLIC KEY-----', Modulus);

        if I > 0 then
        begin
          // Extract the modulus part and encoded it into hex.
          Modulus := Base64Decode(Trim(Copy(Modulus, 1, I - 1)));
          ConvertBase256StringToHexString(Copy(Modulus, 6, 15), Modulus);
          Result := True;
        end;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------

{$WRITEABLECONST ON}
function GetNextChar: Char;
  function ROL(Value: LongWord; Bits: Byte): LongWord;
  asm
    mov cl, dl
    rol eax, cl
  end;
const
  Value: LongWord = 0;
begin
  Value := ROL($FFA2510F xor Value, $FFA2510F xor Value);
  Result := Charset[(Value mod LongWord(Length(Charset))) + 1];
end;

//------------------------------------------------------------------------------

function ActivateProduct(const Name, Key: String): Boolean;
const
  CSIDL_COMMON_APPDATA = $0023;
var
  FileName: String;
begin
  Result := False;

  if (Length(Name) >= 2) and (Key <> '') then
  begin
    try
      // First, try to save the registration info to the registry.

      with TRegistry.Create do
      try
        RootKey := HKEY_CURRENT_USER;

        if OpenKey('Software\Nico Mak Computing\WinZip\WinIni', True) then
        begin
          WriteString('Name1', Name);
          WriteString('SN1', Key);
          CloseKey;
          Result := True;
        end;

      finally
        Free;
      end;

      // If the first step was sucessfull, then save registration info to a
      // license file located in %ProgramData%\WinZip.

      if Result then
      begin
        FileName := IncludeTrailingPathDelimiter(GetFolderPath(CSIDL_COMMON_APPDATA)) + 'WinZip';

        if ForceDirectories(FileName) then
        begin
          // The license file has the format of any ordinary INI file.
          FileName := FileName + '\WinZip.sureg';
          Result := WritePrivateProfileString('Registration', 'WinZip230_Name',
                      PChar(Name), PChar(FileName)) and
                    WritePrivateProfileString('Registration', 'WinZip230_Code',
                      PChar(Key), PChar(FileName));
        end;
      end;

    except
      Result := False;
    end;
  end;
end;

//------------------------------------------------------------------------------

function GenerateKey(const Name, Modulus, Exponent: String): String;
var
  FGI1, FGI2, FGI3, FGI4: TFGInt;
  S1, S2, S3: String;
  I: Integer;
begin
  if (Length(Name) >= 2) and (Exponent <> '') and (Modulus <> '') then
  begin
    S1 := '';

    for I := 1 to 5 do
      S1 := S1 + GetNextChar;

    S2 := LowerCase(Name);
    S3 := '';

    for I := 1 to Length(S2) do
      if S2[I] in ['a'..'z'] then
        S3 := S3 + S2[I];

    S2 := Copy(SHA1ToString(SHA1FromString(S3 + '-' + S1), True), 1, 28);

    ConvertHexStringToBase256String(S2, S3);
    Base256StringToFGInt(S3, FGI1);
    Base10StringToFGInt(HexToDecimal(Exponent), FGI2);
    Base10StringToFGInt(HexToDecimal(Modulus), FGI3);
    FGIntModExp(FGI1, FGI2, FGI3, FGI4);
    FGIntToBase256String(FGI4, S2);
    FGIntDestroy(FGI1);
    FGIntDestroy(FGI2);
    FGIntDestroy(FGI3);
    FGIntDestroy(FGI4);

    Result := Encode(S2) + Checksum(S2) + S1;

    for I := Length(Result) downto 1 do
      if (I > 1) and (((I - 1) mod 5) = 0) then
        Insert('-', Result, I);
  end
  else
    Result := '';
end;

//------------------------------------------------------------------------------

function GetParamsFromMUI(const FileName: String; LicenseType: TLicenseType;
  var Modulus, Exponent: String): Boolean;
var
  FGI1, FGI2, FGI3, FGI4, FGI5: TFGInt;
  S1, S2: String;
begin
  Result := GetModulusFromMUI(FileName, LicenseType, Modulus);

  if Result then
  begin
    // Factorize modulus (N) to get p and q.
    Result := Factor(Modulus, S1, S2);

    if Result then
    begin
      // Compute d = e^-1 mod phi(N), where phi(N) is (p-1)(q-1) and d is the
      // private exponent.

      Base10StringToFGInt(S1, FGI1);
      Base10StringToFGInt(S2, FGI2);
      Base10StringToFGInt('1', FGI3);
      FGIntSub(FGI1, FGI3, FGI4);
      FGIntSub(FGI2, FGI3, FGI5);
      FGIntDestroy(FGI1);
      FGIntDestroy(FGI2);
      FGIntDestroy(FGI3);
      Base10StringToFGInt('65537', FGI1);
      FGIntMul(FGI4, FGI5, FGI2);
      FGIntModInv(FGI1, FGI2, FGI3);
      FGIntToBase256String(FGI3, S1);
      ConvertBase256StringToHexString(S1, Exponent);
      FGIntDestroy(FGI1);
      FGIntDestroy(FGI2);
      FGIntDestroy(FGI3);
      FGIntDestroy(FGI4);
      FGIntDestroy(FGI5);
    end;
  end;
end;

end.
