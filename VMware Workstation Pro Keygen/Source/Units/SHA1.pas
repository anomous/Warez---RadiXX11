unit SHA1;

interface

type
  PSHA1Digest = ^TSHA1Digest;
  TSHA1Digest = record
    case Integer of
      0 : (Longs: array[0..4] of LongWord);
      1 : (Words: array[0..9] of Word);
      2 : (Bytes: array[0..19] of Byte);
    end;

procedure SHA1Init(var Digest: TSHA1Digest);
procedure SHA1Update(var Digest: TSHA1Digest; const Buf; const BufSize: Integer);
procedure SHA1Final(var Digest: TSHA1Digest; const Buf; const BufSize: Integer;
  const TotalSize: Int64);

function SHA1FromBuffer(const Buf; const BufSize: Integer): TSHA1Digest;
function SHA1FromString(const S: String): TSHA1Digest;
function SHA1IsEqual(const Digest1, Digest2: TSHA1Digest): Boolean;
function SHA1ToString(const Digest: TSHA1Digest; UpperCase: Boolean = False): String;

implementation

uses
  HashUtils,
  SysUtils;

procedure SHA1Init(var Digest: TSHA1Digest);
begin
  Digest.Longs[0] := $67452301;
  Digest.Longs[1] := $EFCDAB89;
  Digest.Longs[2] := $98BADCFE;
  Digest.Longs[3] := $10325476;
  Digest.Longs[4] := $C3D2E1F0;
end;

{ Calculates a SHA Digest (20 bytes) given a Buffer (64 bytes)                 }
{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}
procedure TransformSHABuffer(var Digest: TSHA1Digest; const Buffer; const SHA1: Boolean);
var A, B, C, D, E : LongWord;
    W : array[0..79] of LongWord;
    P, Q : PLongWord;
    I : Integer;
    J : LongWord;
begin
  P := @Buffer;
  Q := @W;
  for I := 0 to 15 do
    begin
      Q^ := SwapEndian(P^);
      Inc(P);
      Inc(Q);
    end;
  for I := 0 to 63 do
    begin
      P := Q;
      Dec(P, 16);
      J := P^;
      Inc(P, 2);
      J := J xor P^;
      Inc(P, 6);
      J := J xor P^;
      Inc(P, 5);
      J := J xor P^;
      if SHA1 then
        J := RotateLeftBits(J, 1);
      Q^ := J;
      Inc(Q);
    end;

  A := Digest.Longs[0];
  B := Digest.Longs[1];
  C := Digest.Longs[2];
  D := Digest.Longs[3];
  E := Digest.Longs[4];

  P := @W;
  for I := 0 to 3 do
    begin
      Inc(E, (A shl 5 or A shr 27) + (D xor (B and (C xor D))) + P^ + $5A827999); B := B shr 2 or B shl 30; Inc(P);
      Inc(D, (E shl 5 or E shr 27) + (C xor (A and (B xor C))) + P^ + $5A827999); A := A shr 2 or A shl 30; Inc(P);
      Inc(C, (D shl 5 or D shr 27) + (B xor (E and (A xor B))) + P^ + $5A827999); E := E shr 2 or E shl 30; Inc(P);
      Inc(B, (C shl 5 or C shr 27) + (A xor (D and (E xor A))) + P^ + $5A827999); D := D shr 2 or D shl 30; Inc(P);
      Inc(A, (B shl 5 or B shr 27) + (E xor (C and (D xor E))) + P^ + $5A827999); C := C shr 2 or C shl 30; Inc(P);
    end;

  for I := 0 to 3 do
    begin
      Inc(E, (A shl 5 or A shr 27) + (D xor B xor C) + P^ + $6ED9EBA1); B := B shr 2 or B shl 30; Inc(P);
      Inc(D, (E shl 5 or E shr 27) + (C xor A xor B) + P^ + $6ED9EBA1); A := A shr 2 or A shl 30; Inc(P);
      Inc(C, (D shl 5 or D shr 27) + (B xor E xor A) + P^ + $6ED9EBA1); E := E shr 2 or E shl 30; Inc(P);
      Inc(B, (C shl 5 or C shr 27) + (A xor D xor E) + P^ + $6ED9EBA1); D := D shr 2 or D shl 30; Inc(P);
      Inc(A, (B shl 5 or B shr 27) + (E xor C xor D) + P^ + $6ED9EBA1); C := C shr 2 or C shl 30; Inc(P);
    end;

  for I := 0 to 3 do
    begin
      Inc(E, (A shl 5 or A shr 27) + ((B and C) or (D and (B or C))) + P^ + $8F1BBCDC); B := B shr 2 or B shl 30; Inc(P);
      Inc(D, (E shl 5 or E shr 27) + ((A and B) or (C and (A or B))) + P^ + $8F1BBCDC); A := A shr 2 or A shl 30; Inc(P);
      Inc(C, (D shl 5 or D shr 27) + ((E and A) or (B and (E or A))) + P^ + $8F1BBCDC); E := E shr 2 or E shl 30; Inc(P);
      Inc(B, (C shl 5 or C shr 27) + ((D and E) or (A and (D or E))) + P^ + $8F1BBCDC); D := D shr 2 or D shl 30; Inc(P);
      Inc(A, (B shl 5 or B shr 27) + ((C and D) or (E and (C or D))) + P^ + $8F1BBCDC); C := C shr 2 or C shl 30; Inc(P);
    end;

  for I := 0 to 3 do
    begin
      Inc(E, (A shl 5 or A shr 27) + (D xor B xor C) + P^ + $CA62C1D6); B := B shr 2 or B shl 30; Inc(P);
      Inc(D, (E shl 5 or E shr 27) + (C xor A xor B) + P^ + $CA62C1D6); A := A shr 2 or A shl 30; Inc(P);
      Inc(C, (D shl 5 or D shr 27) + (B xor E xor A) + P^ + $CA62C1D6); E := E shr 2 or E shl 30; Inc(P);
      Inc(B, (C shl 5 or C shr 27) + (A xor D xor E) + P^ + $CA62C1D6); D := D shr 2 or D shl 30; Inc(P);
      Inc(A, (B shl 5 or B shr 27) + (E xor C xor D) + P^ + $CA62C1D6); C := C shr 2 or C shl 30; Inc(P);
    end;

  Inc(Digest.Longs[0], A);
  Inc(Digest.Longs[1], B);
  Inc(Digest.Longs[2], C);
  Inc(Digest.Longs[3], D);
  Inc(Digest.Longs[4], E);
end;
{$IFDEF QOn}{$Q+}{$ENDIF}

procedure SHA1Update(var Digest: TSHA1Digest; const Buf; const BufSize: Integer);
var P : PByte;
    I, J : Integer;
begin
  I := BufSize;
  if I <= 0 then
    exit;
  Assert(I mod 64 = 0, 'BufSize must be multiple of 64 bytes');
  P := @Buf;
  for J := 0 to I div 64 - 1 do
    begin
      TransformSHABuffer(Digest, P^, True);
      Inc(P, 64);
    end;
end;

procedure SHA1Final(var Digest: TSHA1Digest; const Buf; const BufSize: Integer;
  const TotalSize: Int64);
var B1, B2 : T512BitBuf;
    C : Integer;
begin
  StdFinalBuf512(Buf, BufSize, TotalSize, B1, B2, C, True);
  TransformSHABuffer(Digest, B1, True);
  if C > 1 then
    TransformSHABuffer(Digest, B2, True);
  SwapEndianBuf(Digest, Sizeof(Digest) div Sizeof(LongWord));
  SecureClear512(B1);
  if C > 1 then
    SecureClear512(B2);
end;

function SHA1FromBuffer(const Buf; const BufSize: Integer): TSHA1Digest;
var I, J : Integer;
    P    : PByte;
begin
  SHA1Init(Result);
  P := @Buf;
  if BufSize <= 0 then
    I := 0 else
    I := BufSize;
  J := (I div 64) * 64;
  if J > 0 then
    begin
      SHA1Update(Result, P^, J);
      Inc(P, J);
      Dec(I, J);
    end;
  SHA1Final(Result, P^, I, BufSize);
end;

function SHA1FromString(const S: String): TSHA1Digest;
begin
  Result := SHA1FromBuffer(Pointer(S)^, Length(S));
end;

function SHA1IsEqual(const Digest1, Digest2: TSHA1Digest): Boolean;
begin
  Result := CompareMem(@Digest1, @Digest2, SizeOf(TSHA1Digest));
end;

function SHA1ToString(const Digest: TSHA1Digest; UpperCase: Boolean): String;
begin
  Result := DigestToString(Digest, Sizeof(Digest), UpperCase);
end;

end.
