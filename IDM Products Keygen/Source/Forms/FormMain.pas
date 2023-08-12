unit FormMain;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  jpeg, VistaAltFixUnit;

type
  TMainForm = class(TForm)
    Bevel: TBevel;
    btnAbout: TButton;
    btnCopyCode1: TButton;
    btnCopyCode2: TButton;
    btnGenerate: TButton;
    btnPasteCode1: TButton;
    btnPasteCode2: TButton;
    btnPatchHosts: TButton;
    cboProduct: TComboBox;
    gboProduct: TGroupBox;
    imgBanner: TImage;
    lblAuthCode1: TLabel;
    lblAuthCode2: TLabel;
    lblHomepage: TLabel;
    lblUserCode1: TLabel;
    lblUserCode2: TLabel;
    mAuthCode1: TMemo;
    mAuthCode2: TMemo;
    mUserCode1: TMemo;
    mUserCode2: TMemo;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure btnPatchHostsClick(Sender: TObject);
    procedure cboProductChange(Sender: TObject);
    procedure cboProductDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);    
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure lblHomepageClick(Sender: TObject);
    procedure lblHomepageMouseEnter(Sender: TObject);
    procedure lblHomepageMouseLeave(Sender: TObject);
    procedure OnCopyCodeClick(Sender: TObject);
    procedure OnPasteCodeClick(Sender: TObject);
    procedure OnUserCodeChange(Sender: TObject);
    procedure OnUserCodeKeyPress(Sender: TObject; var Key: Char);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  License,
  ShellAPI;

//------------------------------------------------------------------------------

procedure TMainForm.btnAboutClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Format('%s'#13#10#13#10 +
    'Version 1.0'#13#10#13#10 +
    '© 2018, RadiXX11', [Caption])), 'About', MB_ICONINFORMATION or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnGenerateClick(Sender: TObject);
var
  AuthCode1, AuthCode2: String;
begin
  if (cboProduct.ItemIndex >= 0) and (Trim(mUserCode1.Text) <> '') and
    (Trim(mUserCode2.Text) <> '') then
  begin
    case GenerateAuthCodes(ProductList[cboProduct.ItemIndex], mUserCode1.Text,
      mUserCode2.Text, AuthCode1, AuthCode2) of
      1:
        begin
          mAuthCode1.Font.Color := clBtnShadow;
          mAuthCode1.Text := 'User Code 1 is not valid!';
          btnCopyCode1.Enabled := False;
          Exit;
        end;
      2:
        begin
          mAuthCode2.Font.Color := clBtnShadow;
          mAuthCode2.Text := 'User Code 2 is not valid!';
          btnCopyCode2.Enabled := True;
          Exit;
        end;
    end;

    mAuthCode1.Font.Color := clWindowText;
    mAuthCode1.Text := AuthCode1;
    mAuthCode2.Font.Color := clWindowText;
    mAuthCode2.Text := AuthCode2;
    btnCopyCode1.Enabled := True;
    btnCopyCode2.Enabled := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnPatchHostsClick(Sender: TObject);
begin
  if IsHostsFilePatched then
  begin
    Application.MessageBox('Hosts file already patched.', PChar(Caption),
      MB_ICONINFORMATION or MB_OK);
    Exit;
  end;

  if Application.MessageBox('IMPORTANT: These applications can detect a patched hosts file and therefore, invalidate the activation.'#13#10#13#10 +
    'It is more advisable to block the application with a firewall.'#13#10#13#10 +
    'Continue anyway?', PChar(Caption),
    MB_ICONINFORMATION or MB_YESNO) = IDNO then Exit;

  if PatchHostsFile then
    Application.MessageBox('Hosts file patched sucessfully.', PChar(Caption),
      MB_ICONINFORMATION or MB_OK)
  else
    Application.MessageBox('Cannot open the hosts file!', PChar(Caption),
      MB_ICONWARNING or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.cboProductChange(Sender: TObject);
begin
  btnGenerate.Click;
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
  btnCopyCode1.Enabled := False;
  btnCopyCode2.Enabled := False;
  OnUserCodeChange(nil);
  mUserCode1.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.lblHomepageClick(Sender: TObject);
begin
  try
    ShellExecute(Handle, 'open', 'https://www.ultraedit.com', nil, nil,
      SW_SHOWNORMAL);
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

procedure TMainForm.OnCopyCodeClick(Sender: TObject);
var
  Memo: TMemo;
begin
  if Sender = btnCopyCode1 then
    Memo := mAuthCode1
  else
    Memo := mAuthCode2;

  Memo.SelectAll;
  Memo.CopyToClipboard;
  Memo.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnPasteCodeClick(Sender: TObject);
var
  Memo: TMemo;
begin
  if Sender = btnPasteCode1 then
    Memo := mUserCode1
  else
    Memo := mUserCode2;

  Memo.SelectAll;
  Memo.PasteFromClipboard;
  Memo.SelLength := 0;
  Memo.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnUserCodeChange(Sender: TObject);
begin
  if (Pos(#13, mUserCode1.Text) > 0) or (Pos(#10, mUserCode1.Text) > 0) then
    mUserCode1.Clear;

  if (Pos(#13, mUserCode2.Text) > 0) or (Pos(#10, mUserCode2.Text) > 0) then
    mUserCode2.Clear;

  btnGenerate.Enabled := (Trim(mUserCode1.Text) <> '') and (Trim(mUserCode2.Text) <> '');
  if btnGenerate.Enabled then btnGenerate.Click;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnUserCodeKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, '0'..'9']) then Key := #0;
end;

end.
