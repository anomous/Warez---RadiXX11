unit FormMain;

interface

uses
  Windows, SysUtils, Classes, ComCtrls, Graphics, Controls, Forms, StdCtrls,
  ExtCtrls, jpeg, VistaAltFixUnit;

type
  TMainForm = class(TForm)
    Bevel: TBevel;
    btnAbout: TButton;
    btnCopy: TButton;
    btnGenerate: TButton;
    cboProduct: TComboBox;
    cboSubType: TComboBox;
    dtpExpDate: TDateTimePicker;
    imgBanner: TImage;
    lblExpDate: TLabel;
    lblHomepage: TLabel;
    lblKey: TLabel;
    lblProduct: TLabel;
    lblSubType: TLabel;
    mKey: TMemo;
    rbExpDate: TRadioButton;
    rbUnlimited: TRadioButton;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure OnChange(Sender: TObject);
    procedure OnLinkClick(Sender: TObject);
    procedure OnLinkMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnLinkMouseEnter(Sender: TObject);
    procedure OnLinkMouseLeave(Sender: TObject);
    procedure OnLinkMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure rbUnlimitedClick(Sender: TObject);
    procedure rbExpDateClick(Sender: TObject);
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
    'Version 1.3'#13#10#13#10 +
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
  ExpDate: TDateTime;
begin
  if (cboProduct.ItemIndex >= 0) and (cboSubType.ItemIndex >= 0) then
  begin
    if rbUnlimited.Checked then
      ExpDate := MaxDateTime
    else
      ExpDate := dtpExpDate.Date;

    mKey.Font.Color := clWindowText;
    mKey.Text := GenerateLicenseKey(ProductList[cboProduct.ItemIndex],
                  TSubscriptionType(cboSubType.Items.Objects[cboSubType.ItemIndex]), ExpDate);
    btnCopy.Enabled := True;
  end
  else
    btnCopy.Enabled := False;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
var
  S: TSubscriptionType;
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

  cboSubType.Items.BeginUpdate;

  for S := Low(TSubscriptionType) to High(TSubscriptionType) do
    cboSubType.Items.AddObject(SubscriptionTypes[S], TObject(S));

  cboSubType.Items.EndUpdate;

  if cboSubType.Items.Count > 0 then
    cboSubType.ItemIndex := 0;

  rbUnlimited.Checked := True;
  lblHomepage.OnMouseLeave(lblHomepage);
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormShow(Sender: TObject);
begin
  btnGenerate.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnChange(Sender: TObject);
begin
  btnGenerate.Click;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkClick(Sender: TObject);
begin
  if not OpenURL('https://www.insofta.com') then
    Application.MessageBox('Cannot open default web browser!', 'Error',
      MB_ICONWARNING or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TLabel).Font.Color := clHotlight;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkMouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clHighlight;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clHotlight;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnLinkMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  (Sender as TLabel).Font.Color := clHighlight;
end;

//------------------------------------------------------------------------------

procedure TMainForm.rbExpDateClick(Sender: TObject);
begin
  dtpExpDate.Enabled := True;
  dtpExpDate.SetFocus;
  btnGenerate.Click;
end;

//------------------------------------------------------------------------------

procedure TMainForm.rbUnlimitedClick(Sender: TObject);
begin
  dtpExpDate.Enabled := False;
  btnGenerate.Click;
end;


end.
