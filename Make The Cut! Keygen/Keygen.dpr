program Keygen;

{$APPTYPE CONSOLE}

uses
  CRC32,
  StrUtils,
  SysUtils;

function GenerateRegCode: String;
var
  S: String;
begin
  Result := 'MTC' + IntToHex(Random($100000), 5);
  S := CRC32ToString(CRC32FromString(ReverseString(Result)), True);
  Result := Result + '-' + S + '-' + ReverseString(CRC32ToString(CRC32FromString(S), True));
end;

begin
  // Make The Cut! - http://www.make-the-cut.com

  Randomize;

  WriteLn('Make The Cut! Keygen [by RadiXX11]');
  WriteLn('==================================');
  WriteLn;
  WriteLn('Registration Code: ', GenerateRegCode);

  ReadLn;
end.
