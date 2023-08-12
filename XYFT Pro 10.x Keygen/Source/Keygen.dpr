program Keygen;

{$APPTYPE CONSOLE}

uses
  Math,
  SysUtils;

//------------------------------------------------------------------------------

const
  Charset: array[0..9] of String = (
    'RFIY',
    '0HW9',
    '*3PD',
    'CG2N',
    'A+JO',
    'UL48',
    '7KMT',
    '$XV%',
    '6Q5B',
    'S1EZ'
  );

//------------------------------------------------------------------------------

function GenerateKeyCode: String;
var
  S1, S2: String;
  I, J: Integer;
begin
  I := StrToInt(FormatDateTime('yyyymmdd', Now));
  S1 := Format('%.8d', [RandomRange(I - 36499, I)]);

  // Unused random char
  J := Random(10);
  Result := Charset[J][Random(Length(Charset[J])) + 1];

  // Left padding with 2 zeros when decoded
  for I := 1 to 2 do
    Result := Result + Charset[0][Random(Length(Charset[0])) + 1];

  // Encode value digits
  for I := 1 to 8 do
  begin
    S2 := Charset[StrToInt(S1[I])];
    Result := Result + S2[Random(Length(S2)) + 1];
  end;

  // Unused random chars
  for I := 1 to 7 do
  begin
    J := Random(10);
    Result := Result + Charset[J][Random(Length(Charset[J])) + 1];
  end;
end;

//------------------------------------------------------------------------------

begin
  // XYFT Pro - https://xyfamilytree.com

  Randomize;

  WriteLn('XYFT Pro 10.x Keygen [by RadiXX11]');
  WriteLn('==================================');
  WriteLn;
  WriteLn('Key Code: ', GenerateKeyCode);
  WriteLn;
  
  ReadLn;
end.
