program Activator;

{$APPTYPE CONSOLE}

{$R 'Resources.res' 'Resources.rc'}

uses
  Licensing in 'Licensing.pas';

var
  FileName, StrLicense: String;

begin
  Randomize;

  WriteLn('Clean Master for PC Activator [by RadiXX11]');
  WriteLn('===========================================');
  WriteLn;
  WriteLn('IMPORTANT: Close Clean Master before activate (check system tray)!');
  WriteLn;

  FileName := GetRegInfoFileName;

  if FileName <> '' then
  begin
    Write('License Info (anything you want, optional): ');
    ReadLn(StrLicense);
    WriteLn;

    if CreateRegInfoFile(FileName, GetMaxValidDays, StrLicense) then
      WriteLn('License file created successfully.')
    else
      WriteLn('Cannot create license file or process aborted!');
  end;

  ReadLn;
end.
