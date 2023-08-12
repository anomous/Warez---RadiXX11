unit Licensing;

interface

function GenerateSerial: String;

implementation

uses
  SHA1,
  SysUtils;

//------------------------------------------------------------------------------

function GenerateSerial: String;
var
  Digest: TSHA1Digest;
  S: String;
  I, Value: Integer;
begin
  Result := '';
  S := 'SSS20';

  for I := 1 to 4 do
  begin
    Value := Random(1000); // 0 - 999
    S := S + Char(Value and $FF);
    Result := Result + Format('%.3d-', [Value]);
  end;

  Digest := SHA1FromString(S);

  repeat
    Value := Random(1000); // 0 - 999
  until (Value and $FF) = Digest.Bytes[0];

  Result := Result + Format('%.3d', [Value]);
end;

end.
