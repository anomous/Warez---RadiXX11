program Keygen;

{$APPTYPE CONSOLE}

uses
  MD5,
  SysUtils;

//------------------------------------------------------------------------------
  
function XORString(const S: String): String;
var
  I: Integer;
begin
  Result := S;
  for I := 1 to Length(Result) do
    Result[I] := Char(Byte(Result[I]) xor 4);
end;

//------------------------------------------------------------------------------

function GenerateSerial(const Name, EMail: String): String;
var
  I: Integer;
begin
  Result := MD5ToString(MD5FromString(MD5ToString(MD5FromString(XORString(Trim(Name) + '8b3zo'))) +
            '-' + MD5ToString(MD5FromString(XORString(Trim(EMail) + 'c6ete'))) + '-' +
            MD5ToString(MD5FromString(XORString('300330759krx5l')))));
  Result[8] := '-';
  Result[16] := '-';
  Result[24] := '-';
  Result := UpperCase(Result);

  for I := 1 to Length(Result) do
  begin
    if Result[I] = '0' then
      Result[I] := 'E';
  end;
end;

//------------------------------------------------------------------------------

var
  Name, EMail: String;

begin
  WriteLn('NETGATE Registry Cleaner Keygen [by RadiXX11]');
  WriteLn('=============================================');
  WriteLn;

  Write('Name..: ');
  ReadLn(Name);

  if Name <> '' then
  begin
    Write('EMail.: ');
    ReadLn(EMail);

    if EMail <> '' then
      WriteLn('Serial: ', GenerateSerial(Name, EMail));
  end;

  ReadLn;
end.
