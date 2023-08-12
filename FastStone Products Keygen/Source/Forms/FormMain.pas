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
    cboLicense: TComboBox;
    cboProduct: TComboBox;
    edtLicenseCount: TEdit;
    edtName: TEdit;
    edtRegCode: TMemo;
    imgBanner: TImage;
    lblHomepage: TLabel;
    lblLicense: TLabel;
    lblLicenseCount: TLabel;
    lblName: TLabel;
    lblProduct: TLabel;
    lblRegCode: TLabel;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure lblHomepageClick(Sender: TObject);
    procedure lblHomepageMouseEnter(Sender: TObject);
    procedure lblHomepageMouseLeave(Sender: TObject);
    procedure OnChange(Sender: TObject);
    procedure OnCloseUp(Sender: TObject);

    procedure InitializeControls;
    procedure UpdateControls;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  Licensing,
  ShellAPI;

//------------------------------------------------------------------------------

procedure TMainForm.btnAboutClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Format('%s'#13#10#13#10 +
    'Version 1.2'#13#10#13#10 +
    '© 2018, RadiXX11', [Caption])), 'About', MB_ICONINFORMATION or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnCopyClick(Sender: TObject);
begin
  edtRegCode.SelectAll;
  edtRegCode.CopyToClipboard;
  edtRegCode.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnGenerateClick(Sender: TObject);
var
  RegCode: String;
  LicenseCount: Integer;
begin
  LicenseCount := 0;

  TryStrToInt(edtLicenseCount.Text, LicenseCount);

  if GenerateRegCode(ProductList[cboProduct.ItemIndex], edtName.Text,
    TLicenseType(cboLicense.ItemIndex), LicenseCount, RegCode) then
  begin
    edtRegCode.Font.Color := clWindowText;
    btnCopy.Enabled := True;
  end
  else
  begin
    edtRegCode.Font.Color := clBtnShadow;
    btnCopy.Enabled := False;
  end;

  edtRegCode.Text := RegCode;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Caption := Application.Title;

  InitializeControls;
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
  UpdateControls;
  OnCloseUp(nil);
end;

//------------------------------------------------------------------------------

procedure TMainForm.InitializeControls;
var
  I: Integer;
  LicenseType: TLicenseType;
begin
  edtLicenseCount.MaxLength := 4;
  edtLicenseCount.Text := '1';

  cboProduct.Items.BeginUpdate;
  cboProduct.Items.Clear;

  try
    for I := Low(ProductList) to High(ProductList) do
      cboProduct.Items.Add(ProductList[I].Name);

  finally
    cboProduct.Items.EndUpdate;
  end;

  if cboProduct.Items.Count > 0 then
    cboProduct.ItemIndex := 0;

  cboLicense.Items.BeginUpdate;
  cboLicense.Items.Clear;

  try
    for LicenseType := Low(TLicenseType) to High(TLicenseType) do
      cboLicense.Items.Add(LicenseList[LicenseType].Name);

  finally
    cboLicense.Items.EndUpdate;
  end;

  if cboLicense.Items.Count > 0 then
    cboLicense.ItemIndex := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.lblHomepageClick(Sender: TObject);
begin
  try
    ShellExecute(Handle, 'open', 'http://www.faststone.org', nil, nil,
      SW_SHOWNORMAL);
  except
    Application.MessageBox('Cannot open default web browser!', 'Error',
      MB_ICONWARNING or MB_OK);
  end;
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
  UpdateControls;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnCloseUp(Sender: TObject);
begin
  if cboLicense.ItemIndex >= 0 then
  begin
    if LicenseList[TLicenseType(cboLicense.ItemIndex)].Count < 0 then
    begin
      edtLicenseCount.Enabled := True;
      edtLicenseCount.SetFocus;
      Exit;
    end;
  end;

  if Trim(edtName.Text) = '' then
    edtName.SetFocus
  else
    edtRegCode.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.UpdateControls;
begin
  if cboLicense.ItemIndex >= 0 then
    edtLicenseCount.Enabled := LicenseList[TLicenseType(cboLicense.ItemIndex)].Count < 0
  else
    edtLicenseCount.Enabled := False;

  btnGenerate.Enabled := (Trim(edtName.Text) <> '') and
                          (cboProduct.ItemIndex >= 0) and
                          (cboLicense.ItemIndex >= 0);
  btnCopy.Enabled := False;                          

  if not btnGenerate.Enabled then
  begin
    edtRegCode.Font.Color := clBtnShadow;
    edtRegCode.Text := 'Enter a name of at least 3 characters...';
  end
  else
    btnGenerate.Click;
end;

end.
