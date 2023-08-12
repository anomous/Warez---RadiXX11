program Keygen;

{$R 'Resources\Resources.res' 'Resources\Resources.rc'}

uses
  Forms,
  FormMain in 'Forms\FormMain.pas' {MainForm},
  HostsFile in 'Units\HostsFile.pas',
  Licensing in 'Units\Licensing.pas',
  Utils in 'Units\Utils.pas';

{$R *.res}

begin
  Randomize;
  Application.Initialize;
  Application.Title := 'PGWARE Products Keygen';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
