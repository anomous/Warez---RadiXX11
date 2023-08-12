unit Licensing;

interface

function GenerateSerial(const Name, EMail: String): String;

implementation

uses
  DCPbase64,
  SysUtils;

function GetChecksum(const S: String): String;
var
  I: Integer;
  Num, Num2: Word;
begin
  Num := 86;
  Num2 := 175;

  if S <> '' then
  begin
    for I := 1 to Length(S) do
    begin
      Inc(Num2, Byte(S[i]));

      if Num2 > 255 then
        Dec(Num2, 255);

      Inc(Num, Num2);

      if Num > 255 then
        Dec(Num, 255);
    end;
  end;

  Result := IntToHex((Num shl 8) + Num2, 4);
end;

//------------------------------------------------------------------------------

function GetKeyByte(Seed: Int64; A, B, C: Byte): Byte;
begin
  A := A mod 25;
  B := B mod 3;

  if (A mod 2) = 0 then
    Result := Byte(((Seed shr A) and 255) xor ((Seed shr B) or C))
  else
    Result := Byte(((Seed shr A) and 255) xor ((Seed shr B) and C));
end;

//------------------------------------------------------------------------------

function MakeKey(const Key: String): String;
var
  Seed: Int64;
begin
  Result := '';

  if TryStrToInt64('$' + Copy(Key, 1, 8), Seed) then
  begin
    Result := Key + IntToHex(GetKeyByte(seed, 24, 3, 200), 2) +
              IntToHex(GetKeyByte(seed, 10, 0, 56), 2) +
              IntToHex(GetKeyByte(seed, 1, 2, 91), 2) +
              IntToHex(GetKeyByte(seed, 7, 1, 100), 2);
    Result := Result + GetChecksum(Result);
  end;
end;

//------------------------------------------------------------------------------

function RandomString(Len: Integer): String;
const
  Charset = '0123456789';
var
  I: Integer;
begin
  SetLength(Result, Len);
  for I := 1 to Len do
    Result[I] := Charset[Random(Length(Charset)) + 1];
end;

//------------------------------------------------------------------------------

function Rot13(const Value: String): String;
var
  I, Num: Integer;
begin
  Result := Value;

  for I := 1 to Length(Result) do
  begin
    Num := Byte(Result[I]);

    if (Num >= 97) and (Num <= 122) then
    begin
      if Num > 109 then
        Dec(Num, 13)
      else
        Inc(Num, 13);
    end else if (Num >= 65) and (Num <= 90) then
    begin
      if Num > 77 then
        Dec(Num, 13)
      else
        Inc(num, 13);
    end;

    Result[I] := Char(Num);
  end;
end;

//------------------------------------------------------------------------------

function GenerateSerial(const Name, EMail: String): String;
begin
  Result := Rot13(Base64EncodeStr(Rot13(Name) + '^' + Rot13(EMail) + '^' +
            MakeKey(RandomString(8)) + '^' + RandomString(8)));
end;

end.
 