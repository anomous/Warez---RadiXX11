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
    cboEdition: TComboBox;       
    cboProduct: TComboBox;
    imgBanner: TImage;
    lblHomepage: TLabel;
    lblEdition: TLabel;
    lblKey: TLabel;
    lblProduct: TLabel;
    mKey: TMemo;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure cboEditionChange(Sender: TObject);    
    procedure cboProductChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure OnLinkClick(Sender: TObject);
    procedure OnLinkMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnLinkMouseEnter(Sender: TObject);
    procedure OnLinkMouseLeave(Sender: TObject);
    procedure OnLinkMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  Licensing,
  ShellAPI,
  Utils;

//------------------------------------------------------------------------------

procedure TMainForm.btnAboutClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Format('%s'#13#10#13#10 +
    'Version 1.0'#13#10#13#10 +
    '© 2019, RadiXX11', [Caption])), 'About', MB_ICONINFORMATION or MB_OK);
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
  if (cboProduct.ItemIndex >= 0) and (cboEdition.ItemIndex >= 0) then
    mKey.Text := GenerateKey(ProductList[cboProduct.ItemIndex],
                  TProductEdition(cboEdition.Items.Objects[cboEdition.ItemIndex]));
end;

//------------------------------------------------------------------------------

procedure TMainForm.cboEditionChange(Sender: TObject);
begin
  btnGenerate.Click;
end;

//------------------------------------------------------------------------------

procedure TMainForm.cboProductChange(Sender: TObject);
begin
  btnGenerate.Click;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
var
  I: Integer;
  Edition: TProductEdition;
begin
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Caption := Application.Title;

  cboProduct.Items.BeginUpdate;

  for I := Low(ProductList) to High(ProductList) do
    cboProduct.Items.Add(ProductList[I].Name);

  cboProduct.Items.EndUpdate;

  if cboProduct.Items.Count > 0 then
    cboProduct.ItemIndex := 0;

  cboEdition.Items.BeginUpdate;

  for Edition := Low(TProductEdition) to High(TProductEdition) do
    cboEdition.Items.AddObject(EditionList[Edition], TObject(Edition));

  cboEdition.Items.EndUpdate;

  if cboEdition.Items.Count > 0 then
    cboEdition.ItemIndex := 0;

  btnGenerate.Click;
  lblHomepage.OnMouseLeave(nil);
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkClick(Sender: TObject);
begin
  if not OpenURL('http://www.rootsmagic.com') then
    Application.MessageBox('Cannot open default web browser!', 'Error',
      MB_ICONWARNING or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  lblHomepage.Font.Color := clHotlight;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkMouseEnter(Sender: TObject);
begin
  lblHomepage.Font.Color := clHighlight;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkMouseLeave(Sender: TObject);
begin
  lblHomepage.Font.Color := clHotlight;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  lblHomepage.Font.Color := clHighlight;
end;

end.
