unit Utils;

interface

function GetFolderPath(CSIDL: Integer): String;
function OpenURL(const URL: String): Boolean;

implementation

uses
  Windows,
  Forms,
  ShellAPI;

//------------------------------------------------------------------------------

function SHGetFolderPath(hwnd: HWND; csidl: Integer; hToken: THandle;
  dwFlags: DWORD; pszPath: LPSTR): HResult; stdcall;
  external 'shell32.dll' name 'SHGetFolderPathA';

//------------------------------------------------------------------------------

function GetFolderPath(CSIDL: Integer): String;
const
  SHGFP_TYPE_CURRENT = 0;
var
  Path: array[0..MAX_PATH] of Char;
begin
  if SHGetFolderPath(0, CSIDL, 0, SHGFP_TYPE_CURRENT, Path) = S_OK then
    Result := Path
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
