unit FormMain;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  jpeg, VistaAltFixUnit;

type
  TMainForm = class(TForm)
    Bevel: TBevel;
    btnAbout: TButton;
    btnActivate: TButton;
    cboProduct: TComboBox;
    imgBanner: TImage;
    lblHomepage: TLabel;
    lblProduct: TLabel;
    VistaAltFix: TVistaAltFix;

    procedure btnAboutClick(Sender: TObject);
    procedure btnActivateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure lblHomepageClick(Sender: TObject);
    procedure lblHomepageMouseEnter(Sender: TObject);
    procedure lblHomepageMouseLeave(Sender: TObject);

  private
    function OpenURL(const URL: String): Boolean;
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

procedure TMainForm.btnActivateClick(Sender: TObject);
begin
  if cboProduct.ItemIndex >= 0 then
  begin
    if ProductIsActivated(ProductList[cboProduct.ItemIndex]) then
    begin
      if Application.MessageBox(PChar(Format('%s is already activated.'#13#10#13#10 +
          'Overwrite activation info?',
          [ProductList[cboProduct.ItemIndex].Name])), PChar(Caption),
          MB_ICONWARNING or MB_YESNO) = IDNO then Exit;
    end;

    if ActivateProduct(ProductList[cboProduct.ItemIndex]) then
      Application.MessageBox(PChar(Format('%s activated successfully.',
        [ProductList[cboProduct.ItemIndex].Name])), PChar(Caption),
        MB_ICONINFORMATION or MB_OK)
    else
      Application.MessageBox(PChar(Format('Cannot activate %s!',
        [ProductList[cboProduct.ItemIndex].Name])), 'Error',
        MB_ICONWARNING or MB_OK)
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
  cboProduct.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.lblHomepageClick(Sender: TObject);
begin
  if not OpenURL('https://www.ebook-converter.com') then
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

function TMainForm.OpenURL(const URL: String): Boolean;
begin
  try
    Result := ShellExecute(Application.Handle, 'open', PChar(URL), nil, nil,
      SW_SHOWNORMAL) > 32;
  except
    Result := False;
  end;
end;

end.
