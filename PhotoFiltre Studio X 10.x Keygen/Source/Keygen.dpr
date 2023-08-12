program Keygen;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function GenerateRegKey(const Name: String): String;
const
  Data: array[0..6] of Byte = ($7B, $4D, $86, $4E, $63, $45, $BC);
var
  S: String;
  I, T: Integer;
begin
  Result := '';

  if Length(Name) >= 5 then
  begin
    S := StringReplace(LowerCase(Name), ' ', '', [rfReplaceAll]);
    T := 0;

    for I := Length(S) downto 1 do
      T := T + Byte(S[I]) - I;

    S := Format('%.3d%.2d01234', [T mod $3E8, Length(S) mod $64]);

    for I := 1 to 10 do
      Result := Result + IntToHex(Data[I mod 7] xor Byte(S[I]), 2);

    Insert('-', Result, 6);
    Insert('-', Result, 12);
    Insert('-', Result, 18);
  end;
end;

var
  Name, Key: String;

begin
  WriteLn('PhotoFiltre Studio X 10.x Keygen [by RadiXX11]');
  WriteLn('==============================================');

  repeat
    WriteLn;
    Write('Name: ');
    ReadLn(Name);

    if Name <> '' then
    begin
      Key := GenerateRegKey(Name);

      if Key = '' then
      begin
        WriteLn;
        WriteLn('Name must have at least 5 chars!');
      end
      else
        WriteLn('Key : ', Key);
    end
    else
      Break;
      
  until Key <> '';

  ReadLn;
end.
