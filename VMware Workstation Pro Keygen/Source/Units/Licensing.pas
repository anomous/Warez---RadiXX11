unit Licensing;

interface

type
  TVersionInfo = record
    Version: String;
    Data: PChar;
  end;

const
  VersionList: array[0..1] of TVersionInfo = (
    (
      Version: '15.x';
      Data: 'd70b6267-8ddb050c-4eec50c6-e65ba629-814e2b34';
    ),
    (
      Version: '14.x';
      Data: 'd50f6dba-9ee0e397-e472debb-7ec48007-36f16c7f';
    )
  );

function GenerateLicenseKey(const VersionInfo: TVersionInfo): String;

implementation

uses
  SHA1;

//------------------------------------------------------------------------------

procedure BitReset(const BitStr: PChar; Bit: LongWord);
asm
  btr  [eax], edx
end;

//------------------------------------------------------------------------------

procedure BitSet(const BitStr: PChar; Bit: LongWord);
asm
  bts  [eax], edx
end;

//------------------------------------------------------------------------------

function BitTest(const BitStr: PChar; Bit: LongWord): Boolean;
asm
  bt   [eax], edx
  setc al
end;

//------------------------------------------------------------------------------

procedure Encode1(const Buffer: PChar; Value, Bit: LongWord; Count: Integer);
var
  I: Integer;
begin
  for I := Count - 1 downto 0 do
  begin
    if ((Value shr I) and 1) <> 0 then
      BitSet(Buffer, Bit);

    Dec(Bit);
  end;
end;

//------------------------------------------------------------------------------

procedure Encode2(const Buffer1, Buffer2: PChar);
var
  I, J, K, L, M: LongWord;
  BitOn: Boolean;
begin
  M := 0;
  L := 40;
  K := 80;
  J := 0;

  for I := 0 to 104 do
  begin
    if ((J mod 3) <> 0) and (J <> 20) then
    begin
      if ((J and 1) <> 1) and (J <> 16) then
      begin
        BitOn := BitTest(Buffer1, K);
        Inc(K);
      end
      else
      begin
        BitOn := BitTest(Buffer1, L);
        Inc(L);
      end;
    end
    else
    begin
      BitOn := BitTest(Buffer1, M);
      Inc(M);
    end;

    if BitOn then
      BitSet(Buffer2, I)
    else
      BitReset(Buffer2, I);

    Inc(J);

    if J = 21 then
      J := 0;
  end;

  for I := 105 to 124 do
  begin
    if BitTest(Buffer1, I) then
      BitSet(Buffer2, I)
    else
      BitReset(Buffer2, I);
  end;
end;

//------------------------------------------------------------------------------

function Encode3(Buffer: PChar): String;
const
  CharIndex: array[0..24] of Byte = (
    6, 3, 12, 19, 20, 15, 23, 8, 13, 14, 21, 22, 16, 24, 4, 25, 5, 7, 2, 9, 10,
    1, 17, 11, 18
  );
  Charset: PChar = '0123456789ACDEFGHJKLMNPQRTUVWXYZ';
var
  Key: String;
  I: Integer;
begin
  SetLength(Key, 25);
  I := 1;

  while True do
  begin
    Key[I] := Charset[Byte(Buffer[0]) and $1F];
    Inc(I);

    if I > 25 then Break;

    Key[I] := Charset[((Byte(Buffer[0]) shr 5) or 8 * Byte(Buffer[1])) and $1F];
    Inc(I);

    if I > 25 then Break;

    Key[I] := Charset[(Byte(Buffer[1]) shr 2) and $1F];
    Inc(I);

    if I > 25 then Break;

    Key[I] := Charset[((Byte(Buffer[1]) shr 7) or 2 * Byte(Buffer[2])) and $1F];
    Inc(I);

    if I > 25 then Break;

    Key[I] := Charset[((Byte(Buffer[2]) shr 4) or (Byte(Buffer[3]) shl 4)) and $1F];
    Inc(I);

    if I > 25 then Break;

    Key[I] := Charset[(Byte(Buffer[3]) shr 1) and $1F];
    Inc(I);

    if I > 25 then Break;

    Key[I] := Charset[((Byte(Buffer[3]) shr 6) or 4 * Byte(Buffer[4])) and $1F];
    Inc(I);

    if I > 25 then Break;

    Key[I] := Charset[(Byte(Buffer[4]) shr 3) and $1F];
    Inc(I);

    if I > 25 then Break;

    Inc(Buffer, 5);
  end;

  SetLength(Result, 25);

  for I := 1 to 25 do
    Result[I] := Key[CharIndex[I - 1]];

  Insert('-', Result, 6);
  Insert('-', Result, 12);
  Insert('-', Result, 18);
  Insert('-', Result, 24);
end;

//------------------------------------------------------------------------------

function GenerateLicenseKey(const VersionInfo: TVersionInfo): String;
const
  Data: array[0..31] of Byte = (
    $7D, $C7, $89, $F9, $69, $5D, $71, $90, $FA, $84, $22, $CA, $BF, $1D, $C0,
    $C0, $88, $42, $37, $D5, $70, $80, $2E, $83, $C7, $92, $A3, $59, $C6, $95,
    $24, $BF
  );
var
  Digest: TSHA1Digest;
  Buffer1: array[0..91] of Char;
  Buffer2: array[0..15] of Char;
  Value: LongWord;
begin
  // Initialization
  FillChar(Buffer1, SizeOf(Buffer1), 0);
  FillChar(Buffer2, SizeOf(Buffer2), 0);

  // Encode initial bytes into Buffer1
  Encode1(Buffer1, Random($7FFF), $7C, $0F);
  Encode1(Buffer1, $08, $6D, $05);
  Encode1(Buffer1, Random($01FFFFFF), $68, $19);
  Encode1(Buffer1, $00, $4F, $0C);
  Encode1(Buffer1, $00, $43, $02);
  Encode1(Buffer1, $00, $41, $03);
  Encode1(Buffer1, $00, $3E, $02);
  Encode1(Buffer1, $FFFF, $3C, $10);
  Encode1(Buffer1, $1F, $2C, $05);

  // Append Data1 and Data2 bytes after first 16 bytes in Buffer1
  Move(VersionInfo.Data^, Buffer1[16], 44);
  Move(Data, Buffer1[60], 32);

  // Calculate SHA1 hash of the last 87 bytes in Buffer1
  Digest := SHA1FromBuffer(Buffer1[5], 87);

  // Encode digest bytes and store result into the first 5 bytes of Buffer1
  Value := (Digest.Bytes[18] xor Digest.Bytes[13] xor Digest.Bytes[8] xor Digest.Bytes[3]) shl 8;
  Value := (Value or Byte(Digest.Bytes[17] xor Digest.Bytes[12] xor Digest.Bytes[7] xor Digest.Bytes[2])) shl 8;
  Value := (Value or Byte(Digest.Bytes[16] xor Digest.Bytes[11] xor Digest.Bytes[6] xor Digest.Bytes[1])) shl 8;
  Value := Value or Byte(Digest.Bytes[15] xor Digest.Bytes[10] xor Digest.Bytes[5] xor Digest.Bytes[0]);
  PLongWord(@Buffer1[0])^ := Value;
  Buffer1[4] := Char(Digest.Bytes[19] xor Digest.Bytes[14] xor Digest.Bytes[9] xor Digest.Bytes[4]);

  // Encode Buffer1 into Buffer2
  Encode2(Buffer1, Buffer2);

  // Encode Buffer2 bytes into the final key
  Result := Encode3(Buffer2);
end;

end.
