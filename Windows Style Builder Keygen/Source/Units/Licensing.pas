unit Licensing;

interface

function GenerateKey(const EMail: String): String;

implementation

function GenerateKey(const EMail: String): String;
var
  S: String;
  Value2: Int64;
  I, J, Checksum, Value1: Integer;
begin
  Result := '';

  // Quick validation of email format
  if (Pos('@', EMail) = 0) or (Pos('.', EMail) = 0) then
  begin
    Result := '1';
    Exit;
  end;

  // Minimum length of email is 10 chars
  if Length(EMail) < 10 then
  begin
    Result := '2';
    Exit;
  end;

  S := EMail;

  while Length(S) < 64 do
    S := S + EMail;

  Checksum := 0;

  for I := 1 to 64 do
    Inc(Checksum, Byte(S[I]) shr 2);

  I := 2;
  J := 6;

  while I < 32 do
  begin
    Value1 := (Byte(S[J]) + Byte(S[J - 1])) xor (((I shl 4) + (Checksum and $FF)) and $FF);
    Value2 := $4EC4EC4F * (Int64(Value1) and $FF);
    Result := Result + Char((Value2 shr 35) + 65) + Char((Value1 mod 26) + 65);
    Inc(J, 2);
    Inc(I);
  end;

  Result := 'VSBX' + Result;
end;

end.
