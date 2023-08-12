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
    cboLicenseType: TComboBox;
    edtLicenseKey: TEdit;
    edtName: TEdit;
    imgBanner: TImage;
    lblHomepage: TLabel;
    lblLicenseKey: TLabel;
    lblLicenseType: TLabel;
    lblName: TLabel;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure OnChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure lblHomepageClick(Sender: TObject);
    procedure lblHomepageMouseEnter(Sender: TObject);
    procedure lblHomepageMouseLeave(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  Licensing,
  Utils;

//------------------------------------------------------------------------------

procedure TMainForm.btnAboutClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Format('%s'#13#10#13#10 +
    'Version 1.0'#13#10#13#10 +
    '© 2020, RadiXX11', [Caption])), 'About', MB_ICONINFORMATION or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnCopyClick(Sender: TObject);
begin
  edtLicenseKey.SelectAll;
  edtLicenseKey.CopyToClipboard;
  edtLicenseKey.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnChange(Sender: TObject);
begin
  if (Trim(edtName.Text) <> '') and (cboLicenseType.ItemIndex >= 0) then
  begin
    edtLicenseKey.Font.Color := clWindowText;
    edtLicenseKey.Text := GetLicenseKey(edtName.Text, TLicenseType(cboLicenseType.ItemIndex));
  end
  else
  begin
    edtLicenseKey.Font.Color := clGrayText;
    edtLicenseKey.Text := 'Enter a name...';
  end;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
var
  LT: TLicenseType;
begin
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Caption := Application.Title;
  lblHomepage.OnMouseLeave(nil);

  cboLicenseType.Items.BeginUpdate;
  for LT := Low(TLicenseType) to High(TLicenseType) do
    cboLicenseType.Items.Add(LicenseTypes[LT]);
  cboLicenseType.Items.EndUpdate;
  cboLicenseType.ItemIndex := 0;

  edtName.Text := GetUserName;
  edtName.OnChange(nil);
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

procedure TMainForm.lblHomepageClick(Sender: TObject);
begin
  if not OpenURL('https://www.smadav.net') then
    Application.MessageBox('Cannot open default web browser!', 'Error',
      MB_ICONWARNING or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.lblHomepageMouseEnter(Sender: TObject);
begin
  lblHomepage.Font.Color := clHighlight;
end;

//------------------------------------------------------------------------------

procedure TMainForm.lblHomepageMouseLeave(Sender: TObject);
begin
  lblHomepage.Font.Color := clHotlight;
end;

end.
