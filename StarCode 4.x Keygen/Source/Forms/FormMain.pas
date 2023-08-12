unit FormMain;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  jpeg, VistaAltFixUnit;

type
  TMainForm = class(TForm)
    Bevel: TBevel;
    btnAbout: TButton;
    btnCopyAK: TButton;
    btnCopyLK: TButton;
    btnGenerate: TButton;
    btnPasteMC: TButton;    
    edtMachineCode: TEdit;
    imgBanner: TImage;
    lblActivationKey: TLabel;
    lblHomepage: TLabel;
    lblLicenseKey: TLabel;
    lblMachineCode: TLabel;
    lblProductEdition: TLabel;
    mActivationKey: TMemo;
    mLicenseKey: TMemo;
    rbtLite: TRadioButton;
    rbtPlus: TRadioButton;
    rbtPro: TRadioButton;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyAKClick(Sender: TObject);
    procedure btnCopyLKClick(Sender: TObject);
    procedure btnPasteMCClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure edtMachineCodeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure OnEditionClick(Sender: TObject);
    procedure OnLinkClick(Sender: TObject);
    procedure OnLinkMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnLinkMouseEnter(Sender: TObject);
    procedure OnLinkMouseLeave(Sender: TObject);
    procedure OnLinkMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  License,
  ShellAPI,
  Utils;

//------------------------------------------------------------------------------

procedure TMainForm.btnAboutClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Format('%s'#13#10#13#10 +
    'Version 1.0'#13#10#13#10 +
    '© 2019, RadiXX11 [RdX11]', [Caption])), 'About', MB_ICONINFORMATION or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnCopyAKClick(Sender: TObject);
begin
  mActivationKey.SelectAll;
  mActivationKey.CopyToClipboard;
  mActivationKey.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnCopyLKClick(Sender: TObject);
begin
  mLicenseKey.SelectAll;
  mLicenseKey.CopyToClipboard;
  mLicenseKey.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnGenerateClick(Sender: TObject);
var
  LicenseKey, ActivationCode: String;
  Edition: TProductEdition;
begin
  if Trim(edtMachineCode.Text) <> '' then
  begin
    if rbtPro.Checked then
      Edition := pePro
    else if rbtPlus.Checked then
      Edition := pePlus
    else
      Edition := peLite;

    if GenerateKeys(Edition, edtMachineCode.Text, LicenseKey, ActivationCode) then
    begin
      mLicenseKey.Font.Color := clWindowText;
      mLicenseKey.Text := LicenseKey;
      mActivationKey.Text := ActivationCode;
      btnCopyLK.Enabled := True;
    end
    else
    begin
      mLicenseKey.Font.Color := clGrayText;
      mLicenseKey.Text := 'Incorrect Machine Code format!';
      mActivationKey.Text := mLicenseKey.Text;
      btnCopyLK.Enabled := False;
    end;
  end
  else
  begin
    mLicenseKey.Font.Color := clGrayText;
    mLicenseKey.Text := 'Enter your Machine Code...';
    mActivationKey.Text := mLicenseKey.Text;
    btnCopyLK.Enabled := False;
  end;

  mActivationKey.Font.Color := mLicenseKey.Font.Color;
  btnCopyAK.Enabled := btnCopyLK.Enabled;
  btnGenerate.Enabled := btnCopyLK.Enabled;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnPasteMCClick(Sender: TObject);
begin
  edtMachineCode.Clear;
  edtMachineCode.PasteFromClipboard;
end;

//------------------------------------------------------------------------------

procedure TMainForm.edtMachineCodeChange(Sender: TObject);
begin
  btnGenerate.Click;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Caption := Application.Title;
  rbtPro.Checked := True;
  
  lblHomepage.OnMouseLeave(lblHomepage);
  btnGenerate.Click;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnEditionClick(Sender: TObject);
begin
  btnGenerate.Click;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkClick(Sender: TObject);
begin
  if not OpenURL('https://www.invegix.com/starcode') then
    Application.MessageBox('Cannot open default web browser!', 'Error',
      MB_ICONWARNING or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TLabel).Font.Color := clHotlight;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkMouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clHighlight;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clHotlight;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TLabel).Font.Color := clHighlight;
end;

end.
