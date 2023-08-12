{ The contents of this file are subject to the Mozilla Public License
  Version 1.1 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS"
  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
  License for the specific language governing rights and limitations
  under the License.

  The Original Code is DIMime.pas.

  The Initial Developer of the Original Code is Ralf Junker <delphi@yunqa.de>.

  All Rights Reserved.

------------------------------------------------------------------------------ }

unit DIMime;

{$I DICompilers.inc}

interface

uses
  DISystemCompat;

function MimeEncodeString(
  const s: RawByteString): RawByteString;

function MimeEncodeStringNoCRLF(
  const s: RawByteString): RawByteString;

function MimeDecodeString(
  const s: RawByteString): RawByteString;

function MimeEncodedSize(
  const InputSize: NativeUInt): NativeUInt;

function MimeEncodedSizeNoCRLF(
  const InputSize: NativeUInt): NativeUInt;

function MimeDecodedSize(
  const InputSize: NativeUInt): NativeUInt;

procedure DecodeHttpBasicAuthentication(
  const BasicCredentials: RawByteString;
  out UserId: RawByteString;
  out Password: RawByteString);

procedure MimeEncode(
  const InputBuffer;
  const InputByteCount: NativeUInt;
  out OutputBuffer);

procedure MimeEncodeNoCRLF(
  const InputBuffer;
  const InputByteCount: NativeUInt;
  out OutputBuffer);

procedure MimeEncodeFullLines(
  const InputBuffer;
  const InputByteCount: NativeUInt;
  out OutputBuffer);

function MimeDecode(
  const InputBuffer;
  const InputBytesCount: NativeUInt;
  out OutputBuffer): NativeUInt;

function MimeDecodePartial(
  const InputBuffer;
  const InputBytesCount: NativeUInt;
  out OutputBuffer;
  var ByteBuffer: NativeUInt;
  var ByteBufferSpace: NativeUInt): NativeUInt;

function MimeDecodePartialEnd(
  out OutputBuffer;
  const ByteBuffer: NativeUInt;
  const ByteBufferSpace: NativeUInt): NativeUInt;

const

  MIME_ENCODED_LINE_BREAK = 76;

  MIME_DECODED_LINE_BREAK = MIME_ENCODED_LINE_BREAK div 4 * 3;

implementation

const

  MIME_ENCODE_TABLE: array[0..63] of AnsiChar = (
    #065, #066, #067, #068, #069, #070, #071, #072,
    #073, #074, #075, #076, #077, #078, #079, #080,
    #081, #082, #083, #084, #085, #086, #087, #088,
    #089, #090, #097, #098, #099, #100, #101, #102,
    #103, #104, #105, #106, #107, #108, #109, #110,
    #111, #112, #113, #114, #115, #116, #117, #118,
    #119, #120, #121, #122, #048, #049, #050, #051,
    #052, #053, #054, #055, #056, #057, #043, #047);

  MIME_PAD_CHAR = '=';

  MIME_DECODE_TABLE: array[AnsiChar] of Byte = (
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 062, 255, 255, 255, 063,
    052, 053, 054, 055, 056, 057, 058, 059,
    060, 061, 255, 255, 255, 255, 255, 255,
    255, 000, 001, 002, 003, 004, 005, 006,
    007, 008, 009, 010, 011, 012, 013, 014,
    015, 016, 017, 018, 019, 020, 021, 022,
    023, 024, 025, 255, 255, 255, 255, 255,
    255, 026, 027, 028, 029, 030, 031, 032,
    033, 034, 035, 036, 037, 038, 039, 040,
    041, 042, 043, 044, 045, 046, 047, 048,
    049, 050, 051, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255);

function MimeEncodeString(
  const s: RawByteString): RawByteString;
var
  l: NativeUInt;
begin
  l := Length(s);
  if l > 0 then
    begin
      SetString(Result, nil, MimeEncodedSize(l));
      MimeEncode(PAnsiChar(s)^, l, PAnsiChar(Result)^);
    end
  else
    Result := '';
end;

function MimeEncodeStringNoCRLF(
  const s: RawByteString): RawByteString;
var
  l: NativeUInt;
begin
  l := Length(s);
  if l > 0 then
    begin
      SetString(Result, nil, MimeEncodedSizeNoCRLF(l));
      MimeEncodeNoCRLF(PAnsiChar(s)^, l, PAnsiChar(Result)^);
    end
  else
    Result := '';
end;

function MimeDecodeString(
  const s: RawByteString): RawByteString;
var
  ByteBuffer, ByteBufferSpace: NativeUInt;
  l: NativeUInt;
begin
  l := Length(s);
  if l > 0 then
    begin
      SetString(Result, nil, MimeDecodedSize(l));
      ByteBuffer := 0;
      ByteBufferSpace := 4;
      l := MimeDecodePartial(PAnsiChar(s)^, l, PAnsiChar(Result)^, ByteBuffer, ByteBufferSpace);
      Inc(l, MimeDecodePartialEnd((PAnsiChar(Result) + l)^, ByteBuffer, ByteBufferSpace));
      SetLength(Result, l);
    end
  else
    Result := '';
end;

procedure DecodeHttpBasicAuthentication(
  const BasicCredentials: RawByteString;
  out UserId: RawByteString;
  out Password: RawByteString);
label
  Fail;
const
  LBasic = 6;
var
  DecodedPtr, p: PAnsiChar;
  i, l: NativeUInt;
begin
  l := Length(BasicCredentials);
  if l <= LBasic then goto Fail;
  Dec(l, LBasic);

  p := PAnsiChar(BasicCredentials);
  Inc(p, LBasic);

  GetMem(DecodedPtr, MimeDecodedSize(l));
  l := MimeDecode(p^, l, DecodedPtr^);

  i := 0;
  p := DecodedPtr;
  while (l > 0) and (p[i] <> ':') do
    begin
      Inc(i);
      Dec(l);
    end;

  SetString(UserId, DecodedPtr, i);
  if l > 1 then
    SetString(Password, DecodedPtr + i + 1, l - 1)
  else
    Password := '';

  FreeMem(DecodedPtr);
  Exit;

  Fail:
  UserId := '';
  Password := '';
end;

function MimeEncodedSize(
  const InputSize: NativeUInt): NativeUInt;
begin
  Result := InputSize;
  if Result > 0 then
    Result := (Result + 2) div 3 * 4 + (Result - 1) div MIME_DECODED_LINE_BREAK * 2;
end;

function MimeEncodedSizeNoCRLF(
  const InputSize: NativeUInt): NativeUInt;
begin
  Result := (InputSize + 2) div 3 * 4;
end;

function MimeDecodedSize(
  const InputSize: NativeUInt): NativeUInt;
begin
  Result := (InputSize + 3) div 4 * 3;
end;

procedure MimeEncode(
  const InputBuffer;
  const InputByteCount: NativeUInt;
  out OutputBuffer);
var
  iDelta, ODelta: NativeUInt;
begin
  MimeEncodeFullLines(InputBuffer, InputByteCount, OutputBuffer);
  iDelta := InputByteCount div MIME_DECODED_LINE_BREAK;
  ODelta := iDelta * (MIME_ENCODED_LINE_BREAK + 2);
  iDelta := iDelta * MIME_DECODED_LINE_BREAK;
  MimeEncodeNoCRLF((PAnsiChar(@InputBuffer) + iDelta)^, InputByteCount - iDelta, (PAnsiChar(@OutputBuffer) + ODelta)^);
end;

procedure MimeEncodeFullLines(
  const InputBuffer;
  const InputByteCount: NativeUInt;
  out OutputBuffer);
var
  b: NativeUInt;
  InnerLimit, OuterLimit: PAnsiChar;
  InPtr, OutPtr: PAnsiChar;
begin

  if InputByteCount < MIME_DECODED_LINE_BREAK then Exit;

  InPtr := @InputBuffer;
  OutPtr := @OutputBuffer;

  InnerLimit := InPtr + MIME_DECODED_LINE_BREAK;
  OuterLimit := InPtr + InputByteCount;

  repeat

    repeat

      b := Ord(InPtr[0]);
      b := b shl 8;
      b := b or Ord(InPtr[1]);
      b := b shl 8;
      b := b or Ord(InPtr[2]);
      Inc(InPtr, 3);

      OutPtr[3] := MIME_ENCODE_TABLE[b and $3F];
      b := b shr 6;
      OutPtr[2] := MIME_ENCODE_TABLE[b and $3F];
      b := b shr 6;
      OutPtr[1] := MIME_ENCODE_TABLE[b and $3F];
      b := b shr 6;
      OutPtr[0] := MIME_ENCODE_TABLE[b];
      Inc(OutPtr, 4);
    until InPtr >= InnerLimit;

    OutPtr[0] := #13;
    OutPtr[1] := #10;
    Inc(OutPtr, 2);

    Inc(InnerLimit, MIME_DECODED_LINE_BREAK);
  until InnerLimit > OuterLimit;
end;

procedure MimeEncodeNoCRLF(
  const InputBuffer;
  const InputByteCount: NativeUInt;
  out OutputBuffer);
var
  b, OuterLimit: NativeUInt;
  InnerLimit: PAnsiChar;
  InPtr, OutPtr: PAnsiChar;
begin
  if InputByteCount = 0 then Exit;

  InPtr := @InputBuffer;
  OutPtr := @OutputBuffer;

  OuterLimit := InputByteCount div 3 * 3;
  InnerLimit := InPtr + OuterLimit;

  while InPtr < InnerLimit do
    begin

      b := Ord(InPtr[0]);
      b := b shl 8;
      b := b or Ord(InPtr[1]);
      b := b shl 8;
      b := b or Ord(InPtr[2]);
      Inc(InPtr, 3);

      OutPtr[3] := MIME_ENCODE_TABLE[b and $3F];
      b := b shr 6;
      OutPtr[2] := MIME_ENCODE_TABLE[b and $3F];
      b := b shr 6;
      OutPtr[1] := MIME_ENCODE_TABLE[b and $3F];
      b := b shr 6;
      OutPtr[0] := MIME_ENCODE_TABLE[b];
      Inc(OutPtr, 4);
    end;

  case InputByteCount - OuterLimit of
    1:
      begin
        b := Ord(InPtr[0]);
        b := b shl 4;
        OutPtr[1] := MIME_ENCODE_TABLE[b and $3F];
        b := b shr 6;
        OutPtr[0] := MIME_ENCODE_TABLE[b];
        OutPtr[2] := MIME_PAD_CHAR;
        OutPtr[3] := MIME_PAD_CHAR;
      end;
    2:
      begin
        b := Ord(InPtr[0]);
        b := b shl 8;
        b := b or Ord(InPtr[1]);
        b := b shl 2;
        OutPtr[2] := MIME_ENCODE_TABLE[b and $3F];
        b := b shr 6;
        OutPtr[1] := MIME_ENCODE_TABLE[b and $3F];
        b := b shr 6;
        OutPtr[0] := MIME_ENCODE_TABLE[b];
        OutPtr[3] := MIME_PAD_CHAR;
      end;
  end;
end;

function MimeDecode(
  const InputBuffer;
  const InputBytesCount: NativeUInt;
  out OutputBuffer): NativeUInt;
var
  ByteBuffer, ByteBufferSpace: NativeUInt;
begin
  ByteBuffer := 0;
  ByteBufferSpace := 4;
  Result := MimeDecodePartial(InputBuffer, InputBytesCount, OutputBuffer, ByteBuffer, ByteBufferSpace);
  Inc(Result, MimeDecodePartialEnd((PAnsiChar(@OutputBuffer) + Result)^, ByteBuffer, ByteBufferSpace));
end;

function MimeDecodePartial(
  const InputBuffer;
  const InputBytesCount: NativeUInt;
  out OutputBuffer;
  var ByteBuffer: NativeUInt;
  var ByteBufferSpace: NativeUInt): NativeUInt;
var
  c, lByteBuffer, lByteBufferSpace: NativeUInt;
  InPtr, OutPtr, OuterLimit: PAnsiChar;
begin
  if InputBytesCount > 0 then
    begin
      InPtr := @InputBuffer;
      OuterLimit := InPtr + InputBytesCount;
      OutPtr := @OutputBuffer;
      lByteBuffer := ByteBuffer;
      lByteBufferSpace := ByteBufferSpace;
      while InPtr <> OuterLimit do
        begin

          c := MIME_DECODE_TABLE[InPtr^];
          Inc(InPtr);
          if c = $FF then Continue;
          lByteBuffer := lByteBuffer shl 6;
          lByteBuffer := lByteBuffer or c;
          Dec(lByteBufferSpace);

          if lByteBufferSpace <> 0 then Continue;

          OutPtr[2] := AnsiChar(lByteBuffer);
          lByteBuffer := lByteBuffer shr 8;
          OutPtr[1] := AnsiChar(lByteBuffer);
          lByteBuffer := lByteBuffer shr 8;
          OutPtr[0] := AnsiChar(lByteBuffer);
          lByteBuffer := 0;
          Inc(OutPtr, 3);
          lByteBufferSpace := 4;
        end;
      ByteBuffer := lByteBuffer;
      ByteBufferSpace := lByteBufferSpace;
      Result := OutPtr - PAnsiChar(@OutputBuffer);
    end
  else
    Result := 0;
end;

function MimeDecodePartialEnd(
  out OutputBuffer;
  const ByteBuffer: NativeUInt;
  const ByteBufferSpace: NativeUInt): NativeUInt;
var
  lByteBuffer: NativeUInt;
begin
  case ByteBufferSpace of
    1:
      begin
        lByteBuffer := ByteBuffer shr 2;
        PAnsiChar(@OutputBuffer)[1] := AnsiChar(lByteBuffer);
        lByteBuffer := lByteBuffer shr 8;
        PAnsiChar(@OutputBuffer)[0] := AnsiChar(lByteBuffer);
        Result := 2;
      end;
    2:
      begin
        lByteBuffer := ByteBuffer shr 4;
        PAnsiChar(@OutputBuffer)[0] := AnsiChar(lByteBuffer);
        Result := 1;
      end;
  else
    Result := 0;
  end;
end;

end.

