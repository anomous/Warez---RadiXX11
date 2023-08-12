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
    btnPatchHosts: TButton;
    cboProduct: TComboBox;
    edtRegCode: TMemo;
    imgBanner: TImage;
    lblHomepage: TLabel;
    lblProduct: TLabel;
    lblRegCode: TLabel;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
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
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  HostsFile,
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

procedure TMainForm.btnCopyClick(Sender: TObject);
begin
  edtRegCode.SelectAll;
  edtRegCode.CopyToClipboard;
  edtRegCode.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnGenerateClick(Sender: TObject);
begin
  if cboProduct.ItemIndex >= 0 then
  begin
    edtRegCode.Font.Color := clWindowText;
    edtRegCode.Text := GenerateRegCode(ProductList[cboProduct.ItemIndex]);
    btnCopy.Enabled := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnPatchHostsClick(Sender: TObject);
const
  Host = 'www.gilisoft.com';
begin
  try
    if HostsEntryExists(Host) then
    begin
      Application.MessageBox('Hosts file already patched.', PChar(Caption),
        MB_ICONINFORMATION or MB_OK);
      Exit;
    end;

    AddHostsEntry('127.0.0.1', Host);

    Application.MessageBox('Hosts file patched sucessfully.', PChar(Caption),
      MB_ICONINFORMATION or MB_OK);

  except
    Application.MessageBox('Cannot open the hosts file!', PChar(Caption),
      MB_ICONWARNING or MB_OK);
  end;
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
  edtRegCode.Font.Color := clBtnShadow;
  edtRegCode.Text := 'Select a product and click Generate...';
  btnCopy.Enabled := False;
end;

//------------------------------------------------------------------------------

procedure TMainForm.lblHomepageClick(Sender: TObject);
begin
  try
    ShellExecute(Handle, 'open', 'http://www.gilisoft.com', nil, nil,
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

end.
