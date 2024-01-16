unit FormMain;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ComCtrls, ExtCtrls, jpeg;

type
  TMainForm = class(TForm)
    Bevel: TBevel;
    btnGenerate: TButton;
    cbProduct: TComboBox;
    dtpExpiration: TDateTimePicker;
    imgBanner: TImage;
    lblCopyright: TLabel;
    lblExpiration: TLabel;
    lblName: TLabel;
    procedure btnGenerateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    procedure PopulateProductList;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  License;

//--------------------------------------------------------------------------------------------------

procedure TMainForm.btnGenerateClick(Sender: TObject);
begin
  if cbProduct.ItemIndex >= 0 then
  begin
    case ActivateProduct(ProductList[cbProduct.ItemIndex], dtpExpiration.Date) of
      arOk:
        Application.MessageBox(PChar(Format('%s activated successfully.', [cbProduct.Text])), PChar(Caption), MB_ICONINFORMATION or MB_OK);

      arInvalidExpirationDate:
        Application.MessageBox('Invalid expiration date!', PChar(Caption), MB_ICONWARNING or MB_OK);

      arCannotWriteRegistryEntry:
        Application.MessageBox('Cannot write registry entry!', PChar(Caption), MB_ICONWARNING or MB_OK);
    end;
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
  PopulateProductList;
  dtpExpiration.Date := EncodeDate(2050, 1, 1);
end;

//--------------------------------------------------------------------------------------------------

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    Close;
end;

//--------------------------------------------------------------------------------------------------

procedure TMainForm.PopulateProductList;
var
  I: Integer;
begin
  cbProduct.Items.BeginUpdate;

  try
    cbProduct.Items.Clear;

    for I := Low(ProductList) to High(ProductList) do
      cbProduct.Items.Add(ProductList[I].Name);

  finally
    cbProduct.Items.EndUpdate;

    if cbProduct.Items.Count > 0 then
      cbProduct.ItemIndex := 0;
  end;
end;

end.
