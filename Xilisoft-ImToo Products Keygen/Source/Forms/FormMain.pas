unit FormMain;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  jpeg, Dialogs, VistaAltFixUnit;

type
  TMainForm = class(TForm)
    Bevel: TBevel;
    btnAbout: TButton;
    btnCopy: TButton;
    btnGenerate: TButton;
    btnSelectFile: TButton;
    imgBanner: TImage;
    lblHomepage: TLabel;
    lblImToo: TLabel;
    lblLicenseCode: TLabel;
    lblProductId: TLabel;
    lblXilisoft: TLabel;
    mLicenseCode: TMemo;
    mProductId: TMemo;
    OpenDialog: TOpenDialog;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure btnSelectFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure lblImTooClick(Sender: TObject);
    procedure lblXilisoftClick(Sender: TObject);
    procedure OnMouseEnter(Sender: TObject);
    procedure OnMouseLeave(Sender: TObject);

  private
    procedure BrowseURL(const URL: String);
    procedure InitializeControls;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  Licensing,
  ShellAPI;

//------------------------------------------------------------------------------

procedure TMainForm.BrowseURL(const URL: String);
begin
  try
    ShellExecute(Handle, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
  except
    Application.MessageBox('Cannot open default web browser!', 'Error',
      MB_ICONWARNING or MB_OK);
  end;
end;
  
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
  mLicenseCode.SelectAll;
  mLicenseCode.CopyToClipboard;
  mLicenseCode.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnGenerateClick(Sender: TObject);
begin
  mLicenseCode.Font.Color := clWindowText;
  mLicenseCode.Text := GenerateLicenseCode(mProductId.Text);
  btnCopy.Enabled := True;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnSelectFileClick(Sender: TObject);
var
  ProductId: String;
begin
  if OpenDialog.Execute then
  begin
    ProductId := GetProductId(OpenDialog.FileName);

    if ProductId <> '' then
    begin
      mProductId.Text := ProductId;
      btnGenerate.Enabled := True;
      btnGenerate.Click;
      btnGenerate.SetFocus;
    end
    else
      Application.MessageBox(PChar(Format('Error while extracting Product Id from %s or wrong file.',
        [OpenDialog.FileName])), PChar(Caption), MB_ICONWARNING or MB_OK);
  end;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
begin
  InitializeControls;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormShow(Sender: TObject);
begin
  mLicenseCode.Font.Color := clGrayText;
  mLicenseCode.Text := 'Click "..." to select a Product Description file...';
  btnSelectFile.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.InitializeControls;
begin
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Caption := Application.Title;
  OnMouseLeave(lblXilisoft);
  OnMouseLeave(lblImToo);
  btnGenerate.Enabled := False;
  btnCopy.Enabled := False;
end;

//------------------------------------------------------------------------------

procedure TMainForm.lblImTooClick(Sender: TObject);
begin
  BrowseURL('http://www.imtoo.com');
end;

//------------------------------------------------------------------------------

procedure TMainForm.lblXilisoftClick(Sender: TObject);
begin
  BrowseURL('http://www.xilisoft.com');
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnMouseEnter(Sender: TObject);
begin
  if Assigned(Sender) then
    (Sender as TLabel).Font.Color := clHighlight;
end;

//------------------------------------------------------------------------------

procedure TMainForm.OnMouseLeave(Sender: TObject);
begin
  if Assigned(Sender) then
    (Sender as TLabel).Font.Color := clHotlight;
end;

end.
