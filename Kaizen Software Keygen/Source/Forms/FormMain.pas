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
    cboProduct: TComboBox;
    imgBanner: TImage;
    lblHomepage: TLabel;
    lblKey: TLabel;
    lblProduct: TLabel;
    mKey: TMemo;
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
    'Version 1.0'#13#10#13#10 +
    '© 2019, RadiXX11 [RdX11]', [Caption])), 'About', MB_ICONINFORMATION or MB_OK);
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
begin
  if cboProduct.ItemIndex >= 0 then
  begin
    mKey.Text := GenerateLicenseKey(ProductList[cboProduct.ItemIndex]);
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
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Caption := Application.Title;

  cboProduct.Items.BeginUpdate;

  for I := Low(ProductList) to High(ProductList) do
    cboProduct.Items.Add(ProductList[I].Name);

  cboProduct.Items.EndUpdate;

  if cboProduct.Items.Count > 0 then
    cboProduct.ItemIndex := 0;

  OnChange(nil);
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
    ShellExecute(Handle, 'open', 'http://www.kaizensoftware.com', nil, nil, SW_SHOWNORMAL);
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
  btnGenerate.Click;
end;

end.
