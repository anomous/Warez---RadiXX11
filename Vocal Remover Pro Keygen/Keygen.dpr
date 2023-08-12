program Keygen;

{$APPTYPE CONSOLE}

uses
  MD5,
  SysUtils;

//------------------------------------------------------------------------------

function GenerateKey(const EMail: String): String;
begin
  Result := Copy(MD5ToString(MD5FromString(Trim(LowerCase(EMail)) + 'VOCALREMOVERPRO'), True), 1, 4) + '-' +
            Copy(MD5ToString(MD5FromString(Trim(LowerCase(EMail)) + 'ABBY'), True), 29, 4) + '-' +
            Copy(MD5ToString(MD5FromString(Trim(LowerCase(EMail)) + 'AUDI RS5'), True), 1, 4) + '-' +
            Copy(MD5ToString(MD5FromString(Trim(LowerCase(EMail)) + 'PORSCHE CAYMAN'), True), 29, 4);
end;

//------------------------------------------------------------------------------

var
  EMail: String;

begin
  WriteLn('Vocal Remover Pro Keygen [by RadiXX11]');
  WriteLn('======================================');
  WriteLn;

  Write('EMail: ');
  ReadLn(EMail);

  if Trim(EMail) <> '' then
    WriteLn('Key..: ', GenerateKey(EMail));

  ReadLn;
end.
