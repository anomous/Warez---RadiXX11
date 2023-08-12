program Keygen;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function GenerateSerialCode: String;
const
  Charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Magic = 'WANG';
var
  I, J: Integer;
begin
  Result := StringOfChar(' ', 15);

  // Put the 'magic' chars scattered in the code
  for I := 1 to Length(Magic) do
  begin
    repeat
      J := Random(Length(Result) - 1) + 2;
    until Result[J] = ' ';

    Result[J] := Magic[I];
  end;

  // Fill the rest of the code with random chars
  for I := 1 to Length(Result) do
    if Result[I] = ' ' then
      Result[I] := Charset[Random(Length(Charset)) + 1];
end;

begin
  // PDF Anti-Copy - http://pdfanticopy.com 

  Randomize;

  WriteLn('PDF Anti-Copy Keygen [by RadiXX11]');
  WriteLn('==================================');
  WriteLn;
  WriteLn('Serial Code: ', GenerateSerialCode);

  ReadLn;
end.
