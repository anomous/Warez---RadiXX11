unit Licensing;

interface

type
  TProductInfo = record
    Name: String;
    KeyId: String;
  end;

const
  ProductList: array[0..2] of TProductInfo = (
    (Name: 'Mini Key Log'; KeyId: '6C97'),
    (Name: 'PC Agent'; KeyId: '2FD2'),
    (Name: 'PC Agent Server'; KeyId: 'B55B')
  );

procedure GenerateActivation(const ProductInfo: TProductInfo;
  var LicenseKey, ActivationCode: String);
    
implementation

uses
  Windows,
  SysUtils;

//------------------------------------------------------------------------------

function CRC16XMODEM(Data: PChar; Len: Integer): Word; overload;
var
  I, J: integer;
begin
  Result := 0;

  for I := 0 to Len - 1 do
  begin
    Result := Result xor (PWord(@Data[I])^ shl 8);

    for J := 0 to 7 do
    begin
      if (Result and $8000) <> 0 then
        Result := (Result shl 1) xor $1021
      else
        Result := Result shl 1;
    end;
  end;
end;

//------------------------------------------------------------------------------

function CRC16XMODEM(const S: String): Word; overload;
begin
  Result := CRC16XMODEM(PChar(S), Length(S));
end;

//------------------------------------------------------------------------------

function GetSystemVolumeSerialNumber: DWORD;
var
  Buffer: array[0..MAX_PATH] of Char;
  MCL, FSF: DWORD;
begin
  GetSystemDirectory(Buffer, MAX_PATH);
  GetVolumeInformation(PChar(Buffer[0]+ ':\'), nil, 0, @Result, MCL, FSF, nil, 0);
end;

//------------------------------------------------------------------------------

procedure GenerateActivation(const ProductInfo: TProductInfo;
  var LicenseKey, ActivationCode: String);
var
  I: Integer;
  A, B, C, D, E: Word;
begin
  LicenseKey := '';

  for I := 1 to 10 do
    LicenseKey := LicenseKey + IntToHex(Random(256), 2);

  LicenseKey := LicenseKey + ProductInfo.KeyId;

  for I := 1 to 4 do
    LicenseKey := LicenseKey + IntToHex(Random(256), 2);

  A := StrToIntDef('$' + Copy(LicenseKey, Length(LicenseKey) - 3, 4), 0);
  B := CRC16XMODEM(LicenseKey);
  C := CRC16XMODEM(IntToStr(GetSystemVolumeSerialNumber));
  D := Random($10000);
  E := A xor B xor C xor D;
  
  ActivationCode := IntToHex(D, 4) + IntToHex(E, 4);
end;

end.
