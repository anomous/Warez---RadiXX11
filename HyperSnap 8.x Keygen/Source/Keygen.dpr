program Keygen;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Licensing in 'Licensing.pas';

begin
  Randomize;

  WriteLn('HyperSnap 8.x Keygen [by RadiXX11]');
  WriteLn('==================================');
  WriteLn;
  WriteLn('License Key:');
  WriteLn;  
  WriteLn(GenerateLicenseKey('RadiXX11', 'Something', 5435));

  ReadLn;
end.
