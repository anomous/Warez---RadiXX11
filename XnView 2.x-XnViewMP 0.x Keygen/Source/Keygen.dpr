program Keygen;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Licensing in 'Licensing.pas';

var
  Name: String;

begin
  WriteLn('XnView 2.x/XnViewMP 0.x Keygen [by RadiXX11]');
  WriteLn('============================================');
  WriteLn;
  Write('Name: ');
  ReadLn(Name);

  if Name <> '' then
    WriteLn('Code: ', GenerateCode(Name));

  WriteLn;
  Write('Press ENTER to continue...');
  ReadLn;
end.
