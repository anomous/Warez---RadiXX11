unit FormMain;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Dialogs, Forms, StdCtrls,
  ExtCtrls, jpeg, Spin, VistaAltFixUnit;

type
  TMainForm = class(TForm)
    Bevel: TBevel;
    btnAbout: TButton;
    btnGenerate: TButton;
    btnReadVersion: TButton;
    btnSelectFolder: TButton;
    cboLicense: TComboBox;
    edtName: TEdit;
    edtPath: TEdit;
    gboAppPath: TGroupBox;
    gboAppVersion: TGroupBox;
    gboLicenseInfo: TGroupBox;
    imgBanner: TImage;
    lblHomepage: TLabel;
    lblLicense: TLabel;
    lblMajor: TLabel;
    lblMinor: TLabel;
    lblName: TLabel;
    lblUsers: TLabel;
    OpenDialog: TOpenDialog;
    seMajor: TSpinEdit;
    seMinor: TSpinEdit;
    seUsers: TSpinEdit;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure btnReadVersionClick(Sender: TObject);
    procedure btnSelectFolderClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
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
  Utils;

//------------------------------------------------------------------------------

procedure TMainForm.btnAboutClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Format('%s'#13#10#13#10 +
    'Version 1.0'#13#10#13#10 +
    '© 2019, RadiXX11', [Caption])), 'About', MB_ICONINFORMATION or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnGenerateClick(Sender: TObject);
begin
  if IsValidAppPath(edtPath.Text) then
  begin
    if GenerateLicenseFile(edtPath.Text, edtName.Text, seUsers.Value,
      TLicenseType(cboLicense.ItemIndex), seMajor.Value, seMinor.Value) then
      Application.MessageBox('License file generated sucessfully.',
        PChar(Caption), MB_ICONINFORMATION or MB_OK)
    else
      Application.MessageBox('Error while trying to create license file!',
        PChar(Caption), MB_ICONWARNING or MB_OK);
  end
  else
  begin
    Application.MessageBox('Application path is not valid!',
      PChar(Caption), MB_ICONWARNING or MB_OK);
    edtPath.SetFocus;
  end;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnReadVersionClick(Sender: TObject);
var
  Major, Minor: Integer;
begin
  if IsValidAppPath(edtPath.Text) then
  begin
    if GetAppVersion(edtPath.Text, Major, Minor) then
    begin
      seMajor.Value := Major;
      seMinor.Value := Minor;
    end
    else if btnReadVersion.Tag <> 0 then
      Application.MessageBox('Error while trying to read version info!',
        PChar(Caption), MB_ICONWARNING or MB_OK);
  end
  else if btnReadVersion.Tag <> 0 then
  begin
    Application.MessageBox('Application path is not valid!',
      PChar(Caption), MB_ICONWARNING or MB_OK);
    edtPath.SetFocus;
  end;

  // Allow to display error messages.
  btnReadVersion.Tag := 1;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnSelectFolderClick(Sender: TObject);
begin
  if IsValidAppPath(edtPath.Text) then
    OpenDialog.InitialDir := edtPath.Text
  else
    OpenDialog.InitialDir := GetCurrentDir;

  if OpenDialog.Execute then
  begin
    edtPath.Text := ExtractFileDir(OpenDialog.FileName);
    btnReadVersion.Click;
  end;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
var
  License: TLicenseType;
begin
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Caption := Application.Title;

  cboLicense.Items.BeginUpdate;

  for License := Low(TLicenseType) to High(TLicenseType) do
    cboLicense.Items.Add(LicenseTypes[License]);

  cboLicense.Items.EndUpdate;

  if cboLicense.Items.Count > 0 then
    cboLicense.ItemIndex := Integer(ltProfessional);

  edtPath.Text := GetAppPath;
  edtName.Text := Utils.GetUserName;
  OpenDialog.Filter := AppExeName + '|' + AppExeName;
  
  btnReadVersion.Click;
  lblHomepage.OnMouseLeave(nil);
  OnChange(nil);
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormShow(Sender: TObject);
begin
  if btnGenerate.Enabled then
    btnGenerate.SetFocus
  else if not btnReadVersion.Enabled then
    edtPath.SetFocus
  else
    edtName.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.lblHomepageClick(Sender: TObject);
begin
  if not OpenURL('https://mobaxterm.mobatek.net') then
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

procedure TMainForm.OnChange(Sender: TObject);
begin
  btnReadVersion.Enabled := Trim(edtPath.Text) <> '';
  btnGenerate.Enabled := btnReadVersion.Enabled and (Trim(edtName.Text) <> '');
end;

end.
