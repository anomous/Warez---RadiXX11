program Keygen;

{$APPTYPE CONSOLE}

uses
  SysUtils;

procedure GenerateKeys(var SerialNumber, ActivationCode: String);
const
  Charset: PChar = '23456789abcdefghjklmnpqrstuvwxyz';
var
  S: String;
  Value2: Int64;
  Value1, I, J, K, L: Integer;
  C: Char;
begin
  // Calculate serial number ///////////////////////////////////////////////////

  SetLength(S, 16);

  Value1 := Random($100);
  Value2 := ((Int64(((Value1 shl $0E) and $F0F0F0) + $0A0A0E) * $BCBE) + $3054) xor $5A5A5A5A5A;
  J := Value2 div $100000;
  K := Value2 mod $100000;
  L := $8000;

  for I := 0 to 1 do
  begin
    S[12 - I] := Charset[K div L];
    K := K mod L;
    L := L shr 5;
  end;

  S[10] := Charset[K div L];
  S[9] := Charset[K mod L];

  L := $8000;

  for I := 0 to 1 do
  begin
    S[16 - I] := Charset[J div L];
    J := J mod L;
    L := L shr 5;
  end;

  S[14] := Charset[J div L];
  S[13] := Charset[J mod L];

  Value2 := ((Int64(((Value1 shl $0E) and $0F0F0F) + $5050) * $575D) + $4A3B) xor $A5A5A5A5A5;
  J := Value2 div $100000;
  K := Value2 mod $100000;
  L := $8000;

  for I := 0 to 1 do
  begin
    S[4 - I] := Charset[K div L];
    K := K mod L;
    L := L shr 5;
  end;

  S[2] := Charset[K div L];
  S[1] := Charset[K mod L];

  L := $8000;

  for I := 0 to 1 do
  begin
    S[8 - I] := Charset[J div L];
    J := J mod L;
    L := L shr 5;
  end;

  S[6] := Charset[J div L];
  S[5] := Charset[J mod L];

  C := S[10];
  S[10] := S[13];
  S[13] := C;

  C := S[11];
  S[11] := S[14];
  S[14] := C;

  C := S[11];
  S[11] := S[15];
  S[15] := C;

  C := S[12];
  S[12] := S[16];
  S[16] := C;

  C := S[11];
  S[11] := S[12];
  S[12] := C;

  C := S[2];
  S[2] := S[5];
  S[5] := C;

  C := S[3];
  S[3] := S[6];
  S[6] := C;

  C := S[3];
  S[3] := S[7];
  S[7] := C;

  C := S[4];
  S[4] := S[8];
  S[8] := C;

  C := S[3];
  S[3] := S[4];
  S[4] := C;

  SerialNumber := 'HM7-' + UpperCase(Copy(S, 1, 6) + '-' + Copy(S, 7, 4) + '-' +
                  Copy(S, 11, 6));

  // Calculate activation code /////////////////////////////////////////////////

  Value1 := -1;

  for I := 1 to Length(SerialNumber) do
  begin
    if SerialNumber[I] <> '-' then
    begin
      J := I * (Integer((I mod 2) = 0) and $7F);

      if J < 1 then
        J := 1;

      Inc(Value1, J * (Byte(SerialNumber[I]) - $2F));
    end;
  end;

  ActivationCode := Format('AC%.4d', [Value1]);
end;

var
  SerialNumber, ActivationCode: String;

begin
  Randomize;

  WriteLn('Help & Manual 7.x Keygen [by RadiXX11]');
  WriteLn('======================================');
  WriteLn;

  GenerateKeys(SerialNumber, ActivationCode);

  WriteLn('Serial Number..: ', SerialNumber);
  WriteLn('Activation Code: ', ActivationCode);

  ReadLn;
end.
