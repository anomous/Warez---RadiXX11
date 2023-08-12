program Keygen;

{$APPTYPE CONSOLE}

uses
  Licensing,
  SysUtils;

var
  UserName: String;

begin
  Randomize;
  
  WriteLn('ES-Computing EditPlus 5.x Keygen [By RadiXX11]');
  WriteLn('==============================================');
  WriteLn;

  Write('User Name: ');
  ReadLn(UserName);

  if UserName <> '' then
    WriteLn('Reg Code.: ', GenerateRegCode(UserName));

  ReadLn;
end.
