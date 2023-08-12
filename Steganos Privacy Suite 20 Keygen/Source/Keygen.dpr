program Keygen;

{$R 'Resources\Resources.res' 'Resources\Resources.rc'}

uses
  Forms,
  FormMain in 'Forms\FormMain.pas' {MainForm},
  HashUtils in 'Units\HashUtils.pas',  
  Licensing in 'Units\Licensing.pas',
  SHA1 in 'Units\SHA1.pas';

{$R *.res}

begin
  Randomize;
  Application.Initialize;
  Application.Title := 'Steganos Privacy Suite 20 Keygen';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
