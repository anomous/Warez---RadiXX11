program Keygen;

{$R 'Resources\Resources.res' 'Resources\Resources.rc'}

uses
  Forms,
  FormMain in 'Forms\FormMain.pas' {MainForm},
  HostsFile in 'Units\HostsFile.pas',
  License in 'Units\License.pas',
  Utils in 'Units\Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SolidDocuments Products Keygen';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
