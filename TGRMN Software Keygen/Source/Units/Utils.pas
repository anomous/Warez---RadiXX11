unit Utils;

interface

uses
  Controls;

function OpenURL(const URL: String): Boolean;
procedure ShowEditBalloonTip(Control: TWinControl; Icon: Integer;
  Title, Text: WideString);

implementation

uses
  Windows,
  Forms,
  ShellAPI;

//------------------------------------------------------------------------------
  
function OpenURL(const URL: String): Boolean;
begin
  try
    Result := ShellExecute(Application.Handle, 'open', PChar(URL), nil, nil,
      SW_SHOWNORMAL) > 32;
  except
    Result := False;
  end;
end;

//------------------------------------------------------------------------------

procedure ShowEditBalloonTip(Control: TWinControl; Icon: Integer;
  Title, Text: WideString);
const
  ECM_FIRST = $1500;
  EM_SHOWBALLOONTIP = ECM_FIRST + 3;
  EM_HIDEBALLOONTIP = ECM_FIRST + 4;

type
  EDITBALLOONTIP = packed record
    cbStruct: DWORD;
    pszTitle: LPCWSTR;
    pszText: LPCWSTR;
    ttiIcon: Integer;  // NONE: 0; INFO: 1; WARNING: 2; ERROR: 3
  end;

  TEditBalloonTip = EDITBALLOONTIP;

var
  EBT: TEditBalloonTip;
begin
  // Show hint only if we have a title/text, otherwise just hide it
  if (Title <> '') and (Text <> '') then
  begin
    with EBT do
    begin
      cbStruct := SizeOf(EBT);
      pszTitle := PWChar(Title);
      pszText := PWChar(Text);
      ttiIcon := Icon;
    end;

    SendMessage(Control.Handle, EM_SHOWBALLOONTIP, 0, Integer(@EBT));
  end
  else
    SendMessage(Control.Handle, EM_HIDEBALLOONTIP, 0, 0);
end;

end.
