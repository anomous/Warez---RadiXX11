program Keygen;

{$APPTYPE CONSOLE}

uses
  Windows,
  SysUtils;

//------------------------------------------------------------------------------
  
function GenerateSerial: String;
const
  Charset = '2YOPB3AQCVUXMNRS97WE0IZD4KLFGHJ8165T';
var
  S: String;
  I, J, K, L, Value: Integer;
begin
  Result := '';
  L := 0;

  SetLength(S, 5);

  while True do
  begin
    K := 0;

    for I := 1 to 5 do
    begin
      J := Random(Length(Charset)) + 1;
      S[I] := Charset[J];

      Inc(K, (J - 1) + 36 * K);
    end;

    case L of
      1: Value := 23;
      2: Value := 17;
      3: Value := 53;
    else
      Value := 43;
    end;

    if (K mod Value) = 0 then
    begin
      Inc(L);

      Result := Result + S;

      if L < 4 then
        Result := Result + '-'
      else
        Break;
    end;
  end;
end;

//------------------------------------------------------------------------------

function RegisterApp(const FName, LName, EMail, Serial: String): Boolean;
var
  Key: HKEY;
  Data: DWORD;
begin
  Result := False;

  if RegCreateKeyEx(HKEY_LOCAL_MACHINE, 'SOFTWARE\Internet Download Manager', 0,
    nil, 0, KEY_WRITE, nil, Key, nil) = ERROR_SUCCESS then
  begin
    Data := 3;

    RegSetValueEx(Key, 'InstallStatus', 0, REG_DWORD, @Data, SizeOf(Data));
    RegSetValueEx(Key, 'FName', 0, REG_SZ, PChar(FName), Length(FName));
    RegSetValueEx(Key, 'LName', 0, REG_SZ, PChar(LName), Length(LName));
    RegSetValueEx(Key, 'Email', 0, REG_SZ, PChar(EMail), Length(EMail));
    RegSetValueEx(Key, 'Serial', 0, REG_SZ, PChar(Serial), Length(Serial));
    RegCloseKey(Key);

    Result := True;
  end;
end;

//------------------------------------------------------------------------------

var
  FName, LName, EMail, Serial: String;

begin
  Randomize;

  WriteLn('Internet Download Manager 6.x Keygen [by RadiXX11]');
  WriteLn('==================================================');
  WriteLn;
  WriteLn('IMPORTANT: generated keys will not work unless you block specific IPs'#13#10'           or use a patched app to avoid license check.');
  WriteLn;

  Write('First Name...: ');
  ReadLn(FName);

  if FName <> '' then
  begin
    Write('Last Name....: ');
    ReadLn(LName);

    if LName <> '' then
    begin
      Write('EMail........: ');
      ReadLn(EMail);

      if EMail <> '' then
      begin
        Serial := GenerateSerial;

        WriteLn('Serial Number: ', Serial);
        WriteLn;

        if RegisterApp(FName, LName, EMail, Serial) then
          WriteLn('Application registered sucessfully.')
        else
          WriteLn('Cannot register application. Make sure to run this keymaker as admin.');
      end;
    end;
  end;

  ReadLn;
end.
