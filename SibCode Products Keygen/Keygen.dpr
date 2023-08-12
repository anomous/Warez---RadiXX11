program Keygen;

{$APPTYPE CONSOLE}

uses
  SysUtils;

const
  ProductCount = 8;
  ProductList: array[0..ProductCount - 1] of String = (
    'Sib Cursor Editor',
    'Sib Font Editor',
    'Sib Icon Converter',
    'Sib Icon Editor',
    'Sib Icon Extractor',
    'Sib Icon Replacer',
    'Sib Icon Studio',
    'Sib Image Viewer'
  );

//------------------------------------------------------------------------------

function GenerateKey(const ProductName: String): String;
const
  KeyCharset = '2345679qwertyupadfghjkzxcvbnms';
var
  I, NameLen, KeyLen, Value: Integer;
  S: String;
begin
  Result := '';
  NameLen := Length(ProductName);

  if NameLen <> 0 then
  begin
    KeyLen := 10 + Random(11);

    SetLength(Result, KeyLen);

    for I := 1 to KeyLen do
      Result[I] := KeyCharset[Random(Length(KeyCharset)) + 1];

    Value := 0;

    for I := 1 to NameLen - 1 do
      Inc(Value, Ord(ProductName[I]));

    Value := (Value mod $1E) + 1;

    Result[2] := KeyCharset[Value];

    Value := 0;

    for I := 2 to KeyLen - 1 do
      Value := Value xor Ord(Result[I]);

    Value := (Value mod $1E) + 1;

    Result[KeyLen] := KeyCharset[Value];

    S := LowerCase(ProductName);

    if Pos(S[1], KeyCharset) = 0 then
    begin
      Value := 0;

      for I := 1 to NameLen - 1 do
        Value := Value xor Ord(ProductName[I]);

      Value := (Value mod $1E) + 1;

      Result[1] := KeyCharset[Value];
    end;
  end;
end;

//------------------------------------------------------------------------------

var
  Option: String;
  I: Integer;
  Done: Boolean;

begin
  Randomize;

  WriteLn('SibCode Products Keygen [by RadiXX11]');
  WriteLn('=====================================');
  WriteLn;

  Done := False;

  repeat
    for I := Low(ProductList) to High(ProductList) do
      WriteLn(I + 1, '. ', ProductList[I]);

    WriteLn('0. Exit');
    WriteLn;
    Write('Enter an option and hit ENTER: ');
    ReadLn(Option);
    WriteLn;

    if TryStrToInt(Option, I) then
    begin
      if I > 0 then
      begin
        Dec(I);

        if (I >= Low(ProductList)) and (I <= High(ProductList)) then
        begin
          WriteLn(StringOfChar('-', 79));
          WriteLn('Product: ', ProductList[I]);
          WriteLn('Key....: ', GenerateKey(ProductList[I]));
          WriteLn(StringOfChar('-', 79));
          WriteLn;
        end;
      end
      else
        Done := True;
    end;
  until Done;
end.
