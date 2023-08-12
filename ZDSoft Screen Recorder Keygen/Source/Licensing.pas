unit Licensing;

interface

function GenerateKey(const EMail: String): String;

implementation

uses
  MD5,
  SysUtils;

function GenerateKey(const EMail: String): String;
var
  I, J: Integer;
begin
  Result := MD5ToString(MD5FromString('Software\ZD Soft\Screen Recorder\' + LowerCase(EMail)), True);
  I := Random(1000) + 1;

  for J := 1 to I - 1 do
    Result := MD5ToString(MD5FromString(Result), True);

  for J := 1 to Length(Result) do
  begin
    if Result[J] in ['0'..'9'] then
    begin
      if ((((J - 1) mod 2) = 0) and ((Byte(Result[J]) mod 2) <> 0)) or
        ((((J - 1) mod 2) <> 0) and ((Byte(Result[J]) mod 2) = 0)) then
      begin
        Result[J] := Char(((I + J + Byte(Result[J]) - 2) mod $14) + $47);

        if Result[J] = 'O' then Result[J] := '0';
        if Result[J] = 'I' then Result[J] := '1';
        if Result[J] = 'Z' then Result[J] := '2';
      end;
    end;
  end;

  Delete(Result, Length(Result) - 6, 7);

  J := 1;
  while J < Length(Result) do
  begin
    if (J mod 6) = 0 then
      Insert('-', Result, J);

    Inc(J);
  end;
end;

end.
