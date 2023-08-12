unit FormMain;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  jpeg, VistaAltFixUnit;

type
  TMainForm = class(TForm)
    Bevel: TBevel;
    btnAbout: TButton;
    btnCreateKeyFile: TButton;
    edtCompany: TEdit;    
    edtName: TEdit;
    imgBanner: TImage;
    lblHomepage: TLabel;
    lblCompany: TLabel;
    lblName: TLabel;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCreateKeyFileClick(Sender: TObject);
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

{$WARN UNIT_PLATFORM OFF}

uses
  FileCtrl,
  KeyFile,
  Utils;

//------------------------------------------------------------------------------

procedure TMainForm.btnAboutClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Format('%s'#13#10#13#10 +
    'Version 1.0'#13#10#13#10 +
    '© 2019, RadiXX11 [RdX11]', [Caption])), 'About', MB_ICONINFORMATION or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnCreateKeyFileClick(Sender: TObject);
var
  FileName, Path: String;
begin
  Path := GetCurrentDir;

  if SelectDirectory('Select ProfiCAD installation directory:', '', Path) then
  begin
    FileName := IncludeTrailingPathDelimiter(Path) + KeyFileName;

    if CreateKeyFile(FileName, edtName.Text, edtCompany.Text) then
      Application.MessageBox(PChar(Format('Key file created successfully.'#13#10#13#10 +
      '%s'#13#10#13#10 +
      'Remember to block the application with your firewall.', [FileName])),
        PChar(Caption), MB_ICONINFORMATION or MB_OK)
    else
      Application.MessageBox(PChar(Format('Cannot create key file!'#13#10#13#10 +
      '%s'#13#10#13#10 +
      'Make sure you have admin rights and try again.', [FileName])), 'Error',
        MB_ICONWARNING or MB_OK);
  end;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Caption := Application.Title;
  edtName.Text := Utils.GetUserName;
  edtCompany.Text := 'Home';

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
  edtName.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.lblHomepageClick(Sender: TObject);
begin
  if not OpenURL('https://www.proficad.com') then
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
  Len1, Len2: Integer;
begin
  Len1 := Length(Trim(edtName.Text));
  Len2 := Length(Trim(edtCompany.Text));
  btnCreateKeyFile.Enabled := (Len1 >= 1) and (Len1 <= 100) and
                              (Len2 >= 1) and (Len2 <= 100);
end;

end.
