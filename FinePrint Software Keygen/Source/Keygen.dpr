program Keygen;

{$R 'Resources\Resources.res' 'Resources\Resources.rc'}

uses
  Forms,
  FormMain in 'Forms\FormMain.pas' {MainForm},
  License in 'Units\License.pas';

{$R *.res}

begin
  Randomize;
  Application.Initialize;
  Application.Title := 'FinePrint Software Keygen';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
