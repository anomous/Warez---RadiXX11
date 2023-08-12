//------------------------------------------------------------------------------
// My Notes Keeper 3.x Keygen
// Product homepage: http://www.mynoteskeeper.com 
//
// © 2020, RadiXX11
// https://radixx11rce2.blogspot.com
//
// DISCLAIMER: This source code is distributed AS IS, for educational purposes
// ONLY. No other use is permitted without expressed permission from the author.
//------------------------------------------------------------------------------

program Keygen;

{$APPTYPE CONSOLE}

uses
  SysUtils;

//------------------------------------------------------------------------------

const
  Indexes: array[0..23] of Integer = (0, 3, 1, 2, 1, 3, 1, 0, 2, 3, 2, 0, 3, 2, 0, 1, 0, 2, 2, 1, 3, 0, 3, 1);
  Values: array[0..3] of Integer = ($55147626, $8D0BF107, $F9492A40, $2874514A);

//------------------------------------------------------------------------------

function BinToHex2(Buffer: PChar; Size: Integer): String;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to Size - 1 do
    Result := Result + IntToHex(Ord(Buffer[I]), 2);
end;

//------------------------------------------------------------------------------

function StringHash(const S: String): Integer;
var
  I, J: Integer;
  K: LongWord;
begin
  Result := 0;

  for I := 1 to Length(S) do
  begin
    J := Ord(S[I]) + 16 * Result;
    K := J and $F0000000;

    if K <> 0 then
      J := J xor (K shr 24);

    Result := (not K) and J;
  end;
end;

//------------------------------------------------------------------------------

function UnknownDateDiff(Date: TDateTime): Word;
const
  BaseDate = $88F9;
var
  v1: Int64;
begin
  v1 := Trunc(Date);

  if (v1 <> 0) and (LongWord(v1 - BaseDate) <= $FFFF) then
    Result := v1 - BaseDate
  else
    Result := 0;
end;

//------------------------------------------------------------------------------
// TODO: This function works just fine, but can be optimized.
//------------------------------------------------------------------------------

function GenerateCode(const Name: String): String;
var
  Data2: array[0..1] of Integer;
  Data0, Data1: PIntegerArray;
  V5, V9, v15: LongWord;
  I, Value1, Value2, V4, V6, V7, V8, V10, V11, V12, V13, V14, V16: Integer;
  Value0: Byte;
begin
  Data0 := @Indexes;
  Data1 := @Values;
  Data2[0] := (UnknownDateDiff(EncodeDate(9999, 12, 31)) shl 16) or $D9F6;
  Data2[1] := StringHash(UpperCase(Name));
  Value0 := 1;
  Value1 := Data2[0];
  Value2 := Data2[1];

  for I := 1 to 4 do
  begin
    V4 := Data1[Data0[12 * Value0 + 2]];
    V5 := (LongWord(v4 + Value1) shr 7) xor (v4 + Value1);
    V6 := V5 + Data1[Data0[12 * Value0]];
    V7 := V6 + V5;
    V8 := (V6 shl 13) xor v6;
    V9 := V8 + Data1[Data0[12 * Value0 + 1]];
    V10 := V9 + V8;
    V11 := (V9 shr 17) xor v9;
    V12 := V11 + V4 + Value1 + V4;
    V13 := V12 + v11;
    V14 := (V12 shl 9) xor V12;
    V15 := ((LongWord(V14 + V7 + V14) shr 15) xor ((((((LongWord(v14 + V7) shr 3) xor (V14 + V7)) + V10) shl 7) xor (((LongWord(V14 + V7) shr 3) xor (V14 + V7)) + V10)) + V13)) + V14 + V7 + V14;
    V16 := (V15 shl 11) xor V15 xor Value2;
    Value2 := Value1;
    Value1 := V16;
    Data0 := PIntegerArray(LongWord(Data0) + 12);
  end;

  Data2[0] := Value2;
  Data2[1] := Value1;
  Result := BinToHex2(@Data2, SizeOf(Data2));
end;

var
  Name: String;

begin
  WriteLn('My Notes Keeper 3.x Keygen [by RadiXX11]');
  WriteLn('========================================');
  WriteLn;

  Write('Name: ');
  ReadLn(Name);

  if Trim(Name) <> '' then
    WriteLn('Code: ', GenerateCode(Name));

  ReadLn;
end.
