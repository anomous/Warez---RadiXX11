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
    edtLicenseKey: TEdit;
    edtRequestCode: TEdit;
    imgBanner: TImage;
    lblHomepage: TLabel;
    lblLicenseKey: TLabel;
    lblRequestCode: TLabel;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure edtRequestCodeChange(Sender: TObject);
    procedure edtRequestCodeKeyPress(Sender: TObject; var Key: Char);
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
  edtLicenseKey.SelectAll;
  edtLicenseKey.CopyToClipboard;
  edtLicenseKey.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.edtRequestCodeChange(Sender: TObject);
begin
  if Trim(edtRequestCode.Text) <> '' then
  begin
    edtLicenseKey.Font.Color := clWindowText;
    edtLicenseKey.Text := GetLicenseKey(edtRequestCode.Text);
  end
  else
  begin
    edtLicenseKey.Font.Color := clGrayText;
    edtLicenseKey.Text := 'Enter a request code...';
  end;
end;

//------------------------------------------------------------------------------

procedure TMainForm.edtRequestCodeKeyPress(Sender: TObject; var Key: Char);
begin
  // Only allow digit and backspace keys
  if not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Caption := Application.Title;
  lblHomepage.OnMouseLeave(nil);
  edtRequestCode.Text := GetRequestCode;
  edtRequestCode.OnChange(nil);
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormShow(Sender: TObject);
begin
  edtRequestCode.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.lblHomepageClick(Sender: TObject);
begin
  try
    ShellExecute(Handle, 'open', 'https://www.epapersign.com/toner-optimization',
      nil, nil, SW_SHOWNORMAL);
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
