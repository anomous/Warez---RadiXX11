program Keygen;

{$R 'Resources\Resources.res' 'Resources\Resources.rc'}

uses
  Forms,
  Base64 in 'Units\Base64.pas',
  FormMain in 'Forms\FormMain.pas' {MainForm},
  HashUtils in 'Units\HashUtils.pas',
  Licensing in 'Units\Licensing.pas',
  SHA1 in 'Units\SHA1.pas',
  Utils in 'Units\Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Maxidix Products Keygen';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
