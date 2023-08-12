program Keygen;

{$APPTYPE CONSOLE}

uses
  Licensing in 'Licensing.pas';

var
  EMail: String;

begin
  Randomize;

  WriteLn('ZDSoft Screen Recorder Keygen [by RadiXX11]');
  WriteLn('===========================================');
  WriteLn;
  Write('EMail: ');

  ReadLn(EMail);

  if EMail <> '' then
    WriteLn('Key..: ', GenerateKey(EMail));

  ReadLn;
end.
 