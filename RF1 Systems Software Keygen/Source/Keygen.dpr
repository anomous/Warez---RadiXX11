program Keygen;

{$R 'Resources\Resources.res' 'Resources\Resources.rc'}

uses
  Forms,
  FormMain in 'Forms\FormMain.pas' {MainForm},
  Licensing in 'Units\Licensing.pas',
  Utils in 'Units\Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'RF1 Systems Software Keygen';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
