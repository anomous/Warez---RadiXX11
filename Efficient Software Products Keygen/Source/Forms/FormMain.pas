unit FormMain;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  jpeg, Spin, VistaAltFixUnit;

type
  TMainForm = class(TForm)
    Bevel: TBevel;  
    btnAbout: TButton;
    btnCopy: TButton;
    btnGenerate: TButton;
    cboProduct: TComboBox;
    chkNetworkEdition: TCheckBox;
    edtMonths: TSpinEdit;
    edtUsers: TSpinEdit;
    gboLicType: TGroupBox;
    gboLicValidity: TGroupBox;
    imgBanner: TImage;
    lblHomepage: TLabel;
    lblMonths: TLabel;
    lblProduct: TLabel;
    lblRegCode: TLabel;
    lblUsers: TLabel;
    mRegCode: TMemo;
    rbAuthForUsers: TRadioButton;
    rbCompanyLicense: TRadioButton;
    rbLifetimeLicense: TRadioButton;
    rbValidForMonths: TRadioButton;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure lblHomepageClick(Sender: TObject);
    procedure lblHomepageMouseEnter(Sender: TObject);
    procedure lblHomepageMouseLeave(Sender: TObject);
    procedure OnChange(Sender: TObject);
    procedure OnEditChange(Sender: TObject);
    procedure OnEditKeyPress(Sender: TObject; var Key: Char);
    procedure OnLicValidityClick(Sender: TObject);
    procedure OnLicTypeClick(Sender: TObject);
    procedure lblHomepageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lblHomepageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

  private
    FInitializing: Boolean;
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
    'Version 1.1'#13#10#13#10 +
    '© 2019, RadiXX11 [RdX11]', [Caption])), 'About', MB_ICONINFORMATION or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnCopyClick(Sender: TObject);
begin
  mRegCode.SelectAll;
  mRegCode.CopyToClipboard;
  mRegCode.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnGenerateClick(Sender: TObject);
var
  LicValidity, AuthUsers: Word;
begin
  if cboProduct.ItemIndex >= 0 then
  begin
    if rbLifetimeLicense.Checked then
      LicValidity := $FFFF
    else
      LicValidity := edtMonths.Value;

    if rbCompanyLicense.Checked then
      AuthUsers := $FFFF
    else
      AuthUsers := edtUsers.Value;

    mRegCode.Text := GenerateRegCode(ProductList[cboProduct.ItemIndex],
                      LicValidity, AuthUsers, chkNetworkEdition.Checked);
    btnCopy.Enabled := True;
  end
  else
    btnCopy.Enabled := False;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  FInitializing := True;
  
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Caption := Application.Title;

  cboProduct.Items.BeginUpdate;

  for I := Low(ProductList) to High(ProductList) do
    cboProduct.Items.Add(ProductList[I].Name);

  cboProduct.Items.EndUpdate;

  if cboProduct.Items.Count > 0 then
    cboProduct.ItemIndex := 0;

  edtMonths.MaxLength := 5;
  edtMonths.MinValue := 1;
  edtMonths.MaxValue := $FFFF;
  edtMonths.Value := edtMonths.MaxValue;
  edtUsers.MaxLength := 5;
  edtUsers.MinValue := 1;
  edtUsers.MaxValue := $FFFF;
  edtUsers.Value := edtUsers.MaxValue;
  rbLifetimeLicense.Checked := True;
  rbLifetimeLicense.OnClick(nil);
  rbCompanyLicense.Checked := True;
  rbCompanyLicense.OnClick(nil);
  chkNetworkEdition.Checked := True;

  FInitializing := False;

  btnGenerate.Click;
  lblHomepage.OnMouseLeave(nil);
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

//------------------------------------------------------------------------------

procedure TMainForm.lblHomepageClick(Sender: TObject);
begin
  try
    ShellExecute(Handle, 'open', 'http://www.efficientsoftware.net', nil, nil, SW_SHOWNORMAL);
  except
    Application.MessageBox('Cannot open default web browser!', 'Error',
      MB_ICONWARNING or MB_OK);
  end;
end;

//------------------------------------------------------------------------------

procedure TMainForm.lblHomepageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  lblHomepage.Font.Color := clHotlight;
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

procedure TMainForm.lblHomepageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  lblHomepage.Font.Color := clHighlight;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnChange(Sender: TObject);
begin
  if not FInitializing then
    btnGenerate.Click;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnEditChange(Sender: TObject);
begin
  if not FInitializing then
  begin
    if (Sender as TSpinEdit).Text = '' then
      (Sender as TSpinEdit).Text := IntToStr((Sender as TSpinEdit).MinValue);

    btnGenerate.Click;
  end;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnEditKeyPress(Sender: TObject; var Key: Char);
begin
  if not FInitializing then
  begin
    if not (Key in ['0'..'9', #8]) then
      Key := #0;

    btnGenerate.Click;
  end;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLicValidityClick(Sender: TObject);
begin
  if rbLifetimeLicense.Checked then
  begin
    edtMonths.Enabled := False;
    lblMonths.Enabled := False;
  end
  else
  begin
    edtMonths.Enabled := True;
    lblMonths.Enabled := True;

    if Visible then
      edtMonths.SetFocus;
  end;

  if not FInitializing then
    btnGenerate.Click;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLicTypeClick(Sender: TObject);
begin
  if rbCompanyLicense.Checked then
  begin
    edtUsers.Enabled := False;
    lblUsers.Enabled := False;
  end
  else
  begin
    edtUsers.Enabled := True;
    lblUsers.Enabled := True;

    if Visible then
      edtUsers.SetFocus;
  end;

  if not FInitializing then
    btnGenerate.Click;
end;

end.
