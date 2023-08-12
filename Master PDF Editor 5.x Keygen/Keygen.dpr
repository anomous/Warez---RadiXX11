program Keygen;

{$APPTYPE CONSOLE}

uses
  SHA1,
  SysUtils;

//------------------------------------------------------------------------------

function GetRandomAlNumStr(Len: Integer): String;
const
  Charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
  I: Integer;
begin
  SetLength(Result, Len);

  for I := 1 to Len do
    Result[I] := Charset[Random(Length(Charset)) + 1];
end;

//------------------------------------------------------------------------------

function GenerateCodes(const ComputerID: String;
  var RegistrationCode, ActivationCode: String): Boolean;
var
  Hash1, Hash2: String;
  I: Integer;
begin
  if Length(ComputerID) = 40 then
  begin
    RegistrationCode := GetRandomAlNumStr(18);
    Hash1 := SHA1ToString(SHA1FromString(SHA1ToString(SHA1FromString(RegistrationCode))));
    Hash2 := SHA1ToString(SHA1FromString(SHA1ToString(SHA1FromString(Copy(ComputerID, 1, 36)))));
    ActivationCode := '';

    for I := 1 to Length(Hash1) do
      ActivationCode := ActivationCode + Hash1[I] + Hash2[I];

    ActivationCode := SHA1ToString(SHA1FromString(ActivationCode), True) + GetRandomAlNumStr(10);
    Result := True;
  end
  else
    Result := False;
end;

//------------------------------------------------------------------------------

var
  ComputerID, RegistrationCode, ActivationCode: String;
  Flag: Boolean;

begin
  Randomize;

  WriteLn('Master PDF Editor 5.x Keygen [by RadiXX11]');
  WriteLn('==========================================');
  WriteLn;

  repeat
    Write('Computer ID......: ');
    ReadLn(ComputerID);

    if Trim(ComputerID) <> '' then
    begin
      Flag := GenerateCodes(ComputerID, RegistrationCode, ActivationCode);

      if Flag then
      begin
        WriteLn('Registration Code: ', RegistrationCode);
        WriteLn('Activation Code..: ', ActivationCode);
      end
      else
        WriteLn('Enter a valid computer ID!'#13#10);
    end
    else
      Flag := True;
  until Flag;

  ReadLn;
end.
