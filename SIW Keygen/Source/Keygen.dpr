program Keygen;

{$APPTYPE CONSOLE}

uses
  Licensing,
  SysUtils;

var
  Name, Key: String;

begin
  Randomize;
  
  WriteLn('SIW (System Information for Windows) Keygen [by RadiXX11]');
  WriteLN('=========================================================');
  WriteLn;

  Write('Name: ');
  ReadLn(Name);
  WriteLn;

  if Trim(Name) <> '' then
  begin
    Key := GenerateKey;

    if CreateLicenseFile('siw.lic', Name, Key) then
    begin
      WriteLn(StringOfChar('=', 79));
      WriteLn('Name: ', Name);
      WriteLn('Key.: ', Key);
      WriteLn(StringOfChar('=', 79));      
      WriteLn;
      WriteLn('License file created successfully.');
    end
    else
      WriteLn('Error while creating license file!');
  end;

  Readln;
end.
