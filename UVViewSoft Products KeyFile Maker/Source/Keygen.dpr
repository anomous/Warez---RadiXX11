program Keygen;

{$R 'Resources\Resources.res' 'Resources\Resources.rc'}

uses
  Forms,
  FormMain in 'Forms\FormMain.pas' {MainForm},
  License in 'Units\License.pas',
  Utils in 'Units\Utils.pas';

{$R *.res}

begin
  Randomize;
  Application.Initialize;
  Application.Title := 'UVViewSoft Products KeyFile Maker';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
