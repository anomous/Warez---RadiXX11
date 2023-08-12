unit Licensing;

interface

function GenerateLicenseCode: String;

implementation

uses
  SysUtils;

function GenerateLicenseCode: String;
var
  Key: array[0..9] of Byte;
  I: Integer;
  W1, W2, W3, W4, W5: Word;
begin
  Result := '';

  repeat
    for I := 0 to 9 do
      Key[I] := Random(256);

    W5 := (Key[8] shl 8) or Key[9];
    W4 := (((Key[6] shl 8) or Key[7]) xor W5) xor $41B7;
    W3 := (((Key[4] shl 8) or Key[5]) xor W5) xor $41B7;
    W2 := (((Key[2] shl 8) or Key[3]) xor W5) xor $41B7;
    W1 := (((Key[0] shl 8) or Key[1]) xor W5) xor $41B7;
    I := W1 and $FF;
    I := (((I * $2000) and $FFFF) + (I shr 3) + (W1 shr 8)) and $FFFF;
    I := (((I * $2000) and $FFFF) + (I shr 3) + (W2 and $FF)) and $FFFF;
    I := (((I * $2000) and $FFFF) + (I shr 3) + (W2 shr 8)) and $FFFF;
    I := (((I * $2000) and $FFFF) + (I shr 3) + (W3 and $FF)) and $FFFF;
    I := (((I * $2000) and $FFFF) + (I shr 3) + (W3 shr 8)) and $FFFF;
    I := (((I * $2000) and $FFFF) + (I shr 3) + (W4 and $FF)) and $FFFF;
    I := (((I * $2000) and $FFFF) + (I shr 3) + (W4 shr 8)) and $FFFF;

  until I = W5;

  for I := 0 to 9 do
  begin
    Result := Result + IntToHex(Key[I], 2);

    if (((I + 1) mod 2) = 0) and (I < 9) then
      Result := Result + '-';
  end;
end;

end.
