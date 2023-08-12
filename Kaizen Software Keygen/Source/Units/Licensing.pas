unit Licensing;

interface

type
  TProductInfo = record
    Name: String;
    ProductId: Integer;
  end;

const
  ProductCount = 9;
  ProductList: array[0..ProductCount - 1] of TProductInfo = (
    (
      Name: 'Asset Manager 2018 Enterprise';
      ProductId: 11;
    ),
    (
      Name: 'Asset Manager 2018 Standard';
      ProductId: 10;
    ),
    (
      Name: 'Home Manager 2017';
      ProductId: 1;
    ),
    (
      Name: 'Training Manager 2018 Enterprise';
      ProductId: 13;
    ),
    (
      Name: 'Training Manager 2018 Standard';
      ProductId: 12;
    ),
    (
      Name: 'Vehicle Manager 2018';
      ProductId: 6;
    ),
    (
      Name: 'Vehicle Manager 2018 Fleet Edition';
      ProductId: 8;
    ),
    (
      Name: 'Vehicle Manager 2018 Fleet Network Edition';
      ProductId: 9;
    ),
    (
      Name: 'Vehicle Manager 2018 Professional Edition';
      ProductId: 7;
    )
  );

function GenerateLicenseKey(const ProductInfo: TProductInfo): String;

implementation

uses
  SysUtils;

function GenerateLicenseKey(const ProductInfo: TProductInfo): String;
var
  I, J, K: Integer;
begin
  Result := '';
  K := ProductInfo.ProductID - 1;

  for I := 1 to 7 do
  begin
    J := Random(10);
    Result := Result + IntToStr(J);
    Inc(K, J);
  end;

  Result := Result + Format('%.2d', [K]);
end;

end.
