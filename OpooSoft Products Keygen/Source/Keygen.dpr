program Keygen;

{$R 'Resources\Resources.res' 'Resources\Resources.rc'}

uses
  Forms,
  FormMain in 'Forms\FormMain.pas' {MainForm},
  LicenseCode in 'Units\LicenseCode.pas';

{$R *.res}

begin
  Randomize;
  Application.Initialize;
  Application.Title := 'OpooSoft Products Keygen';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
