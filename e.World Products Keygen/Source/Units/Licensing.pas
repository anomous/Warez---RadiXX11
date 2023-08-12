unit Licensing;

interface

type
  TProductInfo = record
    Name: String;
    Key: String;
    Data: array[0..3] of LongWord;
  end;

const
  ProductCount = 9;
  ProductList: array[0..ProductCount - 1] of TProductInfo = (
    (
      {
      Name: 'ASP.NET Maker 2019';
      Key: 'F88ECF80EDB401AD7897ADDD4BD308F1EE128';
      Data: ($3A9575EF, $A18C1711, $B71623F7, $008E2F5D);
      }
      // UPDATED 2019-11-20
      Name: 'ASP.NET Maker 2020';
      Key: '777458FBBC9815E54595A2F14B74A928221D9';
      Data: ($08FC5E47, $1B85103B, $F9005807, $0B29902C);
    ),
    (
      Name: 'ASP.NET Report Maker 12';
      Key: '7E8AB71570DDCF3BEDC08AC64147804559D6B';
      Data: ($1A192344, $686E0D58, $E63E740D, $E6257DE4);
    ),
    (
      Name: 'ASPMaker 2018';
      Key: 'B86066412A9A42592B98BE52444A0113B07D4';
      Data: ($5A1F780F, $B934056C, $41D62DAD, $4BC054DB);
    ),
    (
      Name: 'ASP Report Maker 11';
      Key: '206177AC41E1B55889D4C2DE4C381E7BE05DA';
      Data: ($678DDEA3, $833765C7, $ED0ACC7C, $66640F15);
    ),
    (
      {
      Name: 'DB AppMaker 3';
      Key: '3E8087736717E598768493EB4EE5BB11D0499';
      Data: ($20F82840, $DB63518D, $5A157C5B, $A5B4BE6D);
      }
      // UPDATED 2020-05-19
      Name: 'DB AppMaker 4';
      Key: '64C79BC9DD5A6D0864B1AD054BE0CDF191C07';
      Data: ($AE63EA07, $D9C28465, $DB29F15D, $FBB3C7A2);
    ),
    (
      Name: 'Easy Photo Recovery';
      Key: 'BF4EC157AF6940E68159999DE7B45595269B2';
      Data: ($84821D42, $3B28A9E2, $88D30258, $34E8C27E);
    ),
    (
      Name: 'JPEG Recovery Pro 6';
      Key: '8533097F1AEF0FA929C454074FDE7450E8E56';
      Data: ($791EE58E, $8C874B9D, $A22925E3, $323CF1D7);
    ),
    (
      {
      Name: 'PHPMaker 2019';
      Key: 'D5889F4CBD1ECB0AC5A6A43E43FDE85536D36';
      Data: ($71A034CF, $458F11FF, $DEFFB58E, $6FF3638B);
      }
      // UPDATED 2019-08-20
      Name: 'PHPMaker 2020';
      Key: 'B0A5E6E14030845C24988072494993B8DBB6E';
      Data: ($1A192344, $686E0D58, $E63E740D, $E6257DE4);
    ),
    (
      Name: 'PHP Report Maker 12';
      Key: 'FB1C0083903BFC1A734EB9804AD6674E92CEB';
      Data: ($E9E1D202, $F642D0D7, $A9071137, $F5BFF59E);
    )
  );

function GenerateKey(const ProductInfo: TProductInfo; const Name: String): String;
  
implementation

uses
  SysUtils;

//------------------------------------------------------------------------------  

procedure EncodeDecode(const Arr1: array of LongWord; var Arr2: array of LongWord;
  Encode: Boolean);
const
  IndexTable: array[0..23] of LongWord = (
    0, 3, 1, 2, 1, 3, 1, 0, 2, 3, 2, 0, 3, 2, 0, 1, 0, 2, 2, 1, 3, 0, 3, 1
  );
var
  I, J, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15: LongWord;
begin
  V15 := Arr2[0];
  V14 := Arr2[1];
  J := 0;

  for I := 1 to 4 do
  begin
    V1 := Arr1[IndexTable[J + (12 * Byte(Encode) + 2)]];
    V2 := ((V1 + V15) shr 7) xor (V1 + V15);
    V3 := V2 + Arr1[IndexTable[J + (12 * Byte(Encode))]];
    V4 := V3 + V2;
    V5 := (V3 shl 13) xor V3;
    V6 := V5 + Arr1[IndexTable[J + (12 * Byte(Encode) + 1)]];
    V7 := V6 + V5;
    V8 := (V6 shr 17) xor V6;
    V9 := V8 + V1 + V15 + V1;
    V10 := V9 + V8;
    V11 := (V9 shl 9) xor V9;
    V12 := ((LongWord(V11 + V4 + V11) shr 15) xor ((((((LongWord(V11 + V4) shr 3) xor
            (V11 + V4)) + V7) shl 7) xor (((LongWord(V11 + V4) shr 3) xor
            (V11 + V4)) + V7)) + V10)) + V11 + V4 + V11;
    V13 := (V12 shl 11) xor V12 xor V14;
    V14 := V15;
    V15 := V13;
    Inc(J, 3);
  end;

  Arr2[0] := V14;
  Arr2[1] := V15;
end;

//------------------------------------------------------------------------------

function EncodeName(const ProductInfo: TProductInfo; const Name: String): String;
var
  S1, S2, S3, S4: String;
  I, Len, K, L: Integer;
  J: SmallInt;
begin
  Result := '';
  S1 := ProductInfo.Key;
  S2 := '';
  Len := Length(Name);

  if Len < 23 then
  begin
    K := 0;

    for I := 1 to 23 do
    begin
      L := Len * I div 23;

      if L = 0 then
        L := 1;

      if K <> L then
      begin
        S2 := S2 + UpCase(Name[L]);
        K := L;
      end
      else
        S2 := S2 + UpCase(S1[37 - I]);
    end;
  end
  else if Len > 23 then
  begin
    for I := 1 to 23 do
      S2 := S2 + UpCase(Name[Len * I div 23]);
  end
  else
    S2 := UpperCase(Name);

  S3 := '';

  for I := 1 to Length(S2) do
    S3 := S3 + IntToStr(Ord(S2[I]));

  S2 := '';
  I := 1;

  while I <= Length(S3) do
  begin
    S4 := '';
    J := StrToInt(Copy(S3, I, 5));

    while J > 0 do
    begin
      S4 := S1[J mod 37 + 1] + S4;
      J := J div 37;
    end;

    S2 := S2 + S4;

    Inc(I, 5);
  end;

  Len := Length(S2);

  for I := 1 to 12 do
    Result := Result + S2[Len * I div 12];
end;

//------------------------------------------------------------------------------

function GetChecksum(Buffer: PChar; Size: Integer): LongWord;
var
  I, J, K: LongWord;
begin
  Result := 0;

  for I := 0 to Size - 1 do
  begin
    J := Ord(Buffer[I]) + 16 * Result;
    K := J and $F0000000;

    if K <> 0 then
      J := J xor (K shr 24);

    Result := (not K) and J;
  end;
end;

//------------------------------------------------------------------------------

function GenerateKey(const ProductInfo: TProductInfo; const Name: String): String;
var
  Arr: array[0..1] of LongWord;
  S: String;
  I: Integer;
begin
  Result := '';
  S := Trim(Name);

  if S <> '' then
  begin
    S := EncodeName(ProductInfo, S);
    Arr[0] := (Random($10000) shl 16) or $9C5B;
    Arr[1] := GetChecksum(PChar(S), Length(S));

    EncodeDecode(ProductInfo.Data, Arr, True);

    for I := 0 to 7 do
      Result := Result + IntToHex(Byte(PAnsiChar(@Arr)[I]), 2);

    Insert('-', Result, 5);
    Insert('-', Result, 10);
    Insert('-', Result, 15);
  end;
end;

end.
