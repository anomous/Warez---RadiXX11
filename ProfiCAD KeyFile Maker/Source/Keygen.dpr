program Keygen;

{$R 'Resources\Resources.res' 'Resources\Resources.rc'}

uses
  Forms,
  FormMain in 'Forms\FormMain.pas' {MainForm},
  KeyFile in 'Units\KeyFile.pas',
  Utils in 'Units\Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ProfiCAD KeyFile Maker';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
