program Keygen;

{$APPTYPE CONSOLE}

uses
  MD5,
  SysUtils;

//------------------------------------------------------------------------------
  
const
  Charset: PChar = 'CA5BDWF4H9PJK3SUM2XEL7GRZNQTY6V8';
  IndexTable: array[0..29] of Byte = (
    $00, $06, $0B, $0C, $11, $16, $19, $1C, $1D, $1E, $1F, $26, $27, $28, $29,
    $2F, $30, $31, $32, $37, $3C, $41, $44, $45, $46, $47, $4D, $4E, $54, $59
  );

//------------------------------------------------------------------------------
  
function IsValidIndex(Value: Byte): Boolean;
var
  I: Integer;
begin
  for I := Low(IndexTable) to High(IndexTable) do
  begin
    if IndexTable[I] = Value then
    begin
      Result := True;
      Exit;
    end;
  end;
  
  Result := False;
end;

//------------------------------------------------------------------------------

procedure Encode1(Buffer: PChar; var Data: array of LongWord);
var
  I, J, K, L, M, Len, Index: LongWord;
begin
  Len := StrLen(Buffer);

  if Len > 0 then
  begin
    I := 0;
    J := 0;
    K := 0;

    repeat
      L := Pos(Buffer[J], Charset) - 1;
      M := I + 5;

      while I < M do
      begin
        Index := I div 32;
        Data[Index] := Data[Index] or (((L shr (I mod 5)) and 1) shl I);
        Inc(I);
        M := K + 5
      end;

      Inc(J);
      I := K + 5;
      Inc(K, 5);
    until J = Len;
  end;
end;

//------------------------------------------------------------------------------

procedure Encode2(var Data: array of LongWord; Value1, Value2: LongWord);
var
  Buffer: array[0..2] of LongWord;
  I, J, Index: LongWord;
begin
  FillChar(Buffer, SizeOf(Buffer), 0);

  if Value2 <> 0 then
  begin
    for I := 0 to Value2 - 1 do
    begin
      Index := I div 32;
      Buffer[Index] := Buffer[Index] or ((1 shl I) and Data[Index]);
    end;
  end;

  for I := 0 to Value2 - 1 do
  begin
    J := ((1 shl Value1) and Buffer[Value1 shr 5]) shr (Value1 and $1F);
    Index := I div 32;

    if J <> 0 then
      Data[Index] := Data[Index] or (J shl i)
    else
      Data[Index] := Data[Index] and (not (1 shl I));

    Value1 := (Value1 + 1) mod Value2;
  end;
end;

//------------------------------------------------------------------------------

procedure Encode3(var Data: array of LongWord; Buffer: PChar; Len: LongWord);
var
  I, J, K, L, M: LongWord;
begin
  if Len > 0 then
  begin
    M := 0;
    J := 0;

    for I := 0 to Len - 1 do
    begin
      K := 0;
      L := M;

      repeat
        M := J;
        K := K or (((Data[L div 32] shr (L mod 32)) and 1) shl (L mod 5));
        Inc(L);
      until L >= (J + 5);

      Buffer[I] := Charset[K];
      Inc(M, 5);
      J := M;
    end;
  end;
end;

//------------------------------------------------------------------------------

function RandomUInt: LongWord;
var
  P: PChar;
  I: Integer;
begin
  P := @Result;
  for I := 0 to 3 do
    P[I] := Char(Random(256));
end;

//------------------------------------------------------------------------------

function GenerateRegCode: String;
var
  Buffer1: array[0..21] of Char;
  Buffer2: array[0..18] of Char;
  Data1: array[0..1] of LongWord;
  Data2: array[0..2] of LongWord;
  Value, I, J, K, L: LongWord;
begin
  Data1[0] := $4005FFE0;
  Data1[1] := RandomUInt;
  Value := RandomUInt;

  FillChar(Buffer1, SizeOf(Buffer1), 0);

  I := 0;
  J := 0;
  K := 0;
  L := 0;
  
  repeat
    if not IsValidIndex(I) then
    begin
      K := K or (((1 shl L) and Data1[L div 32]) shr L shl J);
      Inc(L);
    end;

    J := (J + 1) mod 5;

    if (J = 0) and (I <> 0) then
    begin
      Buffer1[I div 5] := Charset[K];
      K := 0;
    end;

    Inc(I);
  until I = 90;

  Result := Copy(MD5ToString(MD5FromBuffer(Buffer1, StrLen(Buffer1)), True), 1, 4);
  Result := StringReplace(Result, '0', 'R', [rfReplaceAll]);
  Result := StringReplace(Result, '1', 'M', [rfReplaceAll]);

  FillChar(Data2, SizeOf(Data2), 0);
  FillChar(Buffer2, SizeOf(Buffer2), 0);

  I := Value and $1F;

  Encode1(Buffer1, Data2);
  Encode2(Data2, $5A - I, $5A);
  Encode3(Data2, Buffer2, 18);

  FillChar(Buffer1, SizeOf(Buffer1), 0);
  Move(Buffer2[0], Buffer1[0], 10);
  Buffer1[10] := Charset[I];
  Move(Buffer2[10], Buffer1[11], 8);

  FillChar(Data2, SizeOf(Data2), 0);
  FillChar(Buffer2, SizeOf(Buffer2), 0);

  I := (Value shr 8) and $1F;
  J := (Value shr 16) and $1F;

  Encode1(Buffer1, Data2);
  Encode2(Data2, I, J + $21);
  Encode3(Data2, Buffer2, 19);

  FillChar(Buffer1, SizeOf(Buffer1), 0);
  Move(Buffer2[0], Buffer1[0], 5);
  Buffer1[5] := Charset[I];
  Move(Buffer2[5], Buffer1[6], 5);
  Buffer1[11] := Charset[J];
  Move(Buffer2[10], Buffer1[12], 9);

  Result := Buffer1 + Result;

  Insert('-', Result, 6);
  Insert('-', Result, 12);
  Insert('-', Result, 18);
  Insert('-', Result, 24);
end;

begin
  Randomize;

  WriteLn('TechSmith Camtasia 2018 Keygen [by RadiXX11]');
  WriteLn('============================================');
  WriteLn;
  WriteLn('Registration Code: ', GenerateRegCode);

  ReadLn;
end.
