program Keygen;

{$APPTYPE CONSOLE}

uses
  Windows,
  SysUtils;

//------------------------------------------------------------------------------

function SHGetValue(hkey: HKEY; pszSubKey, pszValue: PAnsiChar;
  var pdwType: DWORD; pvData: Pointer; var pcbData: DWORD): DWORD; stdcall; external 'shlwapi.dll' name 'SHGetValueA';

function SHSetValue(hkey: HKEY; pszSubKey: PAnsiChar; pszValue: PAnsiChar;
  dwType: DWORD; pvData: Pointer; cbData: DWORD): DWORD; stdcall; external 'shlwapi.dll' name 'SHSetValueA';

//------------------------------------------------------------------------------

function GetAppVersion: String;
var
  Version: array[0..127] of Char;
  I, DataType, DataSize: DWORD;
begin
  Result := '';
  DataType := REG_SZ;
  DataSize := SizeOf(Version);

  if SHGetValue(HKEY_CURRENT_USER, 'Software\MadeForNet\HTTPDebuggerPro',
    'AppVer', DataType, @Version, DataSize) = ERROR_SUCCESS then
  begin
    for I := (DataSize - 2) downto 0 do
    begin
      if Version[I] in ['0'..'9'] then
        Result := Version[I] + Result;
    end;
  end;
end;

//------------------------------------------------------------------------------

function GetHash(const S: string): Integer;
var
  I, J, V1, V2, V3: Integer;
begin
  V1 := 0;

  if S[1] = #2 then
  begin
    J := 2;
    V2 := -1;
  end
  else
  begin
    J := 1;
    V2 := 0;
  end;

  for I := J to Length(S) do
  begin
    V3 := Byte(S[I]) - $30;
    V1 := V3 + 10 * V1;
  end;

  Result := V2 xor (V1 + V2);
end;

//------------------------------------------------------------------------------

function ActivateApp(const Key: String): Boolean;
var
  VolumeName, FileSystemName: array[0..127] of Char;
  VolumeSerial, MaxCompLen, FileSystemFlags: DWORD;
  Value: String;
begin
  GetVolumeInformation('C:\', VolumeName, SizeOf(VolumeName), @VolumeSerial,
    MaxCompLen, FileSystemFlags, FileSystemName, SizeOf(FileSystemName));
    
  Value := Format('SN%d', [((((not VolumeSerial) shr 1) + $02E0) xor $0590D4) xor GetHash(GetAppVersion)]);
  Result := SHSetValue(HKEY_CURRENT_USER, 'SOFTWARE\MadeForNet\HTTPDebuggerPro',
            PChar(Value), REG_SZ, PChar(Key), Length(Key)) = ERROR_SUCCESS;
end;

//------------------------------------------------------------------------------

function GenerateKey: String;
var
  V1, V2, V3: Byte;
begin
  V1 := Random($100);
  V2 := Random($100);
  V3 := Random($100);
  Result := Format('%.2X%.2X%.2X7C%.2X%.2X%.2X%.2X',
            [V1, V2 xor $7C, (not V1) and $FF, V2, V3, (V3 xor 7) and $FF,
            ((not V3) and $FF) xor V1]);
end;

//------------------------------------------------------------------------------

function IsAppInstalled: Boolean;
begin
  Result := GetAppVersion <> '';
end;

//------------------------------------------------------------------------------

var
  Key: String;

begin
  Randomize;

  WriteLn('HTTP Debugger Pro Keygen [by RadiXX11]');
  WriteLn('======================================');
  WriteLn;

  if IsAppInstalled then
  begin
    Key := GenerateKey;

    WriteLn('Key: ', Key);
    WriteLn;

    if ActivateApp(Key) then
      WriteLn('Application activated sucessfully.')
    else
      WriteLn('Cannot activate application!');
  end
  else
    WriteLn('Application not installed!');

  ReadLn;
end.
