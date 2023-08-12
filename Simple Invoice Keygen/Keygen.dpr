program Keygen;

{$APPTYPE CONSOLE}

uses
  MD5,
  SysUtils;

function GetActivationCode(const EMail: String): String;
begin
  Result := Copy(MD5ToString(MD5FromString(Trim(EMail) + '23m0odr32')), 1, 19);
  Result[5] := '-';
  Result[10] := '-';
  Result[15] := '-';
end;

var
  EMail: String;

begin
  WriteLn('=====================================');
  WriteLn(' Simple Invoice Keygen [by RadiXX11]');
  WriteLn('-------------------------------------');
  WriteLn('      www.simple-invoice.co.uk');
  WriteLn('=====================================');
  WriteLn;
  Write('EMail..........: ');

  ReadLn(EMail);

  if Trim(EMail) <> '' then
    WriteLn('Activation Code: ', GetActivationCode(EMail));

  ReadLn;
end.
