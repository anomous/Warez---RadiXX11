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
    cboCategory: TComboBox;
    cboProduct: TComboBox;
    imgBanner: TImage;
    lblCategory: TLabel;    
    lblHomepage: TLabel;
    lblKey: TLabel;
    lblProduct: TLabel;
    mKey: TMemo;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure cboCategoryChange(Sender: TObject);
    procedure cboProductChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure lblHomepageClick(Sender: TObject);
    procedure lblHomepageMouseEnter(Sender: TObject);
    procedure lblHomepageMouseLeave(Sender: TObject);

  private
    procedure LoadCategories;
    procedure LoadProducts;    
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  LicenseCode,
  ShellAPI;

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
  mKey.SelectAll;
  mKey.CopyToClipboard;
  mKey.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnGenerateClick(Sender: TObject);
var
  Index: Integer;
begin
  if cboProduct.ItemIndex >= 0 then
  begin
    Index := Integer(cboProduct.Items.Objects[cboProduct.ItemIndex]);
    mKey.Text := GenerateLicenseCode(ProductList[Index]);
    btnCopy.Enabled := True;
  end
  else
    btnCopy.Enabled := False;
end;

//------------------------------------------------------------------------------

procedure TMainForm.cboCategoryChange(Sender: TObject);
begin
  LoadProducts;
end;

//------------------------------------------------------------------------------

procedure TMainForm.cboProductChange(Sender: TObject);
begin
  btnGenerate.Click;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Caption := Application.Title;
  LoadCategories;
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
    ShellExecute(Handle, 'open', 'http://www.opoosoft.com', nil, nil, SW_SHOWNORMAL);
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

procedure TMainForm.LoadCategories;
var
  Category: TProductCategory;
begin
  cboCategory.Items.BeginUpdate;

  for Category := Low(TProductCategory) to High(TProductCategory) do
    cboCategory.Items.AddObject(Categories[Category], TObject(Category));

  cboCategory.Items.EndUpdate;

  if cboCategory.Items.Count > 0 then
  begin
    cboCategory.ItemIndex := 0;
    cboCategory.OnChange(nil);
  end;
end;

//------------------------------------------------------------------------------

procedure TMainForm.LoadProducts;
var
  I: Integer;
  Category: TProductCategory;
begin
  if cboCategory.ItemIndex >= 0 then
  begin
    Category := TProductCategory(cboCategory.Items.Objects[cboCategory.ItemIndex]);

    cboProduct.Items.BeginUpdate;
    cboProduct.Items.Clear;

    for I := Low(ProductList) to High(ProductList) do
      if ProductList[I].Category = Category then
        cboProduct.Items.AddObject(ProductList[I].Name, TObject(I));

    cboProduct.Items.EndUpdate;

    if cboProduct.Items.Count > 0 then
    begin
      cboProduct.ItemIndex := 0;
      cboProduct.OnChange(nil);
    end;
  end;
end;

end.
