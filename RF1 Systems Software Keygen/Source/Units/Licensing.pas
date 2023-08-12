unit Licensing;

interface

type
  TProductInfo = record
    Name: String;
    Code: Byte;
  end;

const
  ProductCount = 13;
  ProductList: array[0..ProductCount - 1] of TProductInfo = (
    (
      Name: 'BackUp Utility';
      Code: 2;
    ),
    (
      Name: 'Media Explorer';
      Code: 9;
    ),
    (
      Name: 'MIDI Tracker';
      Code: 14;
    ),
    (
      Name: 'NotePad SX Pro';
      Code: 7;
    ),
    (
      Name: 'Password Generator';
      Code: 10;
    ),
    (
      Name: 'Player';
      Code: 10;
    ),
    (
      Name: 'Rename Easy';
      Code: 13;
    ),
    (
      Name: 'SaveCD';
      Code: 1;
    ),
    (
      Name: 'SiteMan';
      Code: 4;
    ),
    (
      Name: 'StackUp Pro';
      Code: 8;
    ),
    (
      Name: 'Synchronizer SX';
      Code: 6;
    ),
    (
      Name: 'Unit Converter Pro';
      Code: 12;
    ),
    (
      Name: 'WaveEd';
      Code: 5;
    )
  );

function GenerateCode(const ProductInfo: TProductInfo; const Name: String): String;

implementation

uses
  SysUtils;

function GenerateCode(const ProductInfo: TProductInfo; const Name: String): String;
var
  Value: Int64;
  I, J: Integer;
begin
  Result := '';
  Value := (ProductInfo.Code + 1) * $12BBBCE92CC;

  for I := 1 to Length(Name) do
    Value := Value * Byte(Name[I]);

  for I := 0 to Length(Name) - 1 do
    Value := I * Byte(Name[Length(Name) - I]) + Value * (Byte(Name[I + 1]) + 7);

  if Value < 0 then
    Value := -Value;

  for I := 0 to 7 do
  begin
    if (I > 0) and ((I mod 4) = 0) then
      Result := Result + '-';

    J := Value mod 62;
    Value := Value div 62;

    if J < 10 then
      Result := Result + IntToStr(J)
    else if (J - 10) < 26 then
      Result := Result + Char(J + 87)
    else if (J - 36) < 26 then
      Result := Result + Char(J + 29);
  end;
end;

end.
