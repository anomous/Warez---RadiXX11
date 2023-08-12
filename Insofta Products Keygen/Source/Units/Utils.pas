unit Utils;

interface

function OpenURL(const URL: String): Boolean;

implementation

uses
  Windows,
  Forms,
  ShellAPI;

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
