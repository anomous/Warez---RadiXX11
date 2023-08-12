unit Licensing;

interface

function ActivateProgram(const EMail: String): Boolean;
function IsValidEMail(const EMail: String): Boolean;

implementation

uses
  Classes,
  DCPrijndael,
  DCPbase64,
  IniFiles,
  MD5,
  SysUtils,
  uSMBIOS,
  Utils;

//------------------------------------------------------------------------------

function ZeroPadding(const S: String; Len: Integer): String;
var
  I: Integer;
begin
  Result := S;

  if ((Length(S) mod Len) <> 0) or (Length(S) = 0) then
  begin
    SetLength(Result, Len * (Length(S) div Len + 1));

    for I := (Length(S) + 1) to Length(Result) do
      Result[I] := #0;
  end;
end;

//------------------------------------------------------------------------------

function EncryptString(const S: String): String;
var
  KeyData, VectorData, InData, OutData: String;
begin
  KeyData := ZeroPadding('dhthvmxmaktmxjthvxmdhkdkdlemf!@', 32);
  VectorData := ZeroPadding('&!#)ZJH:KLA@#$ZF', 16);
  InData := ZeroPadding(S, 16);
  OutData := InData;

  with TDCP_rijndael.Create(nil) do
  try
    Init(PChar(KeyData)^, Length(KeyData) * 8, PChar(VectorData));
    EncryptCBC(PChar(InData)^, PChar(OutData)^, Length(InData));
    Burn;
  finally
    Free;
  end;

  Result := Base64EncodeStr(OutData);
end;

//------------------------------------------------------------------------------

function GetHardwareKey: String;
var
  Buffer: array[0..16 * 2 + 1] of Char;
begin
  FillChar(Buffer, SizeOf(Buffer), 0);

  with TSMBios.Create do
  try
    BinToHex(PChar(@SysInfo.RAWSystemInformation.UUID), Buffer, 16);
    Result := MD5ToString(MD5FromString(SysInfo.ManufacturerStr + SysInfo.ProductNameStr + SysInfo.SerialNumberStr + Buffer));
  finally
    Free;
  end;

  Result := MD5ToString(MD5FromString(Result + 'dhthvmxmaktmxjthvxmdhkdkdlemf!@'));
  Result := MD5ToString(MD5FromString(Result + '&!#)ZJH:KLA@#$ZF'));
end;

//------------------------------------------------------------------------------

function IsValidEMail(const EMail: String): Boolean;
begin
  Result := (Pos('@', EMail) > 0) and (Pos('.', EMail) > 0);
end;

//------------------------------------------------------------------------------

function ActivateProgram(const EMail: String): Boolean;
const
  CharSet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  CSIDL_APPDATA = $001A;
var
  FileName, SerialNumber: String;
  I: Integer;
begin
  Result := False;

  if IsValidEMail(EMail) then
  begin
    SetLength(SerialNumber, 19);

    for I := 1 to Length(SerialNumber) do
      SerialNumber[I] := CharSet[Random(Length(CharSet)) + 1];

    FileName := IncludeTrailingPathDelimiter(GetFolderPath(CSIDL_APPDATA)) + 'oCam\Config.ini';

    with TIniFile.Create(FileName) do
    try
      WriteInteger('License', 'Type', 3);
      WriteString('License', 'EMail', EncryptString(EMail));
      WriteString('License', 'SerialNumber', EncryptString(SerialNumber));
      WriteString('License', 'HardwareKey2', EncryptString(GetHardwareKey));
    finally
      Free;
    end;

    Result := True;
  end;
end;

end.
