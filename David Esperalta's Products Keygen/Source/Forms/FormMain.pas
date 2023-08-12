unit FormMain;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  jpeg, Spin, VistaAltFixUnit;

type
  TMainForm = class(TForm)
    btnAbout: TButton;
    btnCopy: TButton;
    btnGenerate: TButton;
    cboProduct: TComboBox;
    edtUserName: TEdit;
    lblUserName: TLabel;
    lblProduct: TLabel;
    lblSerial: TLabel;
    mSerialNumber: TMemo;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure cboProductDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cboProductCloseUp(Sender: TObject);      
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure OnChange(Sender: TObject);

  private
    procedure UpdateSerial;      
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  Licensing;

//------------------------------------------------------------------------------

procedure TMainForm.btnAboutClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Format('%s'#13#10#13#10 +
    'Version 1.1'#13#10#13#10 +
    '© 2016, RadiXX11', [Caption])), 'About', MB_ICONINFORMATION or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnCopyClick(Sender: TObject);
begin
  mSerialNumber.SelectAll;
  mSerialNumber.CopyToClipboard;
  mSerialNumber.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnGenerateClick(Sender: TObject);
begin
  UpdateSerial;
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

procedure TMainForm.cboProductCloseUp(Sender: TObject);
begin
  if Trim(edtUserName.Text) = EmptyStr then
    edtUserName.SetFocus
  else
    mSerialNumber.SetFocus;
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

  UpdateSerial;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormShow(Sender: TObject);
begin
  edtUserName.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnChange(Sender: TObject);
begin
  UpdateSerial;
end;

//------------------------------------------------------------------------------

procedure TMainForm.UpdateSerial;
begin
  if cboProduct.ItemIndex >= 0 then
  begin
    if Trim(edtUserName.Text) = '' then
    begin
      mSerialNumber.Font.Color := clGrayText;
      mSerialNumber.Text := 'Enter a Name...';
      btnGenerate.Enabled := False;
      btnCopy.Enabled := False;      
      Exit;
    end;

    mSerialNumber.Text := GenerateSerial(ProductList[cboProduct.ItemIndex],
                            edtUserName.Text);

    if mSerialNumber.Text = '' then
    begin
      mSerialNumber.Font.Color := clGrayText;
      mSerialNumber.Text := 'Name must have at least 25 chars!';
      btnGenerate.Enabled := False;
      btnCopy.Enabled := False;
    end
    else
    begin
      mSerialNumber.Font.Color := clWindowText;
      btnGenerate.Enabled := True;
      btnCopy.Enabled := True;
    end;
  end;
end;

end.
