program LicGen;

{$R 'Resources\Resources.res' 'Resources\Resources.rc'}

uses
  Forms,
  FormMain in 'Forms\FormMain.pas' {MainForm},
  Licensing in 'Units\Licensing.pas',
  SynZip in 'Units\SynZip.pas',
  Utils in 'Units\Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'MobaXterm LicGen';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
