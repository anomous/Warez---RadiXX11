unit License;

interface

type
  TProductInfo = record
    Name: String;
    ProductId: String;
  end;

const
  ProductCount = 7;
  ProductList: array[0..ProductCount - 1] of TProductInfo = (
    (
      Name: 'Solid Automator v10';
      ProductId: 'SolidAutomatorv10';
    ),
    (
      Name: 'Solid Commander v10';
      ProductId: 'SolidCommanderv10';
    ),
    (
      Name: 'Solid Converter v10';
      ProductId: 'SolidConverterPDFv10';
    ),
    (
      Name: 'Solid PDFA Express v10';
      ProductId: 'SolidPDFAExpressv10';
    ),
    (
      Name: 'Solid PDF Tools v10';
      ProductId: 'SolidPDFToolsv10';
    ),
    (
      Name: 'Solid PDF to Word v10';
      ProductId: 'SolidPDFtoWordv10';
    ),
    (
      Name: 'Solid Scan to Word v10';
      ProductId: 'SolidScantoWordv10';
    )
  );

function GenerateUnlockCode(const ProductInfo: TProductInfo;
  const EMail: String): String;

implementation

uses
  SysUtils;

//------------------------------------------------------------------------------
  
function StringChecksum(const S: String): Integer;
var
  I, J: Integer;
begin
  Result := 0;
  J := 0;

  for I := 1 to Length(S) do
  begin
    Inc(J, Byte(S[I]) + 13);
    Inc(Result, J);
  end;

  Result := J + (Result shl 16);
end;

//------------------------------------------------------------------------------

function GenerateUnlockCode(const ProductInfo: TProductInfo;
  const EMail: String): String;
const
  Charset = 'bcdfghkmnpqrstvwxyz';
var
  Checksum: Integer;
begin
  Result := '';
  Checksum := StringChecksum(LowerCase(StringReplace(ProductInfo.ProductId, ' ',
              '', [rfReplaceAll]) + EMail));

  while (Checksum <> 0) and (Length(Result) < 4) do
  begin
    Result := Result + Charset[Abs(Checksum mod Length(Charset)) + 1];
    Checksum := Checksum div Length(Charset);
  end;

  Result := UpperCase(Result);
end;

end.
