program Activator;

uses
  Forms,
  FormMain in 'Forms\FormMain.pas' {MainForm},
  License in 'Units\License.pas',
  DCPbase64 in 'Units\DCPbase64.pas',
  DCPblockciphers in 'Units\DCPblockciphers.pas',
  DCPconst in 'Units\DCPconst.pas',
  DCPcrypt2 in 'Units\DCPcrypt2.pas',
  DCPrijndael in 'Units\DCPrijndael.pas';

{$R *.res}

begin
  Randomize;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '4K Download Products Activator';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
