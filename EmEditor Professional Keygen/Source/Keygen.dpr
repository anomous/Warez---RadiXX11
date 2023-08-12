program Keygen;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  License in 'License.pas';

begin
  Randomize;
  WriteLn('EmEditor Professional Keygen [by RadiXX11]');
  WriteLn('==========================================');
  WriteLn;

  // Use any date between today's date and GetMaxExpirationDate, or use
  // GetMinExpirationDate to have a lifetime license key.
  WriteLn('Key: ', GenerateKey(GetMinExpirationDate));
  
  WriteLn;
  Write('Press ENTER to continue...');
  ReadLn;
end.

