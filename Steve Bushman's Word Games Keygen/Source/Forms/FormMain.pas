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
    cboProduct: TComboBox;
    edtName: TEdit;    
    imgBanner: TImage;
    lblHomepage1: TLabel;
    lblHomepage2: TLabel;
    lblName: TLabel;
    lblProduct: TLabel;
    lblRegKey: TLabel;
    lblSeparator: TLabel;
    mRegKey: TMemo;
    stInfo: TStaticText;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure cboProductChange(Sender: TObject);
    procedure edtNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure OnLabelClick(Sender: TObject);
    procedure OnLabelMouseEnter(Sender: TObject);
    procedure OnLabelMouseLeave(Sender: TObject);

  private
    procedure UpdateKey;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  Licensing,
  Utils;

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
  mRegKey.SelectAll;
  mRegKey.CopyToClipboard;
  mRegKey.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.cboProductChange(Sender: TObject);
begin
  UpdateKey;
end;

//------------------------------------------------------------------------------

procedure TMainForm.edtNameChange(Sender: TObject);
begin
  UpdateKey;
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

  edtName.Text := Utils.GetUserName;

  OnLabelMouseLeave(lblHomepage1);
  OnLabelMouseLeave(lblHomepage2);
  UpdateKey;
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

procedure TMainForm.OnLabelClick(Sender: TObject);
begin
  if not OpenURL('http://' + (Sender as TLabel).Caption) then
    Application.MessageBox('Cannot open default web browser!', 'Error',
      MB_ICONWARNING or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLabelMouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clHighlight;
  (Sender as TLabel).Font.Style := [fsUnderline];
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLabelMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clHotlight;
  (Sender as TLabel).Font.Style := [];
end;

//------------------------------------------------------------------------------

procedure TMainForm.UpdateKey;
begin
  if (cboProduct.ItemIndex >= 0) and (Trim(edtName.Text) <> '') then
  begin
    mRegKey.Font.Color := clWindowText;
    mRegKey.Text := GenerateKey(ProductList[cboProduct.ItemIndex], edtName.Text,
                      EncodeDate(2050, 12, 31));
  end
  else
  begin
    mRegKey.Font.Color := clGrayText;  
    mRegKey.Text := 'Enter a name...';
  end;
end;

end.
