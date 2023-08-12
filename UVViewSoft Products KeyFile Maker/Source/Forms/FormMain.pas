unit FormMain;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  jpeg, VistaAltFixUnit;

type
  TMainForm = class(TForm)
    Bevel: TBevel;
    btnAbout: TButton;
    btnGenerate: TButton;
    cboLicense: TComboBox;
    cboProduct: TComboBox;
    edtName: TEdit;
    imgBanner: TImage;
    lblHomepage: TLabel;
    lblLicense: TLabel;
    lblName: TLabel;
    lblProduct: TLabel;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
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
{$WARN UNIT_PLATFORM OFF}

uses
  FileCtrl,
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

procedure TMainForm.btnGenerateClick(Sender: TObject);
var
  Key, Path: String;
  Valid: Boolean;
begin
  if cboProduct.ItemIndex >= 0 then
  begin
    Key := ProductList[cboProduct.ItemIndex].GenerateKey(edtName.Text,
              TLicenseType(cboLicense.ItemIndex));

    if Length(Key) = 1 then
    begin
      Application.MessageBox(PChar(Format('Name must have at least %s chars!', [Key])),
        PChar(Caption), MB_ICONWARNING or MB_OK);
      edtName.SetFocus;
      Exit;
    end;

    Path := GetCurrentDir;

    if not IsInstallationDir(ProductList[cboProduct.ItemIndex], Path) then
    begin
      repeat
        if not SelectDirectory('Select installation folder:', '', Path) then
          Exit;

        Valid := IsInstallationDir(ProductList[cboProduct.ItemIndex], Path);

        if not Valid then
          Application.MessageBox(PChar(Format('%s not found in %s',
            [ProductList[cboProduct.ItemIndex].Name, Path])),
            PChar(Caption), MB_ICONWARNING or MB_OK);

      until Valid;
    end;

    if ProductList[cboProduct.ItemIndex].CreateKeyFile(Path, edtName.Text, Key,
      TLicenseType(cboLicense.ItemIndex)) then
      Application.MessageBox(PChar(Format('Key file sucessfully created in %s',
        [Path])), PChar(Caption), MB_ICONINFORMATION or MB_OK)
    else
      Application.MessageBox(PChar(Format('Cannot create key file in %s',
        [Path])), PChar(Caption), MB_ICONWARNING or MB_OK);
  end;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
var
  I: Integer;
  License: TLicenseType;
begin
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Caption := Application.Title;

  cboProduct.Items.BeginUpdate;

  for I := Low(ProductList) to High(ProductList) do
    cboProduct.Items.Add(ProductList[I].Name);

  cboProduct.Items.EndUpdate;

  if cboProduct.Items.Count > 0 then
    cboProduct.ItemIndex := 0;

  cboLicense.Items.BeginUpdate;

  for License := Low(TLicenseType) to High(TLicenseType) do
    cboLicense.Items.Add(LicenseTypes[License]);

  cboLicense.Items.EndUpdate;

  if cboLicense.Items.Count > 0 then
    cboLicense.ItemIndex := 0;

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
  if not OpenURL('http://www.uvviewsoft.com') then
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
