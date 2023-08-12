program Activator;

{$R 'Resources\Resources.res' 'Resources\Resources.rc'}

uses
  Forms,
  FormMain in 'Forms\FormMain.pas' {MainForm},
  ECElGamal in 'Units\ECElGamal.pas',
  ECGFp in 'Units\ECGFp.pas',
  FGInt in 'Units\FGInt.pas',
  HashUtils in 'Units\HashUtils.pas',
  Licensing in 'Units\Licensing.pas',
  MD5 in 'Units\MD5.pas';

{$R *.res}

begin
  Randomize;
  Application.Initialize;
  Application.Title := 'eBook Converter Products Activator';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
