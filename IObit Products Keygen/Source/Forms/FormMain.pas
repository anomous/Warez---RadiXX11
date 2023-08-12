//==============================================================================
// Main form
//------------------------------------------------------------------------------
// IObit Products Keygen
// © 2016, RadiXX11
//------------------------------------------------------------------------------
// DISCLAIMER
//
// This program is provided "AS IS" without any warranty, either expressed or
// implied, including, but not limited to, the implied warranties of
// merchantability and fitness for a particular purpose.
//
// This program and its source code are distributed for educational and
// practical purposes ONLY.
//
// You are not allowed to get a monetary profit of any kind through its use.
//
// The author will not take any responsibility for the consequences due to the
// improper use of this program and/or its source code.
//==============================================================================

unit FormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls;

type
  TMainForm = class(TForm)
    bScrollingText: TBevel;  
    btnAbout: TButton;
    btnCopy: TButton;
    btnGenerate: TButton;
    cbProduct: TComboBox;
    imgLogo: TImage;
    lblProduct: TLabel;
    lblRegCode: TLabel;
    mRegCode: TMemo;
    pScrollingText: TPanel;
    stScrollingText: TStaticText;
    tmrFadeEffect: TTimer;
    tmrScrollingText: TTimer;
    btnPatchHosts: TButton;
        
    procedure btnAboutClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure btnPatchHostsClick(Sender: TObject);
    procedure cbProductChange(Sender: TObject);
    procedure cbProductCloseUp(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure tmrScrollingTextTimer(Sender: TObject);

  private
    FDefWndProc: TWndMethod;

    procedure FadeIn(Sender: TObject);
    procedure FadeOut(Sender: TObject);
    procedure FillProductList;
    procedure NewWndProc(var Msg: TMessage);
  end;

var
  MainForm: TMainForm;

implementation

uses
  HostsFile,
  LicenseCode,
  ProductLicense,
  StringConsts,
  VistaAltFixUnit;

{$R *.dfm}

//------------------------------------------------------------------------------
// TMainForm
//------------------------------------------------------------------------------

procedure TMainForm.btnAboutClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Format(sAboutBoxText, [Application.Title])),
    sAboutCaption, MB_ICONINFORMATION or MB_OK);
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnCopyClick(Sender: TObject);
begin
  mRegCode.SelectAll;
  mRegCode.CopyToClipboard;
  mRegCode.ClearSelection;
  mRegCode.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnGenerateClick(Sender: TObject);
begin
  mRegCode.Font.Color := clWindowText;

  // make sure that we have a valid selection
  if cbProduct.ItemIndex >= 0 then
  begin
    with ProductList[cbProduct.ItemIndex] do
      mRegCode.Text := GenerateCode(Version);
    btnCopy.Enabled := True;
  end
  else
  begin
    mRegCode.Clear;
    btnCopy.Enabled := False;
  end;

  mRegCode.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.btnPatchHostsClick(Sender: TObject);
begin
  // make sure that we have a valid selection
  if cbProduct.ItemIndex < 0 then Exit;

  with ProductList[cbProduct.ItemIndex] do
  begin
    try
      if HostsEntryExists(Host) then
      begin
        Application.MessageBox(sHostsFileAlreadyPatched, sInformationCaption,
          MB_ICONINFORMATION or MB_OK);
        Exit;
      end;

      AddHostsEntry('127.0.0.1', Host);

      Application.MessageBox(sHostsFilePatchedSucessfully, sInformationCaption,
        MB_ICONINFORMATION or MB_OK);

    except
      Application.MessageBox(PChar(Format(sCannotOpenHostsFile, ['127.0.0.1', Host])),
        sWarningCaption, MB_ICONWARNING or MB_OK);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TMainForm.cbProductChange(Sender: TObject);
begin
  btnGenerate.Click;
end;

//------------------------------------------------------------------------------

procedure TMainForm.cbProductCloseUp(Sender: TObject);
begin
  mRegCode.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FadeIn(Sender: TObject);
var
  Value: Integer;
begin
  Value := AlphaBlendValue + 5;

  if Value >= 255 then
  begin
    // stop alpha blend effect
    AlphaBlendValue := 255;
    tmrFadeEffect.Enabled := False;
  end
  else
    AlphaBlendValue := Value;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FadeOut(Sender: TObject);
var
  Value: Integer;
begin
  Value := AlphaBlendValue - 5;

  if Value <= 0 then
  begin
    // stop alpha blend effect and close the form
    AlphaBlendValue := 0;
    tmrFadeEffect.Enabled := False;
    Close;
  end
  else
    AlphaBlendValue := Value;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FillProductList;
var
  I: Integer;
begin
  cbProduct.Items.BeginUpdate;
  
  try
    for I := Low(ProductList) to High(ProductList) do
    begin
      with ProductList[I] do
        cbProduct.Items.Add(Format('%s %d.x', [Name, Version]));
    end;

  finally
    cbProduct.Items.EndUpdate;

    if cbProduct.Items.Count > 0 then
      cbProduct.ItemIndex := 0;
  end;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if AlphaBlendValue > 0 then
  begin
    CanClose := False;

    if not tmrFadeEffect.Enabled then
    begin
      // start form fade-out effect
      tmrFadeEffect.OnTimer := FadeOut;
      tmrFadeEffect.Enabled := True;
    end;
  end
  else
    CanClose := True;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);
begin
{$IF CompilerVersion < 20}
  // fix for ALT issue
  TVistaAltFix.Create(Self);
{$IFEND}

  // change default message handler
  FDefWndProc := WindowProc;
  WindowProc := NewWndProc;

  Caption := Application.Title;

  // set up form controls
  pScrollingText.Left := bScrollingText.Left + 1;
  pScrollingText.Top := bScrollingText.Top + 1;
  pScrollingText.Width := bScrollingText.Width - 4;
  pScrollingText.Height := bScrollingText.Height - 4;
  stScrollingText.Left := pScrollingText.ClientWidth;
  stScrollingText.Top := 0;
  stScrollingText.Caption := Format(sScrollingText, [Application.Title]);

  btnCopy.Enabled := False;

  Randomize;
  FillProductList;

  // start form fade-in effect
  tmrFadeEffect.OnTimer := FadeIn;
  tmrFadeEffect.Enabled := True;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  // restore default message handler
  WindowProc := FDefWndProc;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then Close;
end;

//------------------------------------------------------------------------------

procedure TMainForm.FormShow(Sender: TObject);
begin
  mRegCode.Font.Color := clGrayText;
  mRegCode.Text := sInformationText;
end;

//------------------------------------------------------------------------------

procedure TMainForm.NewWndProc(var Msg: TMessage);
begin
  case Msg.Msg of
    WM_ENTERSIZEMOVE:
      AlphaBlendValue := 170;

    WM_EXITSIZEMOVE:
      AlphaBlendValue := 255;
  end;

  // call default message handler
  FDefWndProc(Msg);
end;

//------------------------------------------------------------------------------

procedure TMainForm.tmrScrollingTextTimer(Sender: TObject);
begin
  stScrollingText.Left := stScrollingText.Left - 1;

  if stScrollingText.Left <= -stScrollingText.Width then
    stScrollingText.Left := pScrollingText.ClientWidth;
end;

end.
