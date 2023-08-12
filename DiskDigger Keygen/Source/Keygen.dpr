program Keygen;

{$APPTYPE CONSOLE}

uses
  Licensing in 'Licensing.pas';

var
  Name, EMail: String;

begin
  Randomize;

  WriteLn('DiskDigger Keygen [by RadiXX11]');
  WriteLn('===============================');
  WriteLn;
  Write('Name..: ');
  ReadLn(Name);
  Write('EMail.: ');
  ReadLn(EMail);
  WriteLn('Serial: ', GenerateSerial(Name, EMail));

  ReadLn;
end.
