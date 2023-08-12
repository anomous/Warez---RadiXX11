unit Licensing;

interface

type
  TProductInfo = record
    Name: String;
    SecretWord: String;
    UsesSerial: Boolean;
  end;

const
  ProductCount = 4;
  ProductList: array[0..ProductCount - 1] of TProductInfo = (
    (
      Name: 'Kith and Kin Pro V3';
      SecretWord: 'LILIACEOUS';
      UsesSerial: True;
    ),
    (
      Name: 'Shop ''Til You Drop';
      SecretWord: 'NECROMANCY';
      UsesSerial: False;
    ),
    (
      Name: 'TreeDraw Legacy Edition V4';
      SecretWord: 'BITTERLING';
      UsesSerial: False;
    ),
    (
      Name: 'TreeDraw V4';
      SecretWord: 'TRIFURCATE';
      UsesSerial: True;
    )
  );

function GenerateRegKey(const ProductInfo: TProductInfo;
  const UserNameOrSerial: String): String;

implementation

uses
  SysUtils;

//------------------------------------------------------------------------------

function GenerateRegKey(const ProductInfo: TProductInfo;
  const UserNameOrSerial: String): String;
var
  S1, S2: String;
  I, Sum: Integer;
  C: Char;
begin
  if Length(ProductInfo.SecretWord) >= 10 then
  begin
    S1 := Trim(UserNameOrSerial);

    if ProductInfo.UsesSerial then
      S1 := UpperCase(S1);

    S2 := UpperCase(ProductInfo.SecretWord);

    while Length(S1) < 10 do
      S1 := S1 + S1;

    Sum := 0;
    C := '!';

    for I := 1 to Length(S1) do
    begin
      if S1[I] > 'z' then
      begin
        S1[I] := C;

        Inc(C);

        if C = 'z' then
          C := '!';
      end;
    
      Inc(Sum, Byte(S1[I]));
    end;

    SetLength(Result, 10);

    for I := 1 to 10 do
    begin
      Result[I] := Char((Byte(S1[I]) + Byte(S2[I]) + Sum) and $FF);

      while Result[I] > Char($5A) do
        Dec(Result[I], $1A);

      while Result[I] < Char($41) do
        Inc(Result[I], $1A);
    end;
  end
  else
    Result := '';
end;

end.
