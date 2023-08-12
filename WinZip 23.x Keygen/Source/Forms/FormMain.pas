unit FormMain;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  jpeg, VistaAltFixUnit, Dialogs;

type
  TMainForm = class(TForm)
    Bevel: TBevel;
    btnAbout: TButton;
    btnActivate: TButton;
    btnCalculate: TButton;
    btnGenerate: TButton;
    btnSelectMUIFile: TButton;
    cboLicenseType: TComboBox;
    edtExponent: TEdit;
    edtModulus: TEdit;
    edtMUIFile: TEdit;
    edtName: TEdit;
    gboParameters: TGroupBox;
    gboRegistration: TGroupBox;
    imgBanner: TImage;
    lblExponent: TLabel;
    lblHomepage: TLabel;
    lblKey: TLabel;
    lblLicenseType: TLabel;
    lblModulus: TLabel;
    lblMUIFile: TLabel;
    lblName: TLabel;
    mKey: TMemo;
    OpenDialog: TOpenDialog;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnActivateClick(Sender: TObject);
    procedure btnCalculateClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure btnSelectMUIFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure lblHomepageClick(Sender: TObject);
    procedure lblHomepageMouseEnter(Sender: TObject);
    procedure lblHomepageMouseLeave(Sender: TObject);
    procedure OnChange(Sender: TObject);

  private
    procedure InitializeControls;
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
    '© 2019, RadiXX11 [RdX11]', [Caption])), 'About', MB_ICONINFORMATION or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnActivateClick(Sender: TObject);
begin
  if (edtName.Text <> '') and (mKey.Text <> '') then
  begin
    if ActivateProduct(edtName.Text, mKey.Text) then
      Application.MessageBox('Product activated sucessfully',
          PChar(Caption), MB_ICONINFORMATION or MB_OK)
    else
      Application.MessageBox('Error while trying to activate the product!',
          PChar(Caption), MB_ICONWARNING or MB_OK);
  end;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnCalculateClick(Sender: TObject);
var
  Exponent, Modulus: String;
begin
  if (edtMUIFile.Text <> '') and (cboLicenseType.ItemIndex > -1) then
  begin
    Screen.Cursor := crHourGlass;

    if GetParamsFromMUI(edtMUIFile.Text, TLicenseType(cboLicenseType.ItemIndex),
      Modulus, Exponent) then
    begin
      edtModulus.Text := Modulus;
      edtExponent.Text := Exponent;
    end
    else
      Application.MessageBox('Cannot calculate parameters! Wrong MUI file or internal error.',
        PChar(Caption), MB_ICONWARNING or MB_OK);

    Screen.Cursor := crDefault;
  end;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnGenerateClick(Sender: TObject);
begin
  if (Length(Trim(edtName.Text)) >= 2) and (edtExponent.Text <> '') and
    (edtModulus.Text <> '') then
  begin
    mKey.Font.Color := clWindowText;
    mKey.Text := GenerateKey(edtName.Text, edtModulus.Text, edtExponent.Text);
  end;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnSelectMUIFileClick(Sender: TObject);
begin
  OpenDialog.FileName := edtMUIFile.Text;

  if OpenDialog.Execute then
    edtMUIFile.Text := OpenDialog.FileName;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
begin
  InitializeControls;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormShow(Sender: TObject);
begin
  btnSelectMUIFile.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.InitializeControls;
var
  License: TLicenseType;
begin
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Caption := Application.Title;
  OpenDialog.InitialDir := GetcurrentDir;

  cboLicenseType.Items.BeginUpdate;

  for License := Low(TLicenseType) to High(TLicenseType) do
    cboLicenseType.Items.Add(LicenseTypes[License]);

  cboLicenseType.Items.EndUpdate;

  if cboLicenseType.Items.Count > 0 then
    cboLicenseType.ItemIndex := Integer(ltProfessionalEdition);

  edtName.Text := Utils.GetUserName;
  
  lblHomepage.OnMouseLeave(nil);
  edtMUIFile.OnChange(nil);
  OnChange(nil);
end;

//------------------------------------------------------------------------------

procedure TMainForm.lblHomepageClick(Sender: TObject);
begin
  if not OpenURL('https://www.winzip.com') then
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

//------------------------------------------------------------------------------

procedure TMainForm.OnChange(Sender: TObject);
begin
  cboLicenseType.Enabled := edtMUIFile.Text <> '';
  btnCalculate.Enabled := cboLicenseType.Enabled;
  btnGenerate.Enabled := (Length(Trim(edtName.Text)) >= 2) and
                          (edtExponent.Text <> '') and (edtModulus.Text <> '');
  btnActivate.Enabled := btnGenerate.Enabled;

  if not btnGenerate.Enabled then
  begin
    mKey.Font.Color := clGrayText;

    if edtMUIFile.Text = '' then
      mKey.Text := 'Select a MUI file...'
    else if (edtExponent.Text = '') or (edtModulus.Text = '') then
      mKey.Text := 'Select a license type and click Calculate...'
    else
      mKey.Text := 'Enter a name of at least 2 chars length...';
  end
  else
    btnGenerate.Click;
end;

end.
