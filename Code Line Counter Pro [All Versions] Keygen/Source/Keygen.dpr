program Keygen;

{$R 'Resources\Resources.res' 'Resources\Resources.rc'}

uses
  Forms,
  FormMain in 'Forms\FormMain.pas' {MainForm},
  HashUtils in 'Units\HashUtils.pas',
  Licensing in 'Units\Licensing.pas',
  MD5 in 'Units\MD5.pas',  
  Utils in 'Units\Utils.pas';

{$R *.res}

begin
  Randomize;
  Application.Initialize;
  Application.Title := 'Code Line Counter Pro [All Versions] Keygen';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
