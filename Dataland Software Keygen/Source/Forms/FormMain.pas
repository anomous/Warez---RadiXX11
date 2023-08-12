unit FormMain;

interface

uses
  Windows, SysUtils, Classes, Graphics, ComCtrls, Controls, Forms, StdCtrls,
  ExtCtrls, jpeg, VistaAltFixUnit;

type
  TMainForm = class(TForm)
    Bevel: TBevel;
    btnAbout: TButton;
    btnCopy: TButton;
    btnGenerate: TButton;
    cboProduct: TComboBox;
    chkLicenseExpiration: TCheckBox;
    chkProBusinessEdition: TCheckBox;
    chkSiteLicense: TCheckBox;
    chkUpgradesExpiration: TCheckBox;
    dtpLicenseExpiration: TDateTimePicker;
    dtpUpgradesExpiration: TDateTimePicker;
    edtKey: TMemo;
    edtName: TEdit;
    gboLicenseOptions: TGroupBox;
    imgBanner: TImage;
    lblHomepage: TLabel;
    lblKey: TLabel;
    lblName: TLabel;
    lblProduct: TLabel;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure cboProductChange(Sender: TObject);
    procedure cboProductDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure chkLicenseExpirationClick(Sender: TObject);
    procedure chkUpgradesExpirationClick(Sender: TObject);
    procedure edtNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure lblHomepageClick(Sender: TObject);
    procedure lblHomepageMouseEnter(Sender: TObject);
    procedure lblHomepageMouseLeave(Sender: TObject);
    procedure OnCheckBoxClick(Sender: TObject);
    procedure OnDateChange(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  License,
  ShellAPI;

//------------------------------------------------------------------------------

procedure TMainForm.btnAboutClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Format('%s'#13#10#13#10 +
    'Version 1.0'#13#10#13#10 +
    '© 2018, RadiXX11', [Caption])), 'About', MB_ICONINFORMATION or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnCopyClick(Sender: TObject);
begin
  edtKey.SelectAll;
  edtKey.CopyToClipboard;
  edtKey.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnGenerateClick(Sender: TObject);
var
  Key: String;
  LicenseOptions: TLicenseOptions;
begin
  if cboProduct.ItemIndex >= 0 then
  begin
    LicenseOptions := [];

    if chkProBusinessEdition.Checked then
      Include(LicenseOptions, loProBusinessEdition);

    if chkSiteLicense.Checked then
      Include(LicenseOptions, loSiteLicense);

    if not chkLicenseExpiration.Checked then
      Include(LicenseOptions, loLifetimeLicense);

    if not chkUpgradesExpiration.Checked then
      Include(LicenseOptions, loLifetimeUpgrades);

    case GenerateKey(ProductList[cboProduct.ItemIndex], edtName.Text,
      LicenseOptions, dtpLicenseExpiration.DateTime,
      dtpUpgradesExpiration.DateTime, Key) of
      1:
        begin
          edtKey.Font.Color := clBtnShadow;
          edtKey.Text := 'Name must have at least 1 char!';
          btnCopy.Enabled := False;
          Exit;
        end;

      2:
        begin
          edtKey.Font.Color := clBtnShadow;
          edtKey.Text := 'Invalid license expiration date!';
          btnCopy.Enabled := False;
          Exit;
        end;

      3:
        begin
          edtKey.Font.Color := clBtnShadow;
          edtKey.Text := 'Invalid upgrades expiration date!';
          btnCopy.Enabled := False;
          Exit;
        end;
    end;

    edtKey.Font.Color := clWindowText;
    edtKey.Text := Key;
    btnCopy.Enabled := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TMainForm.cboProductChange(Sender: TObject);
begin
  btnGenerate.Click;
end;

//------------------------------------------------------------------------------

procedure TMainForm.cboProductDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Text : String;
begin
  Text := cboProduct.Items[Index];

  if odSelected in State then
    cboProduct.Canvas.Brush.Color := clHighlight
  else
    cboProduct.Canvas.Brush.Color := clWindow;

  cboProduct.Canvas.FillRect(Rect);

  DrawText(cboProduct.Canvas.Handle, PChar(Text), Length(Text), Rect,
    DT_VCENTER + DT_SINGLELINE + DT_CENTER);
end;

//------------------------------------------------------------------------------

procedure TMainForm.chkLicenseExpirationClick(Sender: TObject);
begin
  dtpLicenseExpiration.Enabled := chkLicenseExpiration.Checked;

  btnGenerate.Click;
  
  if dtpLicenseExpiration.Enabled then
    dtpLicenseExpiration.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.chkUpgradesExpirationClick(Sender: TObject);
begin
  dtpUpgradesExpiration.Enabled := chkUpgradesExpiration.Checked;

  btnGenerate.Click;

  if dtpUpgradesExpiration.Enabled then
    dtpUpgradesExpiration.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.edtNameChange(Sender: TObject);
begin
  if edtName.Tag > 0 then
    btnGenerate.Click;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Caption := Application.Title;

  cboProduct.Items.BeginUpdate;

  for I := Low(ProductList) to High(ProductList) do
    cboProduct.Items.Add(ProductList[I].Name);

  cboProduct.Items.EndUpdate;

  if cboProduct.Items.Count > 0 then
    cboProduct.ItemIndex := 0;

  chkProBusinessEdition.Checked := True;
  chkSiteLicense.Checked := True;
  dtpLicenseExpiration.DateTime := Now + 1;
  dtpUpgradesExpiration.DateTime := Now + 1;

  chkLicenseExpiration.OnClick(nil);
  chkUpgradesExpiration.OnClick(nil);  
  lblHomepage.OnMouseLeave(nil);
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormShow(Sender: TObject);
var
  UserName: array[0..256] of Char;
  Size: DWORD;
begin
  edtKey.Font.Color := clBtnShadow;
  edtKey.Text := 'Complete required fields and click Generate...';
  btnCopy.Enabled := False;

  Size := SizeOf(UserName);
  GetUserName(UserName, Size);
  
  edtName.Text := UserName;
  edtName.Tag := 1; // Allow to execute code in OnChange event handler
  edtName.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.lblHomepageClick(Sender: TObject);
begin
  try
    ShellExecute(Handle, 'open', 'https://www.datalandsoftware.com', nil, nil,
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

procedure TMainForm.OnCheckBoxClick(Sender: TObject);
begin
  btnGenerate.Click;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnDateChange(Sender: TObject);
begin
  btnGenerate.Click;
end;

end.
