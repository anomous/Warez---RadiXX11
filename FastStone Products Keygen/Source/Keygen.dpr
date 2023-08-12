program Keygen;

{$R 'Resources\Resources.res' 'Resources\Resources.rc'}

uses
  Forms,
  FormMain in 'Forms\FormMain.pas' {MainForm},
  DCPbase64 in 'Units\DCPbase64.pas',
  DCPblockciphers in 'Units\DCPblockciphers.pas',
  DCPblowfish in 'Units\DCPblowfish.pas',
  DCPconst in 'Units\DCPconst.pas',
  DCPcrypt2 in 'Units\DCPcrypt2.pas',
  DCPidea in 'Units\DCPidea.pas',
  DCPsha1 in 'Units\DCPsha1.pas',
  DCPsha512 in 'Units\DCPsha512.pas',
  Licensing in 'Units\Licensing.pas';

{$R *.res}

begin
  Randomize;
  Application.Initialize;
  Application.Title := 'FastStone Products Keygen';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
