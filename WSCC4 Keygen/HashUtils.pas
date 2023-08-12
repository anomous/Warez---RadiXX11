unit HashUtils;

interface

{$I Compiler.inc}

type
  T512BitBuf = array[0..63] of Byte;
  T1024BitBuf = array[0..127] of Byte;

  PWord64 = ^Word64;
  Word64 = packed record
    case Integer of
    0 : (Bytes: array[0..7] of Byte);
    1 : (Words: array[0..3] of Word);
    2 : (LongWords: array[0..1] of LongWord);
  end;  

function DigestToString(const Digest; Size: Integer; UpperCase: Boolean): String;
procedure ReverseMem(var Buf; const BufSize: Integer);
function RotateLeftBits(const Value: LongWord; const Bits: Byte): LongWord;
function RotateRightBits(const Value: LongWord; const Bits: Byte): LongWord;
procedure SecureClear(var Buf; const BufSize: Integer);
procedure SecureClear512(var Buf: T512BitBuf);
procedure SecureClear1024(var Buf: T1024BitBuf);
procedure StdFinalBuf512(const Buf; const BufSize: Integer;
  const TotalSize: Int64; var Buf1, Buf2: T512BitBuf; var FinalBufs: Integer;
  const SwapEndian: Boolean);
procedure StdFinalBuf1024(const Buf; const BufSize: Integer;
  const TotalSize: Int64; var Buf1, Buf2: T1024BitBuf; var FinalBufs: Integer;
  const SwapEndian: Boolean);
function SwapEndian(const Value: LongWord): LongWord;
procedure SwapEndianBuf(var Buf; const Count: Integer);
procedure SwapEndianBuf64(var Buf; const Count: Integer);
procedure Word64AddWord64(var A: Word64; const B: Word64);
procedure Word64AndWord64(var A: Word64; const B: Word64);
procedure Word64InitZero(var A: Word64);
procedure Word64Not(var A: Word64);
procedure Word64Ror(var A: Word64; const B: Byte);
procedure Word64Shr(var A: Word64; const B: Byte);
procedure Word64SwapEndian(var A: Word64);
procedure Word64XorWord64(var A: Word64; const B: Word64);

implementation

function DigestToString(const Digest; Size: Integer; UpperCase: Boolean): String;
const
  Digits: array[0..15] of Char = '0123456789abcdef';
var
  Buf, P1, P2: PChar;
  I: Integer;
begin
  try
    GetMem(Buf, Size * 2);

    try
      P1 := @Digest;
      P2 := Buf;

      for I := 0 to Size - 1 do
      begin
        P2^ := Digits[Byte(P1[I]) shr 4];

        if UpperCase then
          P2^ := UpCase(P2^);

        Inc(P2);

        P2^ := Digits[Byte(P1[I]) and 15];

        if UpperCase then
          P2^ := UpCase(P2^);

        Inc(P2);
      end;

      SetString(Result, Buf, Size * 2);

    finally
      FreeMem(Buf);
    end;

  except
    Result := '';
  end;
end;

procedure ReverseMem(var Buf; const BufSize: Integer);
var I : Integer;
    P : PByte;
    Q : PByte;
    T : Byte;
begin
  P := @Buf;
  Q := P;
  Inc(Q, BufSize - 1);
  for I := 1 to BufSize div 2 do
    begin
      T := P^;
      P^ := Q^;
      Q^ := T;
      Inc(P);
      Dec(Q);
    end;
end;

function RotateLeftBits(const Value: LongWord; const Bits: Byte): LongWord;
var I : Integer;
    R : LongWord;
begin
  R := Value;
  for I := 1 to Bits do
    if R and $80000000 = 0 then
      R := LongWord(R shl 1)
    else
      R := LongWord(R shl 1) or 1;
  Result := R;
end;

function RotateRightBits(const Value: LongWord; const Bits: Byte): LongWord;
var I, B : Integer;
begin
  Result := Value;
  if Bits >= 32 then
    B := Bits mod 32
  else
    B := Bits;
  for I := 1 to B do
    if Result and 1 = 0 then
      Result := Result shr 1
    else
      Result := (Result shr 1) or $80000000;
end;

procedure SecureClear(var Buf; const BufSize: Integer);
begin
  if BufSize <= 0 then
    exit;
  FillChar(Buf, BufSize, #$00);
end;

procedure SecureClear512(var Buf: T512BitBuf);
begin
  SecureClear(Buf, SizeOf(Buf));
end;

procedure SecureClear1024(var Buf: T1024BitBuf);
begin
  SecureClear(Buf, SizeOf(Buf));
end;

procedure StdFinalBuf512(
          const Buf; const BufSize: Integer; const TotalSize: Int64;
          var Buf1, Buf2: T512BitBuf;
          var FinalBufs: Integer;
          const SwapEndian: Boolean);
var P, Q : PByte;
    I : Integer;
    L : Int64;
begin
  Assert(BufSize < 64, 'Final BufSize must be less than 64 bytes');
  Assert(TotalSize >= BufSize, 'TotalSize >= BufSize');

  P := @Buf;
  Q := @Buf1[0];
  if BufSize > 0 then
    begin
      Move(P^, Q^, BufSize);
      Inc(Q, BufSize);
    end;
  Q^ := $80;
  Inc(Q);

  {$IFDEF DELPHI5}
  // Delphi 5 sometimes reports fatal error (internal error C1093) when compiling:
  //   L := TotalSize * 8
  L := TotalSize;
  L := L * 8;
  {$ELSE}
  L := TotalSize * 8;
  {$ENDIF}
  if SwapEndian then
    ReverseMem(L, 8);
  if BufSize + 1 > 64 - Sizeof(Int64) then
    begin
      FillChar(Q^, 64 - BufSize - 1, #0);
      Q := @Buf2[0];
      FillChar(Q^, 64 - Sizeof(Int64), #0);
      Inc(Q, 64 - Sizeof(Int64));
      PInt64(Q)^ := L;
      FinalBufs := 2;
    end
  else
    begin
      I := 64 - Sizeof(Int64) - BufSize - 1;
      FillChar(Q^, I, #0);
      Inc(Q, I);
      PInt64(Q)^ := L;
      FinalBufs := 1;
    end;
end;

procedure StdFinalBuf1024(
          const Buf; const BufSize: Integer; const TotalSize: Int64;
          var Buf1, Buf2: T1024BitBuf;
          var FinalBufs: Integer;
          const SwapEndian: Boolean);
var P, Q : PByte;
    I : Integer;
    L : Int64;
begin
  Assert(BufSize < 128, 'Final BufSize must be less than 128 bytes');
  Assert(TotalSize >= BufSize, 'TotalSize >= BufSize');

  P := @Buf;
  Q := @Buf1[0];
  if BufSize > 0 then
    begin
      Move(P^, Q^, BufSize);
      Inc(Q, BufSize);
    end;
  Q^ := $80;
  Inc(Q);

  {$IFDEF DELPHI5}
  // Delphi 5 sometimes reports fatal error (internal error C1093) when compiling:
  //   L := TotalSize * 8
  L := TotalSize;
  L := L * 8;
  {$ELSE}
  L := TotalSize * 8;
  {$ENDIF}
  if SwapEndian then
    ReverseMem(L, 8);
  if BufSize + 1 > 128 - Sizeof(Int64) * 2 then
    begin
      FillChar(Q^, 128 - BufSize - 1, #0);
      Q := @Buf2[0];
      FillChar(Q^, 128 - Sizeof(Int64) * 2, #0);
      Inc(Q, 128 - Sizeof(Int64) * 2);
      PInt64(Q)^ := 0;
      Inc(Q, 8);
      PInt64(Q)^ := L;
      FinalBufs := 2;
    end
  else
    begin
      I := 128 - Sizeof(Int64) * 2 - BufSize - 1;
      FillChar(Q^, I, #0);
      Inc(Q, I);
      PInt64(Q)^ := 0;
      Inc(Q, 8);
      PInt64(Q)^ := L;
      FinalBufs := 1;
    end;
end;

function SwapEndian(const Value: LongWord): LongWord;
begin
  Result := ((Value and $000000FF) shl 24)  or
            ((Value and $0000FF00) shl 8)   or
            ((Value and $00FF0000) shr 8)   or
            ((Value and $FF000000) shr 24);
end;

procedure SwapEndianBuf(var Buf; const Count: Integer);
var P : PLongWord;
    I : Integer;
begin
  P := @Buf;
  for I := 1 to Count do
    begin
      P^ := SwapEndian(P^);
      Inc(P);
    end;
end;

procedure SwapEndianBuf64(var Buf; const Count: Integer);
var P : PWord64;
    I : Integer;
begin
  P := @Buf;
  for I := 1 to Count do
    begin
      Word64SwapEndian(P^);
      Inc(P);
    end;
end;

procedure Word64AddWord64(var A: Word64; const B: Word64);
var C, D : Int64;
begin
  C := Int64(A.LongWords[0]) + B.LongWords[0];
  D := Int64(A.LongWords[1]) + B.LongWords[1];
  if C >= $100000000 then
    Inc(D);
  A.LongWords[0] := C and $FFFFFFFF;
  A.LongWords[1] := D and $FFFFFFFF;
end;

procedure Word64AndWord64(var A: Word64; const B: Word64);
begin
  A.LongWords[0] := A.LongWords[0] and B.LongWords[0];
  A.LongWords[1] := A.LongWords[1] and B.LongWords[1];
end;

procedure Word64InitZero(var A: Word64);
begin
  A.LongWords[0] := 0;
  A.LongWords[1] := 0;
end;

procedure Word64Not(var A: Word64);
begin
  A.LongWords[0] := not A.LongWords[0];
  A.LongWords[1] := not A.LongWords[1];
end;

procedure Word64Ror(var A: Word64; const B: Byte);
var C, D : Byte;
    E, F : LongWord;
begin
  C := B mod 64;
  if C = 0 then
    exit;
  if C < 32 then
    begin
      D := 32 - C;
      E := (A.LongWords[1] shr C) or (A.LongWords[0] shl D);
      F := (A.LongWords[0] shr C) or (A.LongWords[1] shl D);
    end
  else
    begin
      Dec(C, 32);
      D := 32 - C;
      E := (A.LongWords[0] shr C) or (A.LongWords[1] shl D);
      F := (A.LongWords[1] shr C) or (A.LongWords[0] shl D);
    end;
  A.LongWords[1] := E;
  A.LongWords[0] := F;
end;

procedure Word64Shr(var A: Word64; const B: Byte);
var C : Byte;
begin
  if B = 0 then
    exit;
  if B >= 64 then
    Word64InitZero(A) else
  if B < 32 then
    begin
      C := 32 - B;
      A.LongWords[0] := (A.LongWords[0] shr B) or (A.LongWords[1] shl C);
      A.LongWords[1] := A.LongWords[1] shr B;
    end
  else
    begin
      C := B - 32;
      A.LongWords[0] := A.LongWords[1] shr C;
      A.LongWords[1] := 0;
    end;
end;

procedure Word64SwapEndian(var A: Word64);
var B : Word64;
    I : Integer;
begin
  B := A;
  for I := 0 to 7 do
    A.Bytes[I] := B.Bytes[7 - I];
end;

procedure Word64XorWord64(var A: Word64; const B: Word64);
begin
  A.LongWords[0] := A.LongWords[0] xor B.LongWords[0];
  A.LongWords[1] := A.LongWords[1] xor B.LongWords[1];
end;

end.
