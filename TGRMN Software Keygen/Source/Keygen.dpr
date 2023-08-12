program Keygen;

{$R 'Resources\Resources.res' 'Resources\Resources.rc'}

uses
  Forms,
  FormMain in 'Forms\FormMain.pas' {MainForm},
  CRC32 in 'Units\CRC32.pas',
  HashUtils in 'Units\HashUtils.pas',
  License in 'Units\License.pas',
  MD5 in 'Units\MD5.pas',
  Utils in 'Units\Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'TGRMN Software Keygen';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
