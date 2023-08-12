unit License;

interface

uses
  Classes;

type
  TProductInfo = record
    Name: String;
    Code: Word;
    Licenses: String;
  end;

const
  ProductList: array[0..8] of TProductInfo = (
    (
      Name: 'Application Builder';
      Code: $0021;
      Licenses: 'Enterprise=$82F3,Home=$82F5,Standard=$82F4';
    ),
    (
      Name: 'AutoRun Pro';
      Code: $0014;
      Licenses: 'Business=$82F3,Home=$82F4,Site=$82F2';
    ),
    (
      Name: 'AutoRun Pro Enterprise';
      Code: $0018;
      Licenses: 'Enterprise=$82F3';
    ),
    (
      Name: 'AutoRun Pro Enterprise II';
      Code: $0020;
      Licenses: '';
    ),
    (
      Name: 'Database Application Builder';
      Code: $0023;
      Licenses: 'Business=$82F3,Home=$82F4,Site=$82F2';
    ),
    (
      Name: 'FlashDemo Pro';
      Code: $0019;
      Licenses: '';
    ),
    (
      Name: 'GIF Animator';
      Code: $0016;
      Licenses: '';
    ),
    (
      Name: 'RadBuilder';
      Code: $0024;
      Licenses: 'Standard=$82F3';
    ),
    (
      Name: 'SlideShow Pro';
      Code: $001A;
      Licenses: '';
    )
  );

procedure GetLicenseTypes(const ProductInfo: TProductInfo;
  LicenseTypes: TStrings);
function GenerateRegInfo(const ProductInfo: TProductInfo; const Name: String;
  LicenseType: Byte; var Serial, Key: String): Boolean;
  
implementation

uses
  SysUtils;

//------------------------------------------------------------------------------

function Calc1(a1, a2, a3: LongWord): LongWord;
begin
  Result := ((not a1) and a3) or (a1 and a2);
end;

//------------------------------------------------------------------------------

function Calc2(a1, a2, a3: LongWord): LongWord;
begin
  Result := ((not a3) and a2) or (a3 and a1);
end;

//------------------------------------------------------------------------------

function Calc3(a1, a2, a3: LongWord): LongWord;
begin
  Result := a2 xor a1 xor a3;
end;

//------------------------------------------------------------------------------

function Calc4(a1, a2, a3: LongWord): LongWord;
begin
  Result := ((not a3) or a1) xor a2;
end;

//------------------------------------------------------------------------------

procedure Calc5(a1: PChar);
var
  v1: Boolean;
begin
  v1 := (Byte(a1[3]) and $80) = 0;
  PLongWord(a1)^ := PLongWord(a1)^ shl 1;

  if not v1 then
    Inc(PLongWord(a1)^);
end;

//------------------------------------------------------------------------------

procedure Calc6(a1: LongWord; a2: PChar);
var
  I: Integer;
begin
  for I := 1 to a1 do
    Calc5(a2);
end;

//------------------------------------------------------------------------------

procedure Calc7(var a1: LongWord; a2, a3, a4, a5, a6, a7: LongWord);
var
  v11: LongWord;
begin
  v11 := a4 + a6 + a1 + Calc1(a2, a3, a7);
  Calc6(a5, @v11);
  a1 := v11 + a2;
end;

//------------------------------------------------------------------------------

procedure Calc8(var a1: LongWord; a2, a3, a4, a5, a6, a7: LongWord);
var
  v11: LongWord;
begin
  v11 := a4 + a6 + a1 + Calc2(a2, a3, a7);
  Calc6(a5, @v11);
  a1 := v11 + a2;
end;

//------------------------------------------------------------------------------

procedure Calc9(var a1: LongWord; a2, a3, a4, a5, a6, a7: LongWord);
var
  v11: LongWord;
begin
  v11 := a4 + a6 + a1 + Calc3(a2, a3, a7);
  Calc6(a5, @v11);
  a1 := v11 + a2;
end;

//------------------------------------------------------------------------------

procedure Calc10(var a1: LongWord; a2, a3, a4, a5, a6, a7: LongWord);
var
  v11: LongWord;
begin
  v11 := a4 + a6 + a1 + Calc4(a2, a3, a7);
  Calc6(a5, @v11);
  a1 := v11 + a2;
end;

//------------------------------------------------------------------------------

procedure Calc11(var Value1, Value2, Value3, Value4: LongWord);
var
  Arr: array[0..15] of LongWord;
  ValueA, ValueB, ValueC, ValueD, ValueE, ValueF, ValueG, ValueH: LongWord;
begin
  ValueA := $01234567;
  ValueB := $89ABCDEF;
  ValueC := $BA98FEDC;
  ValueD := $76504321;
  ValueE := $76504321;
  ValueF := $BA98FEDC;
  ValueG := $89ABCDEF;
  ValueH := $01234567;
  Arr[0] := Value1;
  Arr[1] := Value2;
  Arr[2] := Value3;
  Arr[3] := Value4;
  Arr[4] := Value4;
  Arr[5] := Value3;
  Arr[6] := Value2;
  Arr[7] := Value1;
  Arr[8] := Value1;
  Arr[9] := Value2;
  Arr[10] := Value3;
  Arr[11] := Value4;
  Arr[12] := Value4;
  Arr[13] := Value3;
  Arr[14] := Value2;
  Arr[15] := Value1;

  Calc7(ValueE, ValueF, ValueG, $D76AA478, 7, Arr[0], ValueH);
  Calc7(ValueH, ValueE, ValueF, $E8C7B756, 12, Arr[1], ValueG);
  Calc7(ValueG, ValueH, ValueE, 606105819, 17, Arr[2], ValueF);
  Calc7(ValueF, ValueG, ValueH, $C1BDCEEE, 22, Arr[3], ValueE);
  Calc7(ValueE, ValueF, ValueG, $F57C0FAF, 7, Arr[4], ValueH);
  Calc7(ValueH, ValueE, ValueF, $4787C62A, 12, Arr[5], ValueG);
  Calc7(ValueG, ValueH, ValueE, $A8304613, 17, Arr[6], ValueF);
  Calc7(ValueF, ValueG, ValueH, $FD469501, 22, Arr[7], ValueE);
  Calc7(ValueE, ValueF, ValueG, $698098D8, 7, Arr[8], ValueH);
  Calc7(ValueH, ValueE, ValueF, $8B44F7AF, 12, Arr[9], ValueG);
  Calc7(ValueG, ValueH, ValueE, $FFFF5BB1, 17, Arr[10], ValueF);
  Calc7(ValueF, ValueG, ValueH, $895CD7BE, 22, Arr[11], ValueE);
  Calc7(ValueE, ValueF, ValueG, $6B901122, 7, Arr[12], ValueH);
  Calc7(ValueH, ValueE, ValueF, $FD987193, 12, Arr[13], ValueG);
  Calc7(ValueG, ValueH, ValueE, $A679438E, 17, Arr[14], ValueF);
  Calc7(ValueF, ValueG, ValueH, $49B40821, 22, Arr[15], ValueE);
  Calc8(ValueE, ValueF, ValueG, $F61E2562, 5, Arr[1], ValueH);
  Calc8(ValueH, ValueE, ValueF, $C040B340, 9, Arr[6], ValueG);
  Calc8(ValueG, ValueH, ValueE, $265E5A51, 14, Arr[11], ValueF);
  Calc8(ValueF, ValueG, ValueH, $E9B6C7AA, 20, Arr[0], ValueE);
  Calc8(ValueE, ValueF, ValueG, $D62F105D, 5, Arr[5], ValueH);
  Calc8(ValueH, ValueE, ValueF, $2441453, 9, Arr[10], ValueG);
  Calc8(ValueG, ValueH, ValueE, $D8A1E681, 14, Arr[15], ValueF);
  Calc8(ValueF, ValueG, ValueH, $E7D3FBC8, 20, Arr[4], ValueE);
  Calc8(ValueE, ValueF, ValueG, $21E1CDE6, 5, Arr[9], ValueH);
  Calc8(ValueH, ValueE, ValueF, $C33707D6, 9, Arr[14], ValueG);
  Calc8(ValueG, ValueH, ValueE, $F4D50D87, 14, Arr[3], ValueF);
  Calc8(ValueF, ValueG, ValueH, $455A14ED, 20, Arr[8], ValueE);
  Calc8(ValueE, ValueF, ValueG, $A9E3E905, 5, Arr[13], ValueH);
  Calc8(ValueH, ValueE, ValueF, $FCEFA3F8, 9, Arr[2], ValueG);
  Calc8(ValueG, ValueH, ValueE, $676F02D9, 14, Arr[7], ValueF);
  Calc8(ValueF, ValueG, ValueH, $8D2A4C8A, 20, Arr[12], ValueE);
  Calc9(ValueE, ValueF, ValueG, $FFFA3942, 4, Arr[5], ValueH);
  Calc9(ValueH, ValueE, ValueF, $8771F681, 11, Arr[8], ValueG);
  Calc9(ValueG, ValueH, ValueE, $6D9D6122, 16, Arr[11], ValueF);
  Calc9(ValueF, ValueG, ValueH, $FDE5380C, 23, Arr[14], ValueE);
  Calc9(ValueE, ValueF, ValueG, $A4BEEA44, 4, Arr[1], ValueH);
  Calc9(ValueH, ValueE, ValueF, $4BDECFA9, 11, Arr[4], ValueG);
  Calc9(ValueG, ValueH, ValueE, $F6BB4B60, 16, Arr[7], ValueF);
  Calc9(ValueF, ValueG, ValueH, $BEBFBC70, 23, Arr[10], ValueE);
  Calc9(ValueE, ValueF, ValueG, $289B7EC6, 4, Arr[13], ValueH);
  Calc9(ValueH, ValueE, ValueF, $EAA127FA, 11, Arr[0], ValueG);
  Calc9(ValueG, ValueH, ValueE, $D4EF3085, 16, Arr[3], ValueF);
  Calc9(ValueF, ValueG, ValueH, $4881D05, 23, Arr[6], ValueE);
  Calc9(ValueE, ValueF, ValueG, $D9D4D039, 4, Arr[9], ValueH);
  Calc9(ValueH, ValueE, ValueF, $E6DB99E5, 11, Arr[12], ValueG);
  Calc9(ValueG, ValueH, ValueE, $1FA27CF8, 16, Arr[15], ValueF);
  Calc9(ValueF, ValueG, ValueH, $C4AC5665, 23, Arr[2], ValueE);
  Calc10(ValueE, ValueF, ValueG, $F4292244, 6, Arr[0], ValueH);
  Calc10(ValueH, ValueE, ValueF, $432AFF97, 10, Arr[7], ValueG);
  Calc10(ValueG, ValueH, ValueE, $AB9423A7, 15, Arr[14], ValueF);
  Calc10(ValueF, ValueG, ValueH, $FC93A039, 21, Arr[5], ValueE);
  Calc10(ValueE, ValueF, ValueG, $655B59C3, 6, Arr[12], ValueH);
  Calc10(ValueH, ValueE, ValueF, $8F0CCC92, 10, Arr[3], ValueG);
  Calc10(ValueG, ValueH, ValueE, $FFEFF47D, 15, Arr[10], ValueF);
  Calc10(ValueF, ValueG, ValueH, $85845DD1, 21, Arr[1], ValueE);
  Calc10(ValueE, ValueF, ValueG, $6FA87E4F, 6, Arr[8], ValueH);
  Calc10(ValueH, ValueE, ValueF, $FE2CE6E0, 10, Arr[15], ValueG);
  Calc10(ValueG, ValueH, ValueE, $A3014314, 15, Arr[6], ValueF);
  Calc10(ValueF, ValueG, ValueH, $4E0811A1, 21, Arr[13], ValueE);
  Calc10(ValueE, ValueF, ValueG, $F7537E82, 6, Arr[4], ValueH);
  Calc10(ValueH, ValueE, ValueF, $BD3AF235, 10, Arr[11], ValueG);
  Calc10(ValueG, ValueH, ValueE, $2AD7D2BB, 15, Arr[2], ValueF);
  Calc10(ValueF, ValueG, ValueH, $EB86D391, 21, Arr[9], ValueE);

  Value1 := ValueE + ValueD;
  Value2 := ValueF + ValueC;
  Value3 := ValueG + ValueB;
  Value4 := ValueH + ValueA;
end;

//------------------------------------------------------------------------------

function GetUInt32FromString(const a1: String): LongWord;
begin
  Result := Byte(a1[4]) + ((Byte(a1[3]) + ((Byte(a1[2]) + (Byte(a1[1]) shl 8)) shl 8)) shl 8);
end;

//------------------------------------------------------------------------------

procedure GetValuesFromString(const S: String; var Value1, Value2: LongWord);
begin
  Value1 := GetUInt32FromString(Copy(S, 1, 4));
  Value2 := GetUInt32FromString(Copy(S, 5, 4));
end;

//------------------------------------------------------------------------------

function GetNameChecksum(const Name: String): LongWord;
var
  S: String;
  I, Value1, Value2, Value3, Value4: LongWord;
begin
  S := Name + StringOfChar(#0, 8 - Length(Name) mod 8);
  Value1 := 0;
  Value2 := 0;

  for I := 0 to Length(S) div 8 - 1 do
  begin
    GetValuesFromString(Copy(S, I * 8 + 1, 8), Value3, Value4);
    Calc11(Value1, Value2, Value3, Value4);
  end;

  Result := Value1;
end;

//------------------------------------------------------------------------------

function GetLicenseTypeCode(const ProductInfo: TProductInfo;
  LicenseType: Byte): Word;
begin
  with TStringList.Create do
  try
    CommaText := ProductInfo.Licenses;

    if Count > 0 then
    begin
      if LicenseType < Count then
        Result := StrToIntDef(ValueFromIndex[LicenseType], 0)
      else
        Result := $FFFF;  // Indicates that the license type index isn't valid.
    end
    else
      Result := 0;  // Indicates that it doesn't use license codes.

  finally
    Free;
  end;
end;

//------------------------------------------------------------------------------

procedure GetLicenseTypes(const ProductInfo: TProductInfo;
  LicenseTypes: TStrings);
var
  I: Integer;
begin
  with TStringList.Create do
  try
    CommaText := ProductInfo.Licenses;

    for I := 0 to Count - 1 do
      LicenseTypes.Add(Names[I]);

  finally
    Free;
  end;
end;

//------------------------------------------------------------------------------

function GenerateRegInfo(const ProductInfo: TProductInfo; const Name: String;
  LicenseType: Byte; var Serial, Key: String): Boolean;
var
  Value1, Value2, Value3, Value4, Value5: LongWord;
  LicenseCode: Word;
begin
  LicenseCode := GetLicenseTypeCode(ProductInfo, LicenseType);

  if LicenseCode <> $FFFF then
  begin
    // If it doesn't need a license code, then generate a random value.
    if LicenseCode = 0 then
      LicenseCode := Random($10000);

    Value1 := GetNameChecksum(Trim(Name));
    Value2 := (ProductInfo.Code shl 16) or (Value1 shr 16);
    Value3 := (Value1 shl 16) or LicenseCode;
    Serial := Format('%.8X%.8X', [Value2, Value3]);
    Value4 := Value2;
    Value5 := Value3;

    Calc11(Value2, Value3, Value4, Value5);

    Key := Format('%.8X%.8X', [Value2, Value3]);
    Result := True;
  end
  else
    Result := False;
end;

end.
