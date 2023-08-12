unit Licensing;

interface

type
  TLicenseType = (ltDefault, ltFriendly, ltSingleUser, ltSite);
  TKeyFormat = (kfNew, kfOld);

type
  TProductInfo = record
    Name: String;
    Id: String;
    KeyFormat: TKeyFormat;
  end;

const
  LicenseTypeStr: array[TLicenseType] of String = (
    'Default',
    'Friendly',
    'Single-User',
    'Site'
  );

  ProductCount = 4;
  ProductList: array[0..ProductCount - 1] of TProductInfo = (
    (
      Name: 'FairStars Audio Converter';
      Id: 'GTBdw271';
      KeyFormat: kfOld;
    ),
    (
      Name: 'FairStars Audio Converter Pro';
      Id: 'GTBdq211';
      KeyFormat: kfNew;
    ),
    (
      Name: 'FairStars MP3 Recorder';
      Id: 'GTNqs311';
      KeyFormat: kfOld;
    ),
    (
      Name: 'FairStars Recorder';
      Id: 'GTSfd411';
      KeyFormat: kfOld;
    )
  );

function GenerateKey(const ProductInfo: TProductInfo; LicenseType: TLicenseType;
  Clients: Byte): String;

implementation

uses
  SysUtils;

//------------------------------------------------------------------------------
  
function Reverse1(Value: Integer): Char;
begin
  if Value <= 9 then
    Result := Char(Byte('0') + Value)
  else
    Result := Char(Byte('7') + Value);
end;

//------------------------------------------------------------------------------

procedure Reverse2(A, B: Char; License, Value: Integer; var E, F: Char);
var
  X, Y: Integer;
begin
  repeat
    X := Random(36);
    Y := Byte(A) - (15 * X - Byte(B) - License - (Value * 2)) + 1;
  until (Y >= 0) and (Y <= 35);
  E := Reverse1(Y);
  F := Reverse1(X);
end;

//------------------------------------------------------------------------------

function GenerateKey(const ProductInfo: TProductInfo; LicenseType: TLicenseType;
  Clients: Byte): String;
const
  Charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
  Key1, Key2: String;
  I, License, Value: Integer;
  A, B: Char;
begin
  SetLength(Key1, 8);

  for I := 1 to 8 do
    Key1[I] := Charset[Random(Length(Charset)) + 1];

  case LicenseType of
    ltFriendly:
    begin
      Key1[1] := 'F';
      License := 2;
    end;

    ltSingleUser:
    begin
      Key1[1] := 'N';
      License := 0;
    end;

    ltSite:
      begin
        Key1[1] := 'U';

        if Clients <= 9 then
          Key1[2] := Reverse1(Clients)
        else
          Key1[2] := '0';

        License := 1;
      end;

    else
      License := 3;
  end;

  Value := Random(10);
  Key1[8] := Reverse1(Value);
  Key2 := '';

  for I := 1 to 8 do
  begin
    Reverse2(Key1[I], ProductInfo.Id[I], License, Value, A, B);
    Key2 := Key2 + A + B;
  end;

  case ProductInfo.KeyFormat of
    kfNew:
      Result := Key1 + '-' + Key2;

    kfOld:
    begin
      Result := Key1 + '-' + Key2;
      Insert('-', Result, 14);
      Insert('-', Result, 19);
      Insert('-', Result, 24);
    end;
  end;
end;

end.
 