program Keygen;

{$APPTYPE CONSOLE}

uses
  MD5,
  SysUtils;

//------------------------------------------------------------------------------

function GenerateLicenseKey(const Name: String): String;
const
  Charset = '0123456789ABCDEFGHJKLMNPQRTUVWXY';
var
  Digest: TMD5Digest;
  I: Integer;
begin
  if (Length(Name) >= 1) and (Length(Name) <= 30) then
  begin
    Digest := MD5FromString(UpperCase(Name) + 'yup, still free for private use.');

    SetLength(Result, 16);

    for I := 0 to 15 do
      Result[I + 1] := Charset[(Digest.Bytes[I] mod 32) + 1];

    Insert('-', Result, 5);
    Insert('-', Result, 10);
    Insert('-', Result, 15);
  end
  else
    Result := '';
end;

//------------------------------------------------------------------------------

var
  Name, LicenseKey: String;

begin
  // https://dexpot.de

  WriteLn('Dexpot 1.x Keygen [by RadiXX11]');
  WriteLn('===============================');
  WriteLn;

  while True do
  begin
    Write('Name.......: ');
    ReadLn(Name);

    if Name <> '' then
    begin
      LicenseKey := GenerateLicenseKey(Name);

      if LicenseKey <> '' then
      begin
        WriteLn('License Key: ', LicenseKey);
        Break;
      end
      else
        WriteLn('Name must have from 1 to 30 chars!');
    end
    else
      Break;
  end;

  ReadLn;
end.
 