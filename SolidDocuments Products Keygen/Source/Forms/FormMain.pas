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
    btnPatchHosts: TButton;
    cboProduct: TComboBox;
    edtEMail: TEdit;
    imgBanner: TImage;
    lblHomepage: TLabel;
    lblEMail: TLabel;
    lblProduct: TLabel;
    lblUnlockCode: TLabel;
    mUnlockCode: TMemo;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnPatchHostsClick(Sender: TObject);
    procedure cboProductDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure edtEMailChange(Sender: TObject);      
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure lblHomepageClick(Sender: TObject);
    procedure lblHomepageMouseEnter(Sender: TObject);
    procedure lblHomepageMouseLeave(Sender: TObject);

  private
    procedure UpdateHostsPatchButton;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  HostsFile,
  License,
  Utils;

//------------------------------------------------------------------------------

const
  HostEntries: array[0..0] of String = (
    'www.soliddocuments.com'
  );

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
  mUnlockCode.SelectAll;
  mUnlockCode.CopyToClipboard;
  mUnlockCode.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnPatchHostsClick(Sender: TObject);
begin
  if IsHostsFilePatched(HostEntries) then
  begin
    if RestoreHostsFile(HostEntries) then
      Application.MessageBox('Hosts file successfully restored.', PChar(Caption), MB_ICONINFORMATION or MB_OK)
    else
      Application.MessageBox('Cannot restore hosts file! Make sure to run this keygen with Admin rights and try again.', 'Error', MB_ICONWARNING or MB_OK);
  end
  else
  begin
    if PatchHostsFile(HostEntries) then
      Application.MessageBox('Hosts file successfully patched.', PChar(Caption), MB_ICONINFORMATION or MB_OK)
    else
      Application.MessageBox('Cannot patch hosts file! Make sure to run this keygen with Admin rights and try again.', 'Error', MB_ICONWARNING or MB_OK);
  end;

  UpdateHostsPatchButton;
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

procedure TMainForm.edtEMailChange(Sender: TObject);
begin
  if Trim(edtEMail.Text) = '' then
  begin
    mUnlockCode.Font.Color := clGrayText;
    mUnlockCode.Text := 'Enter EMail...';
    btnCopy.Enabled := False;
  end
  else
  begin
    mUnlockCode.Font.Color := clWindowText;
    mUnlockCode.Text := GenerateUnlockCode(ProductList[cboProduct.ItemIndex],
                          edtEMail.Text);
    btnCopy.Enabled := True;
  end;
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

  edtEMail.OnChange(nil);
  lblHomepage.OnMouseLeave(nil);
  UpdateHostsPatchButton;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormShow(Sender: TObject);
begin
  edtEMail.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.lblHomepageClick(Sender: TObject);
begin
  if not OpenURL('http://www.soliddocuments.com') then
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

//------------------------------------------------------------------------------

procedure TMainForm.UpdateHostsPatchButton;
begin
  if IsHostsFilePatched(HostEntries) then
  begin
    lblHomepage.Enabled := False;
    btnPatchHosts.Caption := 'Restore &Hosts'
  end
  else
  begin
    lblHomepage.Enabled := True;
    btnPatchHosts.Caption := 'Patch &Hosts';
  end;
end;

end.
