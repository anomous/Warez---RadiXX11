unit Licensing;

interface

function GenerateKey: String;

implementation

uses
  SysUtils;

//------------------------------------------------------------------------------

type
  TTEAKey = array[0..3] of LongWord;
  TTEAData = array[0..1] of LongWord;

//------------------------------------------------------------------------------

function SwapLongWord(Value: LongWord): LongWord;
asm
  bswap eax
end;

//------------------------------------------------------------------------------

procedure TEA_Init(var Key: TTEAKey);
begin
  Key[0] := SwapLongWord(Key[0]);
  Key[1] := SwapLongWord(Key[1]);
  Key[2] := SwapLongWord(Key[2]);
  Key[3] := SwapLongWord(Key[3]);
end;

//------------------------------------------------------------------------------

procedure TEA_Encrypt(var Key: TTEAKey; var Data: TTEAData);
var
  X, Y, N, Sum: LongWord;
begin
  X := SwapLongWord(Data[0]);
  Y := SwapLongWord(Data[1]);
  Sum := 0;

  for N := 1 to 32 do
  begin
    Inc(Sum, $9E3779B9);
    Inc(X, (((Y shr 5) + Key[1]) xor (Sum + Y) xor (Y shl 4 + Key[0])));
    Inc(Y, (((X shr 5) + Key[3]) xor (Sum + X) xor (X shl 4 + Key[2])));
  end;

  Data[0] := SwapLongWord(X);
  Data[1] := SwapLongWord(Y);
end;

//------------------------------------------------------------------------------

procedure TEA_Burn(var Key: TTEAKey);
begin
  FillChar(Key, SizeOf(Key), 0);
end;

//------------------------------------------------------------------------------

function GenerateKey: String;
const
  Password: TTEAKey = ($C51D2C04, $11D9A700, $13CD0602, $83FF1005);
var
  Key: TTEAKey;
  Data: TTEAData;
  S1, S2: String;
  I, RndValue: LongWord;
  Value: Byte;
begin
  RndValue := (Random($10000) shl 16) or $8C20;
  Value := 0;

  for I := 0 to 3 do
    Inc(Value, RndValue shr (I shl 3));

  Data[0] := SwapLongWord((Byte($FF - Value - 3) shl 24) + 3);
  Data[1] := SwapLongWord(RndValue);

  Move(Password, Key, sizeof(Password));

  TEA_Init(Key);
  TEA_Encrypt(Key, Data);
  TEA_Burn(Key);

  S1 := IntToStr(SwapLongWord(Data[0]));
  S2 := IntToStr(SwapLongWord(Data[1]));

  Result := StringOfChar('0', 10 - Length(S1)) + S1 +
            StringOfChar('0', 10 - Length(S2)) + S2;

  Insert('-', Result, 4);
  Insert('-', Result, 12);
  Insert('-', Result, 19);
end;

end.
