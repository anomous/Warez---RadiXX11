program Keygen;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function GenerateRegCode(const Name: String): String;
var
  Value2: Int64;
  I, Value1: Integer;
begin
  Result := '';

  if Length(Name) < 2 then Exit;

  Value1 := 0;

  for I := 1 to Length(Name) do
    Inc(Value1, Byte(Name[I]));

  Value1 := $1D8 * (Abs($104 - Value1) + $14C);
  Result := IntToStr(Value1);
  SetLength(Result, 9);

  if Value1 > $F423F then
  begin
    Result[9] := Result[7];
    Result[7] := Result[6];
    Result[4] := Result[3];
    Result[3] := Result[2];
    Result[6] := Result[5];
    Value2 := Abs(((Byte(Result[9]) * 9) shl 2) - ((Byte(Result[7]) shl 6) - Byte(Result[7])));
    Result[8] := Char((((Value2 * 9) shl 2) mod 9) + $30);
    Value2 := Byte(Result[5]) + $20;
    Value2 := Abs(((((Byte(Result[4]) * 5) shl 3) - Byte(Result[4])) * 2) + (((((Value2 * 8) - Value2) * 4) + Value2) * 3));
    Result[5] := Char(((((((Value2 * 8) - Value2) * 4) + Value2) * 3) mod 9) + $30);
    Value2 := Abs((((((Byte(Result[1]) * 8) - Byte(Result[1])) * 4) + Byte(Result[1])) shl 1) - (((Byte(Result[2]) shl 4) + Byte(Result[2])) * 5));
    Result[2] := Char(((((((Value2 * 8) - Value2) * 4) + Value2) shl 1) mod 9) + $30);
  end
  else
  begin
    Result[7] := Result[5];
    Result[9] := Result[6];
    Result[6] := Result[4];
    Result[4] := Result[3];
    Result[3] := Result[2];
    Value2 := Abs((((Byte(Result[9]) * 5) shl 3) - Byte(Result[9])) - (((Byte(Result[5]) shl 5) - Byte(Result[5])) * 3));
    Result[8] := Char(((((Value2 * 5) shl 3) - Value2) mod 9) + 48);
    Value2 := Abs(((((Byte(Result[6]) * 9) * 4) + Byte(Result[6])) * 2) + (((Byte(Result[4]) * 3) shl 4) - Byte(Result[4])));
    Result[5] := Char((((((Value2 * 9) * 4) + Value2) shl 1) mod 9) + 48);
    Value2 := Abs(((((Byte(Result[1]) * 3) * 9) shl 1) - Byte(Result[1])) - (((Byte(Result[2]) * 8) - Byte(Result[2])) * 5));
    Result[2] := Char((((((Value2 * 3) * 9) shl 1) - Value2) mod 9) + 48);
  end;
end;

var
  Name, RegCode: String;

begin
  WriteLn('IrfanView Keygen [by RadiXX11]');
  WriteLn('==============================');
  WriteLn;

  Write('Name....: ');
  ReadLn(Name);

  RegCode := GenerateRegCode(Name);

  if RegCode <> '' then
    WriteLn('Reg Code: ', RegCode);

  ReadLn;
end.
