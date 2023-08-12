unit Licensing;

interface

type
  TSerialGenerator = (sgFunction1, sgFunction2);

  TProductInfo = record
    Name: String;
    SerialGenerator: TSerialGenerator;
  end;

const
  ProductCount = 6;
  ProductList: array[0..ProductCount - 1] of TProductInfo = (
    (
      Name: 'BootIt Bare Metal';
      SerialGenerator: sgFunction2;
    ),
    (
      Name: 'Image for DOS';
      SerialGenerator: sgFunction2;
    ),
    (
      Name: 'Image for Linux';
      SerialGenerator: sgFunction1;
    ),
    (
      Name: 'Image for UEFI';
      SerialGenerator: sgFunction1;
    ),
    (
      Name: 'Image for Windows';
      SerialGenerator: sgFunction1;
    ),
    (
      Name: 'TBOSDT Professional for BootIt';
      SerialGenerator: sgFunction2;
    )
  );

function GenerateSerial(const ProductInfo: TProductInfo;
  const Name: String): String;

implementation

uses
  SysUtils;

//------------------------------------------------------------------------------

function GetCrc32(const S: String): LongWord;
var
  I, J: Integer;
  K: Byte;
begin
  Result := 0;

  for I := 1 to Length(S) do
  begin
    Result := Result xor Byte(S[I]);

    for J := 1 to 8 do
    begin
      K := Result and 1;
      Result := Result shr 1;

      if K <> 0 then
        Result := Result xor $82F63B78;
    end;
  end;
end;

//------------------------------------------------------------------------------

function GetChecksum1(const S: String; Value: Integer): Integer;
var
  I: Integer;
begin
  Result := Value;

  for I := 1 to Length(S) do
    Inc(Result, Word($16F7 * I) * Word($0A7F * (Byte(S[I]) and $7F or $20)));
end;

//------------------------------------------------------------------------------

function GetChecksum2(const Code, Name: String): Integer;
var
  I: Integer;
begin
  Result := $671497;

  for I := 1 to Length(Name) do
    Result := Result xor ($4781 * (I - 1) xor Byte(UpCase(Name[I])));

  for I := 0 to Length(Code) div 5 do
    Result := (Integer(GetCrc32(Copy(Code, (I * 5) + 1, 4))) + Result) xor $347F * I;

  Result := Result and $FFFF;
end;

//------------------------------------------------------------------------------

function GetChecksum3(const S: String; Value: Integer): Integer;
var
  I: Integer;
begin
  Result := Value;

  for I := 1 to Length(S) do
    Inc(Result, Word($1A89 * I) * Word($0D2B * (Byte(S[I]) and $7F or $20)));
end;

//------------------------------------------------------------------------------

function GenerateSerial1(const Name: String): String;
var
  Value1, Value2, Value3, Value4, Value5: Integer;
begin
  if Name <> '' then
  begin
    Value1 := Random($10000);
    Value2 := Random($10000);
    Value3 := Random($10000);
    Value4 := Random($10000);
    Value5 := GetChecksum1(Name, Value1) xor Value2;
    Value5 := (Value5 shr $10) xor (Value5 and $FFFF);
    Result := IntToHex(Value5, 4) + '-' + IntToHex(Value1, 4) + '-' +
              IntToHex(Value2, 4) + '-' + IntToHex(Value3, 4) + '-' +
              IntToHex(Value4, 4);
    Result := Result + '-' + IntToHex(GetChecksum2(Result, Name), 4);
  end
  else
    Result := '';
end;

//------------------------------------------------------------------------------

function GenerateSerial2(const Name: String): String;
var
  Value1, Value2, Value3: Integer;
begin
  if Name <> '' then
  begin
    Value1 := Random($10000);
    Value2 := Random($10000);
    Value3 := GetChecksum3(Name, Value1) xor Value2;
    Value3 := (Value3 shr $10) xor (Value3 and $FFFF);
    Result := IntToHex(Value3, 4) + '-' + IntToHex(Value1, 4) + '-' + IntToHex(Value2, 4);
  end
  else
    Result := '';
end;

//------------------------------------------------------------------------------

function GenerateSerial(const ProductInfo: TProductInfo;
  const Name: String): String;
begin
  case ProductInfo.SerialGenerator of
    sgFunction1:
      Result := GenerateSerial1(Name);

    sgFunction2:
      Result := GenerateSerial2(Name);    
  end;
end;

end.
