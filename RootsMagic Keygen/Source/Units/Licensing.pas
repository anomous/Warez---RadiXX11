unit Licensing;

interface

type
  TProductEdition = (
    peStandardEdition = 1,
    peUKEdition,
    peFHCEdition,
    pePublicPreview
  );

const
  EditionList: array[TProductEdition] of String = (
    'Standard Edition',
    'UK Edition',
    'FHC Edition',
    'Public Preview'
  );

type
  TProductInfo = record
    Name: String;
    Id: String;
    BaseDate: Int64;
    EditionCodes: array[0..4] of Byte;
    CharCodes: array['0'..'Z'] of Byte;
    BitIndexes1: array[0..0] of Byte;
    BitIndexes2: array[0..4] of Byte;
    BitIndexes3: array[0..5] of Byte;
    BitIndexes4: array[0..23] of Byte;
    BitIndexes5: array[0..23] of Byte;
  end;

const
  ProductList: array[0..1] of TProductInfo = (
    (
      Name: 'Personal Historian 3';
      Id: 'PH3';
      BaseDate: $40E50F8000000000;
      EditionCodes: (
        $16, $09, $0D, $1E, $02
      );
      CharCodes: (
        $02, $1E, $13, $0B, $06, $1D, $09, $1F, $10, $11, $FF, $FF, $FF, $FF,
        $FF, $FF, $FF, $0A, $10, $07, $04, $01, $0C, $03, $1B, $1E, $18, $14,
        $05, $1C, $16, $02, $00, $15, $1A, $12, $08, $19, $19, $0E, $17, $0F,
        $0D
      );
      BitIndexes1: (
        $39
      );
      BitIndexes2: (
        $34, $1C, $14, $1E, $31
      );
      BitIndexes3: (
        $38, $2D, $15, $29, $10, $07
      );
      BitIndexes4: (
        $1B, $23, $00, $35, $09, $28, $16, $2A, $1A, $2C, $27, $20, $02, $0E,
        $32, $30, $1D, $25, $3B, $37, $2E, $03, $06, $24
      );
      BitIndexes5: (
        $2B, $0F, $22, $21, $11, $12, $0D, $2F, $13, $0B, $33, $19, $18, $08,
        $0A, $01, $04, $17, $36, $0C, $1F, $26, $05, $3A
      );
    ),
    (
      Name: 'RootsMagic 7';
      Id: 'RM7';
      BaseDate: $40E47EC000000000;
      EditionCodes: (
        $11, $09, $1F, $18, $0C
      );
      CharCodes: (
        $0A, $00, $1F, $12, $16, $10, $11, $15, $02, $14, $FF, $FF, $FF, $FF,
        $FF, $FF, $FF, $0B, $02, $18, $08, $1D, $03, $0C, $06, $00, $1B, $1C,
        $0F, $19, $0E, $0A, $07, $0D, $1E, $10, $04, $01, $09, $05, $13, $17,
        $1A
      );
      BitIndexes1: (
        $37
      );
      BitIndexes2: (
        $21, $38, $23, $30, $32
      );
      BitIndexes3: (
        $2C, $01, $24, $27, $35, $39
      );
      BitIndexes4: (
        $11, $20, $04, $0E, $3B, $1C, $2F, $14, $02, $15, $26, $09, $33, $03,
        $34, $3A, $2E, $16, $08, $28, $10, $1A, $0A, $1D
      );
      BitIndexes5: (
        $1B, $0F, $0D, $1E, $17, $18, $2D, $00, $0B, $05, $22, $31, $0C, $25,
        $2B, $06, $29, $2A, $12, $19, $07, $13, $36, $1F
      );
    )
  );

function GenerateKey(const ProductInfo: TProductInfo;
  Edition: TProductEdition): String;

implementation

uses
  SysUtils;

//------------------------------------------------------------------------------

function BitsToString(const ProductInfo: TProductInfo;
  const Bits: array of Boolean; Index: Integer): String;
var
  I, J: Integer;
  C: Char;
begin
  Result := '';
  J := 0;

  for I:= 0 to 4 do
  begin
    if Bits[Index + I] then
      Inc(J, 1 shl (5 - I - 1));
  end;

  for C := Low(ProductInfo.CharCodes) to High(ProductInfo.CharCodes) do
    if ProductInfo.CharCodes[C] = J then
      Result := Result + C;

  if Length(Result) > 1 then
    Result := Result[Random(Length(Result)) + 1];
end;

//------------------------------------------------------------------------------

procedure EncodeBits(var Bits: array of Boolean; const Indexes: array of Byte;
  Value: Integer);
var
  I, Len: Integer;
begin
  Len := Length(Indexes);

  for I := 0 to Len - 1 do
    Bits[Indexes[I]] := ((Value shr (Len - I - 1)) and 1) = 1;
end;

//------------------------------------------------------------------------------

function GenerateKey(const ProductInfo: TProductInfo;
  Edition: TProductEdition): String;
var
  Bits: array[0..59] of Boolean;
  Value1, Value2, Value3, Value4, Value5, Value6: Integer;
  I: Integer;
begin
  Value1 := 1;
  Value2 := Byte(Edition);
  Value3 := ProductInfo.EditionCodes[Value2];
  Value4 := 63;
  Value5 := Random($1000000);
  Value6 := (not Value5) and $FFFFFF;
  Result := IntToStr(Value5) + IntToStr(Value6) + IntToStr(Value4);

  for I := 1 to Length(Result) do
    Value6 := (Value6 xor $FFFFFF and ((Value3 + I + Ord(Result[I])) shl I)) and $FFFFFF;

  FillChar(Bits, Length(Bits), 0);
  EncodeBits(Bits, ProductInfo.BitIndexes1, Value1);
  EncodeBits(Bits, ProductInfo.BitIndexes2, Value3);
  EncodeBits(Bits, ProductInfo.BitIndexes3, Value4);
  EncodeBits(Bits, ProductInfo.BitIndexes4, Value5);
  EncodeBits(Bits, ProductInfo.BitIndexes5, Value6);

  Result := '';

  for I := 0 to 11 do
    Result := Result + BitsToString(ProductInfo, Bits, I * 5);

  Insert('-', Result, 5);
  Insert('-', Result, 10);

  Result := ProductInfo.Id + '-' + Result;
end;

end.
