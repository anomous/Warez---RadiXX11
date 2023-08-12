unit Licensing;

interface

function GenerateRegCode(const UserName: String): String;

implementation

uses
  CRC16,
  SysUtils;

//------------------------------------------------------------------------------

const
  EncodingCharset = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
  HexCharset = '0123456789ABCDEF';

//------------------------------------------------------------------------------

procedure AddUserNameChecksums(const UserName: String; var RegCode: String);
var
  I, Sum: Integer;
begin
  Sum := 1;

  for I := 1 to Length(UserName) do
    Inc(Sum, Byte(UserName[I]));

  RegCode[5] := HexCharset[((((9 * Sum + 10) div 3 + 36) mod 16) and $0F) + 1];
  RegCode[7] := HexCharset[((7 * ((Sum + 23) div 6 + 3) mod 16) and $0F) + 1];
  RegCode[8] := HexCharset[(((3 * Sum + 19) div 9 mod 16) and $0F) + 1];
  RegCode[9] := HexCharset[(((5 * Sum + 11) div 5 mod 16) and $0F) + 1];
  RegCode[10] := HexCharset[(((3 * Sum + 39) div 8 mod 16) and $0F) + 1];
  RegCode[11] := HexCharset[((8 * ((Sum + 10) div 3) mod 16) and $0F) + 1];
end;

//------------------------------------------------------------------------------

function EncodeChar(C: Char): Char;
var
  Value: Integer;
begin
  if C in ['0'..'9'] then
    Value := Byte(C) - 48
  else
    Value := Byte(C) - 55;

  Value := (Value * 2) + 1;

  if Value <= Length(EncodingCharset) then
    Result := EncodingCharset[Value]
  else
    Result := EncodingCharset[1];
end;

//------------------------------------------------------------------------------

function EncodeString(const S: String): String;
var
  I: Integer;
begin
  Result := '';

  for I := 1 to Length(S) do
    Result := Result + IntToHex(Byte(S[I]), 4);
end;

//------------------------------------------------------------------------------

function EncodeRegCode(const RegCode: String): String;
var
  I: Integer;
begin
  Result := RegCode;

  for I := 1 to Length(Result) do
  begin
    if (I mod 6) <> 0 then
      Result[I] := EncodeChar(Result[I]);
  end;
end;

//------------------------------------------------------------------------------

function LeftTrim(const S: String): String;
var
  I: Integer;
begin
  for I := 1 to Length(S) do
  begin
    if not (S[I] in [#9, #32]) then
    begin
      Result := Copy(S, I, MaxInt);
      Exit;
    end;
  end;

  Result := '';
end;

//------------------------------------------------------------------------------

function GenerateRegCode(const UserName: String): String;
var
  S, S1, S2: String;
  I: Integer;
begin
  S := LeftTrim(UserName);

  SetLength(Result, 29);

  for I := 1 to 29 do
  begin
    if (I mod 6) <> 0 then
      Result[I] := HexCharset[Random(Length(HexCharset)) + 1]
    else
      Result[I] := '-';
  end;

  AddUserNameChecksums(S, Result);

  S1 := EncodeString(S);
  S2 := CRC16ToString(CRC16FromString(S1), True);

  Result[3] := S2[1];
  Result[4] := S2[2];

  S1 := EncodeString(Copy(Result, 3, MaxInt));
  S2 := CRC16ToString(CRC16FromString(S1), True);

  Result[1] := S2[1];
  Result[2] := S2[2];

  Result := EncodeRegCode(Result);
end;

end.
