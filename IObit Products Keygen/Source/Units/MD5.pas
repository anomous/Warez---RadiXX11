//==============================================================================
// MD5 hashing functions
//------------------------------------------------------------------------------
// IObit Products Keygen
// © 2016, RadiXX11
//------------------------------------------------------------------------------
// DISCLAIMER
//
// This program is provided "AS IS" without any warranty, either expressed or
// implied, including, but not limited to, the implied warranties of
// merchantability and fitness for a particular purpose.
//
// This program and its source code are distributed for educational and
// practical purposes ONLY.
//
// You are not allowed to get a monetary profit of any kind through its use.
//
// The author will not take any responsibility for the consequences due to the
// improper use of this program and/or its source code.
//==============================================================================

unit MD5;

interface

type
  TMD5Buf = array[0..3] of LongWord;
  TMD5In = array[0..15] of LongWord;
  TMD5Digest = array[0..15] of Byte;

  TMD5Context = record
    buf: TMD5Buf;
    bytes: array[0..1] of LongWord;
    in_: TMD5In;
  end;

function MD5Final(var Context: TMD5Context): TMD5Digest;
function MD5FromData(Buffer: Pointer; Len: LongInt): TMD5Digest;
function MD5FromString(const S: String): TMD5Digest;
procedure MD5Init(var Context: TMD5Context);
function MD5IsEqual(const DigestA, DigestB: TMD5Digest): Boolean;
function MD5IsNull(const Digest: TMD5Digest): Boolean;
function MD5ToString(const Digest: TMD5Digest; UpperCase: Boolean = False): String;
procedure MD5Update(var Context: TMD5Context; Buffer: Pointer; Len: LongInt);

implementation

//------------------------------------------------------------------------------

procedure MD5Transform(var buf: TMD5Buf; const in_: TMD5In);
var
  a, b, c, d: LongWord;
begin
  a := buf[0];
  b := buf[1];
  c := buf[2];
  d := buf[3];

  // JR: The stuff below was generated using GenTransformCode.dpr

  Inc(a, in_[0] + $d76aa478 + (d xor (b and (c xor d))));  a := ((a shl 7) or (a shr (32-7))) + b;
  Inc(d, in_[1] + $e8c7b756 + (c xor (a and (b xor c))));  d := ((d shl 12) or (d shr (32-12))) + a;
  Inc(c, in_[2] + $242070db + (b xor (d and (a xor b))));  c := ((c shl 17) or (c shr (32-17))) + d;
  Inc(b, in_[3] + $c1bdceee + (a xor (c and (d xor a))));  b := ((b shl 22) or (b shr (32-22))) + c;
  Inc(a, in_[4] + $f57c0faf + (d xor (b and (c xor d))));  a := ((a shl 7) or (a shr (32-7))) + b;
  Inc(d, in_[5] + $4787c62a + (c xor (a and (b xor c))));  d := ((d shl 12) or (d shr (32-12))) + a;
  Inc(c, in_[6] + $a8304613 + (b xor (d and (a xor b))));  c := ((c shl 17) or (c shr (32-17))) + d;
  Inc(b, in_[7] + $fd469501 + (a xor (c and (d xor a))));  b := ((b shl 22) or (b shr (32-22))) + c;
  Inc(a, in_[8] + $698098d8 + (d xor (b and (c xor d))));  a := ((a shl 7) or (a shr (32-7))) + b;
  Inc(d, in_[9] + $8b44f7af + (c xor (a and (b xor c))));  d := ((d shl 12) or (d shr (32-12))) + a;
  Inc(c, in_[10] + $ffff5bb1 + (b xor (d and (a xor b))));  c := ((c shl 17) or (c shr (32-17))) + d;
  Inc(b, in_[11] + $895cd7be + (a xor (c and (d xor a))));  b := ((b shl 22) or (b shr (32-22))) + c;
  Inc(a, in_[12] + $6b901122 + (d xor (b and (c xor d))));  a := ((a shl 7) or (a shr (32-7))) + b;
  Inc(d, in_[13] + $fd987193 + (c xor (a and (b xor c))));  d := ((d shl 12) or (d shr (32-12))) + a;
  Inc(c, in_[14] + $a679438e + (b xor (d and (a xor b))));  c := ((c shl 17) or (c shr (32-17))) + d;
  Inc(b, in_[15] + $49b40821 + (a xor (c and (d xor a))));  b := ((b shl 22) or (b shr (32-22))) + c;

  Inc(a, in_[1] + $f61e2562 + (c xor (d and (b xor c))));  a := ((a shl 5) or (a shr (32-5))) + b;
  Inc(d, in_[6] + $c040b340 + (b xor (c and (a xor b))));  d := ((d shl 9) or (d shr (32-9))) + a;
  Inc(c, in_[11] + $265e5a51 + (a xor (b and (d xor a))));  c := ((c shl 14) or (c shr (32-14))) + d;
  Inc(b, in_[0] + $e9b6c7aa + (d xor (a and (c xor d))));  b := ((b shl 20) or (b shr (32-20))) + c;
  Inc(a, in_[5] + $d62f105d + (c xor (d and (b xor c))));  a := ((a shl 5) or (a shr (32-5))) + b;
  Inc(d, in_[10] + $02441453 + (b xor (c and (a xor b))));  d := ((d shl 9) or (d shr (32-9))) + a;
  Inc(c, in_[15] + $d8a1e681 + (a xor (b and (d xor a))));  c := ((c shl 14) or (c shr (32-14))) + d;
  Inc(b, in_[4] + $e7d3fbc8 + (d xor (a and (c xor d))));  b := ((b shl 20) or (b shr (32-20))) + c;
  Inc(a, in_[9] + $21e1cde6 + (c xor (d and (b xor c))));  a := ((a shl 5) or (a shr (32-5))) + b;
  Inc(d, in_[14] + $c33707d6 + (b xor (c and (a xor b))));  d := ((d shl 9) or (d shr (32-9))) + a;
  Inc(c, in_[3] + $f4d50d87 + (a xor (b and (d xor a))));  c := ((c shl 14) or (c shr (32-14))) + d;
  Inc(b, in_[8] + $455a14ed + (d xor (a and (c xor d))));  b := ((b shl 20) or (b shr (32-20))) + c;
  Inc(a, in_[13] + $a9e3e905 + (c xor (d and (b xor c))));  a := ((a shl 5) or (a shr (32-5))) + b;
  Inc(d, in_[2] + $fcefa3f8 + (b xor (c and (a xor b))));  d := ((d shl 9) or (d shr (32-9))) + a;
  Inc(c, in_[7] + $676f02d9 + (a xor (b and (d xor a))));  c := ((c shl 14) or (c shr (32-14))) + d;
  Inc(b, in_[12] + $8d2a4c8a + (d xor (a and (c xor d))));  b := ((b shl 20) or (b shr (32-20))) + c;

  Inc(a, in_[5] + $fffa3942 + (b xor c xor d));  a := ((a shl 4) or (a shr (32-4))) + b;
  Inc(d, in_[8] + $8771f681 + (a xor b xor c));  d := ((d shl 11) or (d shr (32-11))) + a;
  Inc(c, in_[11] + $6d9d6122 + (d xor a xor b));  c := ((c shl 16) or (c shr (32-16))) + d;
  Inc(b, in_[14] + $fde5380c + (c xor d xor a));  b := ((b shl 23) or (b shr (32-23))) + c;
  Inc(a, in_[1] + $a4beea44 + (b xor c xor d));  a := ((a shl 4) or (a shr (32-4))) + b;
  Inc(d, in_[4] + $4bdecfa9 + (a xor b xor c));  d := ((d shl 11) or (d shr (32-11))) + a;
  Inc(c, in_[7] + $f6bb4b60 + (d xor a xor b));  c := ((c shl 16) or (c shr (32-16))) + d;
  Inc(b, in_[10] + $bebfbc70 + (c xor d xor a));  b := ((b shl 23) or (b shr (32-23))) + c;
  Inc(a, in_[13] + $289b7ec6 + (b xor c xor d));  a := ((a shl 4) or (a shr (32-4))) + b;
  Inc(d, in_[0] + $eaa127fa + (a xor b xor c));  d := ((d shl 11) or (d shr (32-11))) + a;
  Inc(c, in_[3] + $d4ef3085 + (d xor a xor b));  c := ((c shl 16) or (c shr (32-16))) + d;
  Inc(b, in_[6] + $04881d05 + (c xor d xor a));  b := ((b shl 23) or (b shr (32-23))) + c;
  Inc(a, in_[9] + $d9d4d039 + (b xor c xor d));  a := ((a shl 4) or (a shr (32-4))) + b;
  Inc(d, in_[12] + $e6db99e5 + (a xor b xor c));  d := ((d shl 11) or (d shr (32-11))) + a;
  Inc(c, in_[15] + $1fa27cf8 + (d xor a xor b));  c := ((c shl 16) or (c shr (32-16))) + d;
  Inc(b, in_[2] + $c4ac5665 + (c xor d xor a));  b := ((b shl 23) or (b shr (32-23))) + c;

  Inc(a, in_[0] + $f4292244 + (c xor (b or (not d))));  a := ((a shl 6) or (a shr (32-6))) + b;
  Inc(d, in_[7] + $432aff97 + (b xor (a or (not c))));  d := ((d shl 10) or (d shr (32-10))) + a;
  Inc(c, in_[14] + $ab9423a7 + (a xor (d or (not b))));  c := ((c shl 15) or (c shr (32-15))) + d;
  Inc(b, in_[5] + $fc93a039 + (d xor (c or (not a))));  b := ((b shl 21) or (b shr (32-21))) + c;
  Inc(a, in_[12] + $655b59c3 + (c xor (b or (not d))));  a := ((a shl 6) or (a shr (32-6))) + b;
  Inc(d, in_[3] + $8f0ccc92 + (b xor (a or (not c))));  d := ((d shl 10) or (d shr (32-10))) + a;
  Inc(c, in_[10] + $ffeff47d + (a xor (d or (not b))));  c := ((c shl 15) or (c shr (32-15))) + d;
  Inc(b, in_[1] + $85845dd1 + (d xor (c or (not a))));  b := ((b shl 21) or (b shr (32-21))) + c;
  Inc(a, in_[8] + $6fa87e4f + (c xor (b or (not d))));  a := ((a shl 6) or (a shr (32-6))) + b;
  Inc(d, in_[15] + $fe2ce6e0 + (b xor (a or (not c))));  d := ((d shl 10) or (d shr (32-10))) + a;
  Inc(c, in_[6] + $a3014314 + (a xor (d or (not b))));  c := ((c shl 15) or (c shr (32-15))) + d;
  Inc(b, in_[13] + $4e0811a1 + (d xor (c or (not a))));  b := ((b shl 21) or (b shr (32-21))) + c;
  Inc(a, in_[4] + $f7537e82 + (c xor (b or (not d))));  a := ((a shl 6) or (a shr (32-6))) + b;
  Inc(d, in_[11] + $bd3af235 + (b xor (a or (not c))));  d := ((d shl 10) or (d shr (32-10))) + a;
  Inc(c, in_[2] + $2ad7d2bb + (a xor (d or (not b))));  c := ((c shl 15) or (c shr (32-15))) + d;
  Inc(b, in_[9] + $eb86d391 + (d xor (c or (not a))));  b := ((b shl 21) or (b shr (32-21))) + c;

  Inc(buf[0], a);
  Inc(buf[1], b);
  Inc(buf[2], c);
  Inc(buf[3], d);
end;

//------------------------------------------------------------------------------

function MD5FromData(Buffer: Pointer; Len: LongInt): TMD5Digest;
var
  Context: TMD5Context;
begin
  MD5Init(Context);
  MD5Update(Context, Buffer, Len);
  Result := MD5Final(Context);
end;

//------------------------------------------------------------------------------

function MD5FromString(const S: String): TMD5Digest;
begin
  Result := MD5FromData(PChar(S), Length(S));
end;

//------------------------------------------------------------------------------

function MD5Final(var Context: TMD5Context): TMD5Digest;
var
  count: Integer;
  p: ^Byte;
begin
  count := Context.bytes[0] and $3f;  { Number of bytes in Context.in }
  p := @Context.in_;
  Inc(p, count);

  { Set the first char of padding to 0x80.  There is always room. }
  p^ := $80;
  Inc(p);

  { Bytes of padding needed to make 56 bytes (-8..55) }
  count := 56 - 1 - count;

  if count < 0 then begin  { Padding forces an extra block }
    FillChar(p^, count + 8, 0);
    MD5Transform(Context.buf, Context.in_);
    p := @Context.in_;
    count := 56;
  end;

  FillChar(p^, count, 0);

  { Append length in bits and transform }
  Context.in_[14] := Context.bytes[0] shl 3;
  Context.in_[15] := (Context.bytes[1] shl 3) or (Context.bytes[0] shr 29);
  MD5Transform(Context.buf, Context.in_);

  Move(Context.buf, Result, 16);
  FillChar(Context, SizeOf(Context), 0);  { In case it's sensitive }
end;

//------------------------------------------------------------------------------

procedure MD5Init(var Context: TMD5Context);
begin
  Context.buf[0] := LongWord($67452301);
  Context.buf[1] := LongWord($efcdab89);
  Context.buf[2] := LongWord($98badcfe);
  Context.buf[3] := LongWord($10325476);
  Context.bytes[0] := 0;
  Context.bytes[1] := 0;
end;

//------------------------------------------------------------------------------

function MD5IsEqual(const DigestA, DigestB: TMD5Digest): Boolean;
var
  I: Integer;
begin
  for I := Low(TMD5Digest) to High(TMD5Digest) do
  begin
    if DigestA[I] <> DigestB[I] then
    begin
      Result := False;
      Exit;
    end;
  end;

  Result := True;
end;

//------------------------------------------------------------------------------

function MD5IsNull(const Digest: TMD5Digest): Boolean;
var
  I: Integer;
begin
  for I := Low(TMD5Digest) to High(TMD5Digest) do
  begin
    if Digest[I] <> 0 then
    begin
      Result := False;
      Exit;
    end;
  end;

  Result := True;
end;

//------------------------------------------------------------------------------

function MD5ToString(const Digest: TMD5Digest; UpperCase: Boolean): String;
const
  Digits: array[0..15] of Char = '0123456789abcdef';
var
  Buf: array[0..(SizeOf(Digest) * 2) - 1] of Char;
  P: PChar;
  I: Integer;
begin
  P := @Buf;

  for I := 0 to SizeOf(Digest) - 1 do
  begin
    P^ := Digits[Digest[I] shr 4];

    if UpperCase then
      P^ := UpCase(P^);

    Inc(P);

    P^ := Digits[Digest[I] and 15];

    if UpperCase then
      P^ := UpCase(P^);

    Inc(P);
  end;

  SetString(Result, Buf, SizeOf(Buf));
end;

//------------------------------------------------------------------------------

procedure MD5Update(var Context: TMD5Context; Buffer: Pointer; Len: LongInt);
var
  t: LongWord;
begin
  { Update byte count }
  t := Context.bytes[0];
  Inc(Context.bytes[0], len);

  if Cardinal(Context.bytes[0]) < Cardinal(t) then
    Inc(Context.bytes[1]);  { Carry from low to high }

  t := 64 - (t and $3f);  { Space available in Context.in (at least 1) }
  if Cardinal(t) > Cardinal(len) then
  begin
    Move(Buffer^, Pointer(Cardinal(@Context.in_) + 64 - t)^, len);
    Exit;
  end;

  { First chunk is an odd size }
  Move(Buffer^, Pointer(Cardinal(@Context.in_) + 64 - t)^, t);
  MD5Transform(Context.buf, Context.in_);
  Inc(PByte(Buffer), t);
  Dec(len, t);

  { Process data in 64-byte chunks }
  while Cardinal(len) >= Cardinal(64) do
  begin
    Move(Buffer^, Context.in_, 64);
    MD5Transform(Context.buf, Context.in_);
    Inc(PByte(Buffer), 64);
    Dec(len, 64);
  end;

  { Handle any remaining bytes of data. }
  Move(Buffer^, Context.in_, len);
end;

end.
