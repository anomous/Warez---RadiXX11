unit CRC16;

interface

function CRC16FromData(Buffer: Pointer; Len: LongInt): Word;
function CRC16FromString(const S: String): Word;
function CRC16ToString(CRC: Word; UpperCase: Boolean = False): String;

implementation

//------------------------------------------------------------------------------

var
  CRCTable: array[0..255] of Word;

//------------------------------------------------------------------------------

procedure GenerateCRCTable;
var
  I, J: Integer;
  K: Word;
begin
  FillChar(CRCTable, SizeOf(CRCTable), 0);

  for I := 0 to 255 do
  begin
    K := $C0C1;
    J := 1;
    repeat
      if (I and J) <> 0 then
        CRCTable[I] := CRCTable[I] xor K;
      J := J * 2;
      K := 2 * K xor $4003;
    until J >= 256;
  end;
end;

//------------------------------------------------------------------------------

function CRC16FromData(Buffer: Pointer; Len: LongInt): Word;
var
  I: Integer;
begin
	Result := 0;

  for I := 0 to Len - 1 do
    Result := (Result shr 8) xor CRCTable[Lo(Result xor Ord(PChar(Buffer)[I]))];
end;

//------------------------------------------------------------------------------

function CRC16FromString(const S: String): Word;
begin
  Result := CRC16FromData(PChar(S), Length(S));
end;

//------------------------------------------------------------------------------

function CRC16ToString(CRC: Word; UpperCase: Boolean): String;
const
  Digits: array[0..15] of Char = '0123456789abcdef';
var
  Buf: array[0..(SizeOf(CRC) * 2) - 1] of Char;
  P: PChar;
  I: Integer;
begin
  P := @Buf;

  for I := SizeOf(CRC) - 1 downto 0 do
  begin
    P^ := Digits[Byte(PChar(@CRC)[I]) shr 4];

    if UpperCase then
      P^ := UpCase(P^);

    Inc(P);

    P^ := Digits[Byte(PChar(@CRC)[I]) and 15];

    if UpperCase then
      P^ := UpCase(P^);

    Inc(P);
  end;

  SetString(Result, Buf, SizeOf(Buf));
end;

initialization
  GenerateCRCTable;

end.
 