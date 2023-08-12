//==============================================================================
// Main program
//------------------------------------------------------------------------------
// WinMend Products Keygen
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

program Keygen;

{$R 'Resources\Application.res' 'Resources\Application.rc'}

uses
  Forms,
  FormMain in 'Forms\FormMain.pas' {MainForm},
  ProductLicense in 'Units\ProductLicense.pas',
  StringConsts in 'Units\StringConsts.pas',
  VistaAltFixUnit in 'Units\VistaAltFixUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'WinMend Products Keygen';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
