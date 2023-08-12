program Keygen;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function GenerateRegCode: String;
const
  Charset1 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Charset2 = '68DW';
var
  I, J, K: Integer;
begin
  SetLength(Result, 15);

  repeat
    for I := 1 to 15 do
      Result[I] := Charset1[Random(Length(Charset1)) + 1];

    K := 0;

    for I := 1 to Length(Charset2) do
    begin
      J := Pos(Charset2[I], Result);

      if (J > 0) and (J < 15) then Inc(K);
    end;

  until K = 4;
end;

begin
  Randomize;

  WriteLn('PDFZilla 3.x Keygen [by RadiXX11]');
  WriteLn('=================================');
  WriteLn;
  WriteLn('Registration Code: ', GenerateRegCode);

  ReadLn;
end.
 