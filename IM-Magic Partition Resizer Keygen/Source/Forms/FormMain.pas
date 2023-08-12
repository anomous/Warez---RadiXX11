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
    cboEdition: TComboBox;
    edtKey: TEdit;
    imgBanner: TImage;
    lblHomepage: TLabel;
    lblKey: TLabel;
    lblName: TLabel;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure lblHomepageClick(Sender: TObject);
    procedure lblHomepageMouseEnter(Sender: TObject);
    procedure lblHomepageMouseLeave(Sender: TObject);
    procedure OnChange(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
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

procedure TMainForm.btnAboutClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Format('%s'#13#10#13#10 +
    'Version 1.0'#13#10#13#10 +
    '© 2018, RadiXX11', [Caption])), 'About', MB_ICONINFORMATION or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnCopyClick(Sender: TObject);
begin
  edtKey.SelectAll;
  edtKey.CopyToClipboard;
  edtKey.SelLength := 0;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnGenerateClick(Sender: TObject);
begin
  edtKey.Text := GenerateKey(TEditionType(cboEdition.ItemIndex));
  btnCopy.Enabled := True;
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
  btnGenerate.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.InitializeControls;
var
  Edition: TEditionType;
begin
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
  Caption := Application.Title;

  cboEdition.Items.BeginUpdate;

  for Edition := Low(TEditionType) to High(TEditionType) do
    cboEdition.Items.Add(EditionTypeStr[Edition]);

  cboEdition.Items.EndUpdate;

  if cboEdition.Items.Count > 0 then
    cboEdition.ItemIndex := 0; 

  OnChange(nil);
  lblHomepage.OnMouseLeave(nil);
end;

//------------------------------------------------------------------------------

procedure TMainForm.lblHomepageClick(Sender: TObject);
begin
  try
    ShellExecute(Handle, 'open', 'https://www.resize-c.com', nil, nil, SW_SHOWNORMAL);
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

procedure TMainForm.OnChange(Sender: TObject);
begin
  btnGenerate.Click;
end;

end.
