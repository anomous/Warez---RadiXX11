program Keygen;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function GenerateKey: String;
var
  I: Integer;
begin
  SetLength(Result, 33);
  
  for I := 1 to 33 do
  begin
    if (I mod 5) = 0 then
      Result[I] := '-'
    else
      Result[I] := IntToHex(Random(16), 1)[1];
  end;
end;

begin
  // ByteScout Desktop Apps - https://bytescout.com/download/download_freeware.html

  Randomize;
  WriteLn('ByteScout Desktop Apps Keygen [by RadiXX11]');
  WriteLn('===========================================');
  WriteLn;
  WriteLn('Key: ', GenerateKey);
  ReadLn;
end.
