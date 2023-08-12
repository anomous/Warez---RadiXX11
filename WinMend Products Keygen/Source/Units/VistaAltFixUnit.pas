{
Copyright © Norstedts Juridik AB
Made by Per-Erik Andersson, inspired by J Hamblin - Qtools Software.
Author grants unrestricted use of this software code.
All use is on your own risk.

J Hamblin has made a component TjhALTBugFix to solve a problem in Vista.
It can be downloaded from CodeGear Quality centre here:
http://qc.codegear.com/wc/qcmain.aspx?d=37403
Below is the text J Hamblin wrote that describes the problem:

** Quote **************
There seems to be a problem with THEMES support in Delphi, in which
TButton, TCheckBox, TRadioButton and TStaticText standard controls
vanish in VISTA when the ALT key is pressed. (only TStaticText vanishes in XP).
If the OS is set to default, pressing the ALT key in XP and Vista has the
behavior of displaying the underline under the accelerator keys.

The mentioned controls vanish the first time ALT is pressed. They can be
restored by repainting the control in code. Once restored, they are not
affected by subsequent ALT key presses -- unless a pagecontrol on the form
changes to a new tabsheet, then all affected controls, both on the tabsheet
and on the form, will vanish on next ALT press. Due to the pagecontrol issue
there is no way to set a flag to do the repaint op only once. In MDI applications,
an ALT key press has the same affect on all child forms at the same time.
** End quote **************

The TjhALTBugFix needs to be put on each form in the application which
is a problem in many large applications. Therefore I made this component
that can be dropped on the main form and then handles all delphi forms
that are created.

The component works like this: In Idle it goes through the list of existing
Delphi forms in TScreen. When a new form is found, its WindowProc is replaced
with a hook that listens for the event WM_UPDATEUISTATE which is the
message triggering the error.
When a form has got an WM_UPDATEUISTATE it gets a flag the says it needs to
be redrawn. The next time the application enters Idle a repaint is made,
depending on the property RepaintAll. If it is true all TWinControls on the
form gets a repaint. If its false only the component that probably needs a
repaint is repainted (that code mady by J Hamblin).
The "repaint all" is an precausion for third part components that might behave in
the same way. RepaintAll is default true.
Note that this component is only active in Vista. If you want it to
handle the TStaticText in XP you have to remove the VistaWithTheme check
in TVistaAltFix.Create.

Usage:
If you want to use this as an component you have to install it into the Delphi IDE.
If you don't want to do that just add this code in your main form OnCreate:

procedure TMainForm.FormCreate(Sender: TObject);
begin
  TVistaAltFix.Create(Self);
end;

}

unit VistaAltFixUnit;

interface

uses
  Windows, Classes;

type
  TVistaAltFix = class(TComponent)
  private
    FInstalled: Boolean;
    function VistaWithTheme: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

procedure Register;

implementation

uses
  Messages, Themes;

procedure Register;
begin
  RegisterComponents('MEP', [TVistaAltFix]);
end;

var
  FInstallCount: Integer = 0;
  FCallWndProcHook: Cardinal = 0;

{ TVistaAltFix }

function CallWndProcFunc(
  nCode: Integer;
  wParam: WPARAM;
  lParam: LPARAM): LRESULT; stdcall;
var
  p: PCWPSTRUCT;
begin
  if nCode = HC_ACTION then
  begin
    p := PCWPSTRUCT(lParam);
    if p.message = WM_UPDATEUISTATE then
    begin
      InvalidateRect(p.hwnd, nil, False);
    end;
  end;
  Result := CallNextHookEx(FCallWndProcHook, nCode, wParam, lParam);
end;

constructor TVistaAltFix.Create(AOwner: TComponent);
begin
  inherited;
  if VistaWithTheme and not (csDesigning in ComponentState) then
  begin
    Inc(FInstallCount); // Allow more than 1 instance, assume single threaded as VCL is not thread safe anyway
    if FInstallCount = 1 then
      FCallWndProcHook := SetWindowsHookEx(WH_CALLWNDPROC, CallWndProcFunc, 0, GetCurrentThreadID);
    FInstalled := True;
  end;
end;

destructor TVistaAltFix.Destroy;
begin
  if FInstalled then
  begin
    Dec(FInstallCount);
    if FInstallCount = 0 then
    begin
      UnhookWindowsHookEx(FCallWndProcHook);
      FCallWndProcHook := 0;
    end;
  end;
  inherited Destroy;
end;

function TVistaAltFix.VistaWithTheme: Boolean;
var
  OSVersionInfo: TOSVersionInfo;
begin
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  if GetVersionEx(OSVersionInfo) and
     (OSVersionInfo.dwMajorVersion >= 6) and
     ThemeServices.ThemesEnabled then
    Result := True
  else
    Result := False;
end;

end.