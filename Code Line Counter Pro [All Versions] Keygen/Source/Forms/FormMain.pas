unit FormMain;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  jpeg, VistaAltFixUnit;

type
  TMainForm = class(TForm)
    Bevel: TBevel;  
    btnAbout: TButton;
    btnCopy: TButton;
    btnGenerate: TButton;
    cboLang: TComboBox;
    edtName: TEdit;
    imgBanner: TImage;
    lblHomepage: TLabel;
    lblCode: TLabel;
    lblName: TLabel;
    lblLang: TLabel;
    mCode: TMemo;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure edtNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure OnChange(Sender: TObject);
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
  Licensing,
  ShellAPI,
  Utils;

//------------------------------------------------------------------------------

procedure TMainForm.btnAboutClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Format('%s'#13#10#13#10 +
    'Version 1.0'#13#10#13#10 +
    '© 2019, RadiXX11', [Caption])), 'About', MB_ICONINFORMATION or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnCopyClick(Sender: TObject);
begin
  mCode.SelectAll;
  mCode.CopyToClipboard;
  mCode.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnGenerateClick(Sender: TObject);
begin
  if cboLang.ItemIndex >= 0 then
  begin
    mCode.Font.Color := clWindowText;
    mCode.Text := GenerateCode(VersionList[cboLang.ItemIndex], edtName.Text);
    btnCopy.Enabled := True;
  end
  else
    btnCopy.Enabled := False;
end;

//------------------------------------------------------------------------------

procedure TMainForm.edtNameChange(Sender: TObject);
begin
  OnChange(nil);
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Caption := Application.Title;

  cboLang.Items.BeginUpdate;

  for I := Low(VersionList) to High(VersionList) do
    cboLang.Items.Add(VersionList[I].Language);

  cboLang.Items.EndUpdate;

  if cboLang.Items.Count > 0 then
    cboLang.ItemIndex := 0;

  edtName.Text := GetUserName;

  if edtName.Text = '' then
    OnChange(nil);

  lblHomepage.OnMouseLeave(nil);
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormShow(Sender: TObject);
begin
  edtName.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnChange(Sender: TObject);
begin
  btnGenerate.Enabled := Trim(edtName.Text) <> '';

  if not btnGenerate.Enabled then
  begin
    mCode.Font.Color := clGrayText;
    mCode.Text := 'Enter a name...';
    btnCopy.Enabled := False;
  end
  else
    btnGenerate.Click;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkClick(Sender: TObject);
begin
  if not OpenURL('http://www.codelinecounter.com') then
    Application.MessageBox('Cannot open default web browser!', 'Error',
      MB_ICONWARNING or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  lblHomepage.Font.Color := clHotlight;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkMouseEnter(Sender: TObject);
begin
  lblHomepage.Font.Color := clHighlight;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkMouseLeave(Sender: TObject);
begin
  lblHomepage.Font.Color := clHotlight;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  lblHomepage.Font.Color := clHighlight;
end;

end.
