program Activator;

{$R 'Resources\Resources.res' 'Resources\Resources.rc'}

uses
  Forms,
  DCPbase64 in 'Units\DCPbase64.pas',
  DCPblockciphers in 'Units\DCPblockciphers.pas',
  DCPconst in 'Units\DCPconst.pas',
  DCPcrypt2 in 'Units\DCPcrypt2.pas',
  DCPrijndael in 'Units\DCPrijndael.pas',
  FormMain in 'Forms\FormMain.pas' {MainForm},
  HashUtils in 'Units\HashUtils.pas',
  Licensing in 'Units\Licensing.pas',
  MD5 in 'Units\MD5.pas',
  uSMBIOS in 'Units\uSMBIOS.pas',
  Utils in 'Units\Utils.pas';

{$R *.res}

begin
  Randomize;
  Application.Initialize;
  Application.Title := 'OhSoft oCam Activator';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.