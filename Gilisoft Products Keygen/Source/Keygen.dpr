program Keygen;

{$R 'Resources\Resources.res' 'Resources\Resources.rc'}

uses
  Forms,
  FormMain in 'Forms\FormMain.pas' {MainForm},
  License in 'Units\License.pas',
  HostsFile in 'Units\HostsFile.pas';

{$R *.res}

begin
  Randomize;
  Application.Initialize;
  Application.Title := 'Gilisoft Products Keygen';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
