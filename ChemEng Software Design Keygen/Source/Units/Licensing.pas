unit Licensing;

interface

type
  TProductInfo = record
    Name: String;
    Code: String;
  end;

const
  ProductList: array[0..3] of TProductInfo = (
    (
      Name: 'ChemMaths Pro';
      Code: 'CHEM84022020';
    ),
    (
      Name: 'Data Pro';
      Code: 'DAPR81212020';
    ),
    (
      Name: 'Equation Pro';
      Code: 'EQPR81022020';
    ),
    (
      Name: 'ProsimGraphs Pro';
      Code: 'PRPR87032020';
    )
  );

function GenerateRegNum(const ProductInfo: TProductInfo): String;

implementation

uses
  SysUtils;

function GenerateRegNum(const ProductInfo: TProductInfo): String;
const
  Charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
  I: Integer;
begin
  SetLength(Result, 24);

  for I := 1 to Length(Result) do
    Result[I] := Charset[Random(Length(Charset)) + 1];

  Insert(ProductInfo.Code, Result, Random(Length(Result) + 1) + 1);
end;

end.
