unit MD5;

interface

type
  P128BitDigest = ^TMD5Digest;
  TMD5Digest = record
    case integer of
      0 : (Int64s: array[0..1] of Int64);
      1 : (Longs: array[0..3] of LongWord);
      2 : (Words: array[0..7] of Word);
      3 : (Bytes: array[0..15] of Byte);
    end;

procedure MD5Final(var Digest: TMD5Digest; const Buf; const BufSize: Integer;
  const TotalSize: Int64);
procedure MD5Init(var Digest: TMD5Digest);
procedure MD5Update(var Digest: TMD5Digest; const Buf; const BufSize: Integer);

function MD5FromBuffer(const Buf; const BufSize: Integer): TMD5Digest;
function MD5FromString(const S: String): TMD5Digest;
function MD5IsEqual(const Digest1, Digest2: TMD5Digest): Boolean;
function MD5ToString(const Digest: TMD5Digest; UpperCase: Boolean = False): String;

implementation

uses
  HashUtils,
  SysUtils;

const
  MD5Table_1 : array[0..15] of LongWord = (
      $D76AA478, $E8C7B756, $242070DB, $C1BDCEEE,
      $F57C0FAF, $4787C62A, $A8304613, $FD469501,
      $698098D8, $8B44F7AF, $FFFF5BB1, $895CD7BE,
      $6B901122, $FD987193, $A679438E, $49B40821);
  MD5Table_2 : array[0..15] of LongWord = (
      $F61E2562, $C040B340, $265E5A51, $E9B6C7AA,
      $D62F105D, $02441453, $D8A1E681, $E7D3FBC8,
      $21E1CDE6, $C33707D6, $F4D50D87, $455A14ED,
      $A9E3E905, $FCEFA3F8, $676F02D9, $8D2A4C8A);
  MD5Table_3 : array[0..15] of LongWord = (
      $FFFA3942, $8771F681, $6D9D6122, $FDE5380C,
      $A4BEEA44, $4BDECFA9, $F6BB4B60, $BEBFBC70,
      $289B7EC6, $EAA127FA, $D4EF3085, $04881D05,
      $D9D4D039, $E6DB99E5, $1FA27CF8, $C4AC5665);
  MD5Table_4 : array[0..15] of LongWord = (
      $F4292244, $432AFF97, $AB9423A7, $FC93A039,
      $655B59C3, $8F0CCC92, $FFEFF47D, $85845DD1,
      $6FA87E4F, $FE2CE6E0, $A3014314, $4E0811A1,
      $F7537E82, $BD3AF235, $2AD7D2BB, $EB86D391);

{ Calculates a MD5 Digest (16 bytes) given a Buffer (64 bytes)                 }
{$IFOPT Q+}{$DEFINE QOn}{$Q-}{$ELSE}{$UNDEF QOn}{$ENDIF}
procedure TransformMD5Buffer(var Digest: TMD5Digest; const Buffer);
var A, B, C, D : LongWord;
    P          : PLongWord;
    I          : Integer;
    J          : Byte;
    Buf        : array[0..15] of LongWord absolute Buffer;
begin
  A := Digest.Longs[0];
  B := Digest.Longs[1];
  C := Digest.Longs[2];
  D := Digest.Longs[3];

  P := @MD5Table_1;
  for I := 0 to 3 do
    begin
      J := I * 4;
      Inc(A, Buf[J]     + P^ + (D xor (B and (C xor D)))); A := A shl  7 or A shr 25 + B; Inc(P);
      Inc(D, Buf[J + 1] + P^ + (C xor (A and (B xor C)))); D := D shl 12 or D shr 20 + A; Inc(P);
      Inc(C, Buf[J + 2] + P^ + (B xor (D and (A xor B)))); C := C shl 17 or C shr 15 + D; Inc(P);
      Inc(B, Buf[J + 3] + P^ + (A xor (C and (D xor A)))); B := B shl 22 or B shr 10 + C; Inc(P);
    end;

  P := @MD5Table_2;
  for I := 0 to 3 do
    begin
      J := I * 4;
      Inc(A, Buf[J + 1]           + P^ + (C xor (D and (B xor C)))); A := A shl  5 or A shr 27 + B; Inc(P);
      Inc(D, Buf[(J + 6) mod 16]  + P^ + (B xor (C and (A xor B)))); D := D shl  9 or D shr 23 + A; Inc(P);
      Inc(C, Buf[(J + 11) mod 16] + P^ + (A xor (B and (D xor A)))); C := C shl 14 or C shr 18 + D; Inc(P);
      Inc(B, Buf[J]               + P^ + (D xor (A and (C xor D)))); B := B shl 20 or B shr 12 + C; Inc(P);
    end;

  P := @MD5Table_3;
  for I := 0 to 3 do
    begin
      J := 16 - (I * 4);
      Inc(A, Buf[(J + 5) mod 16]  + P^ + (B xor C xor D)); A := A shl  4 or A shr 28 + B; Inc(P);
      Inc(D, Buf[(J + 8) mod 16]  + P^ + (A xor B xor C)); D := D shl 11 or D shr 21 + A; Inc(P);
      Inc(C, Buf[(J + 11) mod 16] + P^ + (D xor A xor B)); C := C shl 16 or C shr 16 + D; Inc(P);
      Inc(B, Buf[(J + 14) mod 16] + P^ + (C xor D xor A)); B := B shl 23 or B shr  9 + C; Inc(P);
    end;

  P := @MD5Table_4;
  for I := 0 to 3 do
    begin
      J := 16 - (I * 4);
      Inc(A, Buf[J mod 16]        + P^ + (C xor (B or not D))); A := A shl  6 or A shr 26 + B; Inc(P);
      Inc(D, Buf[(J + 7) mod 16]  + P^ + (B xor (A or not C))); D := D shl 10 or D shr 22 + A; Inc(P);
      Inc(C, Buf[(J + 14) mod 16] + P^ + (A xor (D or not B))); C := C shl 15 or C shr 17 + D; Inc(P);
      Inc(B, Buf[(J + 5) mod 16]  + P^ + (D xor (C or not A))); B := B shl 21 or B shr 11 + C; Inc(P);
    end;

  Inc(Digest.Longs[0], A);
  Inc(Digest.Longs[1], B);
  Inc(Digest.Longs[2], C);
  Inc(Digest.Longs[3], D);
end;
{$IFDEF QOn}{$Q+}{$ENDIF}

procedure MD5Init(var Digest: TMD5Digest);
begin
  Digest.Longs[0] := $67452301;  
  Digest.Longs[1] := $EFCDAB89;
  Digest.Longs[2] := $98BADCFE;
  Digest.Longs[3] := $10325476;
end;

procedure MD5Update(var Digest: TMD5Digest; const Buf; const BufSize: Integer);
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
      TransformMD5Buffer(Digest, P^);
      Inc(P, 64);
    end;
end;

procedure MD5Final(var Digest: TMD5Digest; const Buf; const BufSize: Integer;
  const TotalSize: Int64);
var B1, B2 : T512BitBuf;
    C : Integer;
begin
  StdFinalBuf512(Buf, BufSize, TotalSize, B1, B2, C, False);
  TransformMD5Buffer(Digest, B1);
  if C > 1 then
    TransformMD5Buffer(Digest, B2);
  SecureClear512(B1);
  if C > 1 then
    SecureClear512(B2);
end;

function MD5FromBuffer(const Buf; const BufSize: Integer): TMD5Digest;
var I, J : Integer;
    P    : PByte;
begin
  MD5Init(Result);
  P := @Buf;
  if BufSize <= 0 then
    I := 0 else
    I := BufSize;
  J := (I div 64) * 64;
  if J > 0 then
    begin
      MD5Update(Result, P^, J);
      Inc(P, J);
      Dec(I, J);
    end;
  MD5Final(Result, P^, I, BufSize);
end;

function MD5FromString(const S: String): TMD5Digest;
begin
  Result := MD5FromBuffer(Pointer(S)^, Length(S));
end;

function MD5IsEqual(const Digest1, Digest2: TMD5Digest): Boolean;
begin
  Result := CompareMem(@Digest1, @Digest2, SizeOf(TMD5Digest));
end;

function MD5ToString(const Digest: TMD5Digest; UpperCase: Boolean): String;
begin
  Result := DigestToString(Digest, Sizeof(Digest), UpperCase);
end;

end.
