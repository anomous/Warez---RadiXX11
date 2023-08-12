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
var
  Buffer: array[0..256] of Char;
  Len: DWORD;
begin
  Len := SizeOf(Buffer);

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
