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
    edtEMail: TEdit;
    imgBanner: TImage;
    lblHomepage: TLabel;
    lblEMail: TLabel;
    lblKey: TLabel;
    VistaAltFix: TVistaAltFix;
    edtKey: TEdit;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
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
    '© 2019, RadiXX11 [RdX11]', [Caption])), 'About', MB_ICONINFORMATION or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnCopyClick(Sender: TObject);
begin
  edtKey.SelectAll;
  edtKey.CopyToClipboard;
  edtKey.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Caption := Application.Title;

  OnChange(nil);
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
  edtEMail.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.lblHomepageClick(Sender: TObject);
begin
  if not OpenURL('https://www.vistastylebuilder.com') then
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
var
  Key: String;
begin
  if Trim(edtEMail.Text) <> '' then
  begin
    Key := GenerateKey(edtEMail.Text);

    if Key = '1' then
    begin
      edtKey.Font.Color := clGrayText;
      edtKey.Text := 'EMail must have a valid format!';
      btnCopy.Enabled := False;
      Exit;
    end;

    if Key = '2' then
    begin
      edtKey.Font.Color := clGrayText;
      edtKey.Text := 'EMail must have at least 10 characters!';
      btnCopy.Enabled := False;
      Exit;      
    end;

    edtKey.Font.Color := clWindowText;
    edtKey.Text := Key;
    btnCopy.Enabled := True;
  end
  else
  begin
    edtKey.Font.Color := clGrayText;
    edtKey.Text := 'Enter an email...';
    btnCopy.Enabled := False;
  end;
end;

end.
