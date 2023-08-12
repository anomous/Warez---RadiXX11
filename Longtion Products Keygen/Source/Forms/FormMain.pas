unit FormMain;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  jpeg, VistaAltFixUnit;

type
  TMainForm = class(TForm)
    Bevel: TBevel;
    btnAbout: TButton;
    btnCopyKey: TButton;
    btnCopyName: TButton;
    btnCopySerial: TButton;
    btnGenerate: TButton;
    cboLicense: TComboBox;
    cboProduct: TComboBox;
    edtName: TEdit;
    imgBanner: TImage;
    lblHomepage: TLabel;
    lblKey: TLabel;
    lblLicense: TLabel;
    lblName: TLabel;
    lblProduct: TLabel;
    lblSerial: TLabel;
    mKey: TMemo;
    mSerial: TMemo;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyKeyClick(Sender: TObject);
    procedure btnCopyNameClick(Sender: TObject);
    procedure btnCopySerialClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure cboLicenseChange(Sender: TObject);
    procedure cboProductChange(Sender: TObject);
    procedure edtNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure lblHomepageClick(Sender: TObject);
    procedure lblHomepageMouseEnter(Sender: TObject);
    procedure lblHomepageMouseLeave(Sender: TObject);

  private
    procedure UpdateLicenseList;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  License,
  Utils;

//------------------------------------------------------------------------------

procedure TMainForm.btnAboutClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Format('%s'#13#10#13#10 +
    'Version 1.0'#13#10#13#10 +
    '© 2019, RadiXX11 [RdX11]', [Caption])), 'About', MB_ICONINFORMATION or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnCopyKeyClick(Sender: TObject);
begin
  mKey.SelectAll;
  mKey.CopyToClipboard;
  mKey.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnCopyNameClick(Sender: TObject);
begin
  edtName.SelectAll;
  edtName.CopyToClipboard;
  edtName.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnCopySerialClick(Sender: TObject);
begin
  mSerial.SelectAll;
  mSerial.CopyToClipboard;
  mSerial.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnGenerateClick(Sender: TObject);
var
  Serial, Key: String;
begin
  if btnGenerate.Enabled and (cboProduct.ItemIndex >= 0) then
  begin

    if GenerateRegInfo(ProductList[cboProduct.ItemIndex], edtName.Text,
      cboLicense.ItemIndex, Serial, Key) then
    begin
      mSerial.Font.Color := clWindowText;
      mSerial.Text := Serial;
      mKey.Font.Color := clWindowText;
      mKey.Text := Key;
      btnCopyName.Enabled := True;
      btnCopySerial.Enabled := True;
      btnCopyKey.Enabled := True;
    end;

    Exit;
  end;

  mSerial.Font.Color := clGrayText;
  mSerial.Text := 'Enter a name...';
  mKey.Font.Color := clGrayText;
  mKey.Text := mSerial.Text;
  btnCopyName.Enabled := False;
  btnCopySerial.Enabled := False;
  btnCopyKey.Enabled := False;
end;

//------------------------------------------------------------------------------

procedure TMainForm.cboLicenseChange(Sender: TObject);
begin
  edtName.OnChange(nil);
end;

//------------------------------------------------------------------------------

procedure TMainForm.cboProductChange(Sender: TObject);
begin
  UpdateLicenseList;
  edtName.OnChange(nil);
end;

//------------------------------------------------------------------------------

procedure TMainForm.edtNameChange(Sender: TObject);
begin
  btnGenerate.Enabled := Trim(edtName.Text) <> '';
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

  UpdateLicenseList;
  edtName.Text := Utils.GetUserName;
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

procedure TMainForm.lblHomepageClick(Sender: TObject);
begin
  if not OpenURL('http://longtion.com') then
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

procedure TMainForm.UpdateLicenseList;
begin
  if cboProduct.ItemIndex >= 0 then
  begin
    cboLicense.Items.BeginUpdate;
    cboLicense.Items.Clear;
    GetLicenseTypes(ProductList[cboProduct.ItemIndex], cboLicense.Items);
    cboLicense.Items.EndUpdate;

    if cboLicense.Items.Count = 0 then
    begin
      cboLicense.Enabled := False;
      lblLicense.Enabled := False;
    end
    else
    begin
      cboLicense.ItemIndex := 0;
      cboLicense.Enabled := True;
      lblLicense.Enabled := True;
    end;
  end;
end;

end.
