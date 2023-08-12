unit License;

interface

const
  MaxLicenses = 16383;

type
  TProductInfo = record
    Name: String;
    Code: Byte;
    MultiLicense: Boolean;
  end;

const
  ProductList: array[0..3] of TProductInfo = (
    (
      Name: 'FinePrint 9.x';
      Code: $70;
      MultiLicense: False;
    ),
    (
      Name: 'FinePrint 9.x Server Edition';
      Code: $70;
      MultiLicense: True;
    ),
    (
      Name: 'pdfFactory 6.x Pro';
      Code: $6F;
      MultiLicense: False;
    ),
    (
      Name: 'pdfFactory 6.x Pro Server Edition';
      Code: $6F;
      MultiLicense: True;
    )
  );

function GenerateLicenseCode(const ProductInfo: TProductInfo;
  Licenses: Integer): String;
  
implementation

uses
  SysUtils;
  
//------------------------------------------------------------------------------

const
  Charset = '5WB9FRK4VTP3CQ6ASN8HX2JMUZYLEDG7';
  Table1: array[0..2] of Byte = ($00, $3F, $4A);
  Table2: array[0..3] of Byte = ($1B, $04, $25, $46);
  Table3: array[0..13] of Byte = ($05, $0B, $11, $17, $18, $1D, $21, $24, $28, $2F, $31, $32, $38, $3E);
  Table4: array[0..3] of Byte = ($09, $12, $2D, $42);
  Table5: array[0..4] of Byte = ($01, $0D, $2A, $3B, $44);
  Table6: array[0..2] of Byte = ($14, $35, $48);
  Table7: array[0..4] of Byte = ($0C, $22, $34, $37, $40);
  Table8: array[0..4] of Byte = ($08, $15, $29, $2C, $3C);
  Table9: array[0..3] of Byte = ($19, $27, $39, $49);
  Table10: array[0..15] of Byte = ($03, $07, $0A, $0F, $13, $16, $1C, $1F, $23, $2B, $2E, $36, $3A, $3D, $43, $47);

//------------------------------------------------------------------------------
  
function GenerateSingleLicenseCode(ProductCode: Integer): String;
var
  S1, S2: String;
  I, J, K: Integer;
  C: Char;
begin
  S1 := StringOfChar(#32, 12);

  for I := 1 to 8 do
  begin
    repeat
      C := Charset[Random(Length(Charset)) + 1];
    until Pos(C, S1) = 0;
    
    S1[I] := C;
  end;

  I := ProductCode - $3E;

  if (I and 1) <> 0 then Inc(I);

  I := I div 2;
  J := Random(31 - I);
  S2 := Charset[I + J + 1] + Charset[I + J + 1];
  I := (I + J) * 2;
  J := ProductCode - I - 31;
  K := Random(31 - J);
  S2 := S2 + Charset[J + K + 1] + Charset[ProductCode - I - (J + K) + 1];

  for I := 1 to 4 do
  begin
    repeat
      J := 9 + Random(4);
    until S1[J] = #32;

    S1[J] := S2[I];
  end;

  Result := StringOfChar(#32, 12);

  for I := 0 to 2 do
  begin
    repeat
      J := Random(3) * 4 + 1;
    until Result[J] = #32;

    S2 := Copy(S1, I * 4 + 1, 4);
    Move(S2[1], Result[J], 4);
  end;

  Insert('-', Result, 5);
  Insert('-', Result, 10);
end;

//------------------------------------------------------------------------------

function GenerateMultiLicenseCode(ProductCode, Licenses: Integer): String;
var
  Buffer1: array[0..79] of Byte;
  Buffer2: array[0..9] of Byte;
  P1, P2: PChar;
  P3: PByte;
  I, J: Integer;
  Y, M, D: Word;
  B: Byte;
begin
  FillChar(Buffer1, SizeOf(Buffer1), 0);

  for I := 0 to 74 do
    Buffer1[I] := Random(2);

  J := 3;

  for I := 2 downto 0 do
  begin
    B := Table1[I];

    if B > 80 then Break;

    Buffer1[B] := J and 1;
    J := J shr 1;
  end;

  J := ProductCode - $62;

  for I := 3 downto 0 do
  begin
    B := Table2[I];

    if B > 80 then Break;

    Buffer1[B] := J and 1;
    J := J shr 1;
  end;

  J := (Licenses and MaxLicenses) - 1;

  for I := 13 downto 0 do
  begin
    B := Table3[I];

    if B > 80 then Break;

    Buffer1[B] := J and 1;
    J := J shr 1;
  end;

  DecodeDate(Now, Y, M, D);
  J := M - 1;

  for I := 3 downto 0 do
  begin
    B := Table4[I];

    if B > 80 then Break;

    Buffer1[B] := J and 1;
    J := J shr 1;
  end;

  J := D - 1;

  for I := 4 downto 0 do
  begin
    B := Table5[I];

    if B > 80 then Break;

    Buffer1[B] := J and 1;
    J := J shr 1;
  end;

  if Y < 2005 then
    Y := 2005;

  J := Y - 2005;

  for I := 2 downto 0 do
  begin
    B := Table6[I];

    if B > 80 then Break;

    Buffer1[B] := J and 1;
    J := J shr 1;
  end;

  J := Random($18);

  for I := 4 downto 0 do
  begin
    B := Table7[I];

    if B > 80 then Break;

    Buffer1[B] := J and 1;
    J := J shr 1;
  end;

  J := Random($20);

  for I := 4 downto 0 do
  begin
    B := Table8[I];

    if B > 80 then Break;

    Buffer1[B] := J and 1;
    J := J shr 1;
  end;

  J := 1;

  for I := 3 downto 0 do
  begin
    B := Table9[I];

    if B > 80 then Break;

    Buffer1[B] := J and 1;
    J := J shr 1;
  end;

  J := 0;

  for I := 15 downto 0 do
  begin
    B := Table10[I];

    if B > 80 then Break;

    Buffer1[B] := J and 1;
    J := J shr 1;
  end;

  FillChar(Buffer2, SizeOf(Buffer2), 0);
  P3 := @Buffer1[3];
  I := 1;

  repeat
    Inc(P3, 5);
    Buffer2[(I - 1) div 8] := Buffer2[(I - 1) div 8] or (Buffer1[I - 1] shl (7 - ((I - 1) and 7)));
    Buffer2[I div 8] := Buffer2[I div 8] or (Buffer1[I] shl (7 - (I and 7)));
    Buffer2[(I + 1) div 8] := Buffer2[(I + 1) div 8] or (PByte(LongWord(P3) - 6)^ shl (7 - ((I + 1) and 7)));
    Buffer2[(I + 2) div 8] := Buffer2[(I + 2) div 8] or (PByte(LongWord(P3) - 5)^ shl (7 - ((I + 2) and 7)));
    Buffer2[(I + 3) div 8] := Buffer2[(I + 3) div 8] or (PByte(LongWord(P3) - 4)^ shl (7 - ((I + 3) and 7)));
    Inc(I, 5);
  until (I - 1) >= 80;

  J := 0;

  for I := 0 to 4 do
    J := J xor PWord(@Buffer2[I * 2])^;

  for I := 15 downto 0 do
  begin
    B := Table10[I];
    
    if B > 80 then Break;

    Buffer1[B] := J and 1;
    J := J shr 1;
  end;

  FillChar(Buffer2, SizeOf(Buffer2), 0);
  P3 := @Buffer1[3];
  I := 1;

  repeat
    Inc(P3, 5);
    Buffer2[(I - 1) div 8] := Buffer2[(I - 1) div 8] or (Buffer1[I - 1] shl (7 - ((I - 1) and 7)));
    Buffer2[I div 8] := Buffer2[I div 8] or (Buffer1[I] shl (7 - (I and 7)));
    Buffer2[(I + 1) div 8] := Buffer2[(I + 1) div 8] or (PByte(LongWord(P3) - 6)^ shl (7 - ((I + 1) and 7)));
    Buffer2[(I + 2) div 8] := Buffer2[(I + 2) div 8] or (PByte(LongWord(P3) - 5)^ shl (7 - ((I + 2) and 7)));
    Buffer2[(I + 3) div 8] := Buffer2[(I + 3) div 8] or (PByte(LongWord(P3) - 4)^ shl (7 - ((I + 3) and 7)));
    Inc(I, 5);
  until (I - 1) >= 80;

  I := SizeOf(Buffer2);
  P1 := @Buffer2;
  P2 := @Buffer1;

  repeat
    P2[0] := Charset[(Byte(P1[0]) shr 3) + 1];
    P2[1] := Charset[(((Byte(P1[0]) and 7) * 4) or (Byte(P1[1]) shr 6)) + 1];
    P2[2] := Charset[((Byte(P1[1]) shr 1) and $1F) + 1];
    P2[3] := Charset[(((Byte(P1[1]) and 1) * 16) or (Byte(P1[2]) shr 4)) + 1];
    P2[4] := Charset[(((Byte(P1[2]) and $0F) * 2) or (Byte(P1[3]) shr 7)) + 1];
    P2[5] := Charset[((Byte(P1[3]) shr 2) and $1F) + 1];
    P2[6] := Charset[(((Byte(P1[3]) and 3) * 8) or (Byte(P1[4]) shr 5)) + 1];
    P2[7] := Charset[(Byte(P1[4]) and $1F) + 1];
    Inc(P1, 5);
    Inc(P2, 8);
    Dec(I, 5);
  until I <= 0;

  Result := '';

  for I := 0 to 14 do
    Result := Result + Char(Buffer1[I]);

  Insert('-', Result, 6);
  Insert('-', Result, 12);
end;

//------------------------------------------------------------------------------

function GenerateLicenseCode(const ProductInfo: TProductInfo;
  Licenses: Integer): String;
begin
  if ProductInfo.MultiLicense and (Licenses > 0) then
    Result := GenerateMultiLicenseCode(ProductInfo.Code, Licenses)
  else
    Result := GenerateSingleLicenseCode(ProductInfo.Code);
end;

end.
