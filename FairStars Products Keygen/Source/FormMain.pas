unit FormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, jpeg, XPMan;

type
  TMainForm = class(TForm)
    btnGenerate: TButton;
    cboClients: TComboBox;
    cboLicense: TComboBox;
    cboProduct: TComboBox;
    edtKey: TEdit;
    imgBanner: TImage;
    lblClients: TLabel;
    lblKey: TLabel;
    lblLicense: TLabel;
    lblProduct: TLabel;
    XPManifest1: TXPManifest;
    procedure btnGenerateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OnChange(Sender: TObject);
  private
    procedure InitializeControls;
  end;

var
  MainForm: TMainForm;

implementation

uses
  Licensing;

{$R *.dfm}

//------------------------------------------------------------------------------

procedure TMainForm.btnGenerateClick(Sender: TObject);
begin
  edtKey.Text := GenerateKey(ProductList[cboProduct.ItemIndex],
                  TLicenseType(cboLicense.ItemIndex), cboClients.ItemIndex + 1);
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
  InitializeControls;
end;

//------------------------------------------------------------------------------

procedure TMainForm.InitializeControls;
var
  LT: TLicenseType;
  I: Integer;
begin
  cboProduct.Items.BeginUpdate;
  for I := 0 to ProductCount - 1 do
    cboProduct.Items.Add(ProductList[I].Name);
  cboProduct.Items.EndUpdate;
  cboProduct.ItemIndex := 0;

  cboLicense.Items.BeginUpdate;
  for LT := Low(TLicenseType) to High(TLicenseType) do
    cboLicense.Items.Add(LicenseTypeStr[LT]);
  cboLicense.Items.EndUpdate;
  cboLicense.ItemIndex := 0;

  cboClients.Items.BeginUpdate;
  for I := 1 to 9 do
    cboClients.Items.Add(Format('%d-%d', [I * 100 - 99, I * 100]));
  cboClients.Items.EndUpdate;
  cboClients.ItemIndex := 0;

  cboLicense.OnChange(nil);
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnChange(Sender: TObject);
begin
  cboClients.Enabled := TLicenseType(cboLicense.ItemIndex) = ltSite;
  lblClients.Enabled := cboClients.Enabled;
  btnGenerate.Click;
end;

end.
