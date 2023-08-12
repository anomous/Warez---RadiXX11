unit Utils;

interface

function GetUserName: String;
function OpenURL(const URL: String): Boolean;

implementation

uses
  Windows,
  Forms,
  ShellAPI;

//------------------------------------------------------------------------------

function GetUserName: String;
const
  UNLEN = 256;
var
  Buffer: array[0..UNLEN] of Char;
  Len: DWORD;
begin
  Len := UNLEN + 1;

  if Windows.GetUserName(Buffer, Len) then
    Result := Buffer
  else
    Result := '';
end;

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

end.
