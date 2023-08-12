unit Licensing;

interface

type
  TProductInfo = record
    Name: String;
    Code: Byte;                         // unique product code
    MaxValue: Integer;                  // used for the serial value range check
    MinValues: array[0..1] of Integer;  // used for the serial value range check
  end;

const
  ProductList: array[0..12] of TProductInfo = (
    (
      Name: 'Addresses 3';
      Code: 3;
      MaxValue: $86470;
      MinValues: ($0, $5763E);
    ),
    {
    (
      Name: 'Budget book 6;
      Code: 2;
      MaxValue: $86470;
      MinValues: ($14307E, $60597);
    ),
    }
    // UPDATED 2020-04-06
    (
      Name: 'Budget book 7';
      Code: 2;
      MaxValue: $9EB10;
      MinValues: ($143C84, $6C02D);
    ),    
    (
      Name: 'Calendar 3';
      Code: 5;
      MaxValue: $86470;
      MinValues: ($0, $571D2);
    ),
    (
      Name: 'Cash book 9';
      Code: 12;
      MaxValue: $9EB10;
      MinValues: ($143C84, $6C040);
    ),
    (
      Name: 'Document Archive';
      Code: 27;
      MaxValue: $86470;
      MinValues: ($0, $0);
    ),
    (
      Name: 'Invoice 8';
      Code: 8;
      MaxValue: $927C0;
      MinValues: ($1435AE, $67703);
    ),
    (
      Name: 'Logbook 3';
      Code: 18;
      MaxValue: $86470;
      MinValues: ($14335E, $62EA6);
    ),
    (
      Name: 'MyMoney 3';
      Code: 11;
      MaxValue: $86470;
      MinValues: ($142DB7, $58B63);
    ),
    (
      Name: 'Photo calendar';
      Code: 9;
      MaxValue: MaxInt;
      MinValues: ($1, $1);
    ),
    (
      Name: 'Purchase journal';
      Code: 26;
      MaxValue: $7A120;
      MinValues: ($142DB7, $4B2BC);
    ),
    (
      Name: 'Receipt 4';
      Code: 13;
      MaxValue: $77A10;
      MinValues: ($0, $57AEB);
    ),
    (
      Name: 'Text Editor';
      Code: 25;
      MaxValue: $86470;
      MinValues: ($0, $4A768);
    ),
    (
      Name: 'Time Registration';
      Code: 23;
      MaxValue: MaxInt;
      MinValues: ($1, $1);
    )
  );

function GenerateLicNum(const ProductInfo: TProductInfo): String;

implementation

uses
  SysUtils;

function GenerateLicNum(const ProductInfo: TProductInfo): String;
const
  Table: array[0..9] of Byte = ($00, $29, $17, $1C, $0C, $11, $1F, $27, $2B, $05);
var
  I, J, K, L: Integer;
  Done: Boolean;
begin
  // Generate the Serial part (8 digits)

  repeat
    Result := '';
    K := 0;

    for I := 1 to 6 do
    begin
      J := Random(10);
      Result := Result + IntToStr(J);
      Inc(K, J);
    end;

    Result := Result + Format('%.2d', [K]);

    if Result[1] = '0' then
      Done := StrToInt(Result) >= ProductInfo.MinValues[0]
    else
      Done := StrToInt(Copy(Result, 1, 6)) >= ProductInfo.MinValues[1];

    Done := Done and (StrToInt(Copy(Result, 1, 6)) <= ProductInfo.MaxValue);

  until Done;

  // Calculate the Code part (checksum of the Serial part, 6 digits)

  if (Result[1] = '0') and (Result[8] <> '0') then
  begin
    J := Table[StrToInt(Result[8])];

    for I := 1 to 4 do
      Inc(J, StrToInt(Result[I]));

    L := (J + ProductInfo.Code) mod 100;
  end
  else
  begin
    J := 48;

    for I := 1 to 4 do
      Inc(J, StrToInt(Result[I]));

    L := ProductInfo.Code;
  end;

  K := 31;

  for I := 5 to 8 do
    Inc(K, StrToInt(Result[I]));

  Result := Result + Format('%.2d%.2d%.2d', [J, K, L]);

  // Format the result key with hypens

  Insert('-', Result, 5);
  Insert('-', Result, 10);
end;

end.
