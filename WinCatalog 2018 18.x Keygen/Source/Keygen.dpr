program Keygen;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function GenerateRegCode: String;
const
  Charset: PChar = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
  Code: array[0..6] of Char;
  I, T: Integer;
begin
  repeat
    T := 0;

    for I := 0 to 6 do
    begin
      Code[I] := Charset[Random(36)];
      Inc(T, Byte(Code[I]));
    end;
  until (T mod 29) = 0;

  Result := 'WC18';

  for I := 0 to 1 do
    Result := Result + Charset[Random(36)];

  Result := Result + '-';

  for I := 0 to 6 do
    Result := Result + Code[I];

  Result := Result + '-';

  for I := 0 to 6 do
    Result := Result + Charset[Random(36)];

  Result := Result + '-';

  for I := 0 to 7 do
    Result := Result + Charset[Random(36)];

  Result := Result + '-';

  for I := 0 to 8 do
    Result := Result + Charset[Random(36)];
end;

begin
  Randomize;

  WriteLn('WinCatalog 2018 18.x Keygen [By RadiXX11]');
  WriteLn('=========================================');
  WriteLn;
  WriteLn('Reg Code: ', GenerateRegCode);

  ReadLn;
end.
