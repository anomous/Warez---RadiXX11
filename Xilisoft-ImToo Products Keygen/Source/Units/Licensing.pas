unit Licensing;

interface

function GenerateLicenseCode(const ProductId: String): String;
function GetProductId(const FileName: String): String;

implementation

uses
  MD5,
  SysUtils;

//------------------------------------------------------------------------------
  
function GenerateLicenseCode(const ProductId: String): String;
var
  S1, S2, S3: String;
  I: Integer;
begin
  if ProductId = '' then
  begin
    Result := '';
    Exit;
  end;

  S1 := ProductId + #0;
  S2 := Copy(ProductId, 2, MaxInt) + #0;

  for I := 0 to Length(ProductId) - 1 do
  begin
    if (I mod 2) = 0 then
      S1[I + 2] := Char(I + 1)
    else
      S2[I + 1] := Char(I + 1);
  end;

  if S1[Length(S1)] = #0 then
    SetLength(S1, Length(S1) - 1);

  if S2[Length(S2)] = #0 then
    SetLength(S2, Length(S2) - 1);

  SetLength(S3, 20);

  for I := 1 to 20 do
  begin
    if (I mod 5) = 0 then
      S3[I] := '-'
    else
      S3[I] := IntToHex(Random(16), 1)[1];
  end;

  S1 := MD5ToString(MD5FromString('1' + S1 + S2 + '00' + S3 + ProductId), True);
  S2 := '';

  for I := 0 to 15 do
    S2 := S2 + S1[(I * 2) + 1];

  for I := 15 downto 0 do
    if (I > 0) and ((I mod 4) = 0) then
      Insert('-', S2, I + 1);

  Result := S3 + S2;
end;

//------------------------------------------------------------------------------

function GetProductId(const FileName: String): String;
var
  F: File;
  Value1, Value2, Value3, Value4, Value5: Int64;
  Value6, Value7: byte;
  I, J, Size: integer;
  P: PChar;
begin
  Result := '';
  Size := 0;
  P := nil;

  // Load file contents into memory ////////////////////////////////////////////

  try
    AssignFile(F, FileName);
    FileMode := fmOpenRead;
    Reset(F, 1);
    
    try
      Size := FileSize(F);
      GetMem(P, Size);
      BlockRead(F, P^, Size);
      
    finally
      CloseFile(F);
    end;
  except
    Exit;
  end;

  // Decrypt file contents to a string /////////////////////////////////////////

  if Size > 0 then
  begin
    Value1 := $2A262423;
    Value2 := $31323334;
    Value3 := $2A262423;

    for I := 0 to Size - 1 do
    begin
      Value4 := Abs(Value2) mod 2;
      Value5 := Abs(Value3) mod 2;
      Value6 := 0;

      for J := 1 to 8 do
      begin
        if not Odd(Value1) then
        begin
          Value1 := (Value1 shr 1) and $7FFFFFFF;

          if not Odd(Value3) then
          begin
            Value3 := (Value3 shr 1) and $FFFFFFF;
            Value5 := 0;
          end
          else
          begin
            Value3 := ((Value3 xor $10000002) shr 1) or $FFFFFFFFF0000000;
            Value5 := 1;
          end;
        end
        else
        begin
          Value1 := ((Value1 xor $FFFFFFFF80000062) shr 1) or $FFFFFFFF80000000;

          if not Odd(Value2) then
          begin
            Value2 := (Value2 shr 1) and $3FFFFFFF;
            Value4 := 0;
          end
          else
          begin
            Value2 := ((Value2 xor $40000020) shr 1) or $FFFFFFFFC0000000;
            Value4 := 1;
          end;
        end;

        Value6 := Byte(((Value6 shl 1) or (Value4 xor Value5)) and $FFFF);
      end;

      Value7 := Byte(P[I]) xor Value6;

      if Value7 = 0 then
        Result := Result + Char(Value6)
      else
        Result := Result + Char(Value7);
    end;
  end;

  if P <> nil then
    FreeMem(P);

  // Extract reg encryption string from decrypted text /////////////////////////

  I := Pos('REG_ENCRYPTION_STRING=', UpperCase(Result));

  if I > 0 then
  begin
    Result := Copy(Result, I + 22, MaxInt);
    I := Pos(#10, Result);

    if I = 0 then
      I := Length(Result)
    else
      Dec(I);

    Result := Trim(Copy(Result, 1, I));
  end;
end;

end.
