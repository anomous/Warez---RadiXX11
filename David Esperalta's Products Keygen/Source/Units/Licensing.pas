unit Licensing;

interface

type
  TTransformFunction = function(Code1, Code2, Code3: Byte; Value: Int64): Byte;

function Transform1(a1, a2, a3: Byte; a4: Int64): Byte;
function Transform2(a1, a2, a3: Byte; a4: Int64): Byte;
function Transform3(a1, a2, a3: Byte; a4: Int64): Byte;

type
  TProductInfo = record
    Name: String;
    Id: Integer;
    Transform: TTransformFunction;
    Code: array[0..10, 0..2] of Byte;
  end;

const
  ProductList: array[0..5] of TProductInfo = (
    (
      Name: 'App Builder';
      Id: $0001434B;
      Transform: Transform3;
      Code:
      (
        ($0C, $42, $DA),
        ($22, $23, $99),
        ($49, $55, $D9),
        ($20, $2E, $A8),
        ($4A, $30, $DD),
        ($35, $17, $C0),
        ($3B, $30, $B8),
        ($23, $54, $DB),
        ($60, $27, $A5),
        ($19, $37, $C3),
        ($22, $49, $7D)
      )
    ),
    (
      Name: 'HTML Compiler';
      Id: $000154DD;
      Transform: Transform3;
      Code:
      (
        ($21, $0C, $7B),
        ($35, $3D, $DE),
        ($2C, $43, $AE),
        ($0D, $2A, $9C),
        ($2A, $38, $D9),
        ($16, $29, $AF),
        ($2D, $15, $6F),
        ($16, $35, $D6),
        ($34, $4D, $A3),
        ($29, $34, $D7),
        ($42, $5D, $C2)
      )
    ),
    (
      Name: 'Img Converter';
      Id: $00017289;
      Transform: Transform1;
      Code:
      (
        ($5E, $0B, $91),
        ($37, $4B, $AB),
        ($47, $49, $85),
        ($0E, $18, $70),
        ($0F, $29, $9D),
        ($3A, $58, $8E),
        ($3B, $23, $6F),
        ($43, $19, $AA),
        ($54, $15, $A4),
        ($1B, $2A, $E7),
        ($42, $1B, $A6)
      )
    ),
    (
      Name: 'Screen GIF';
      Id: $00017289;
      Transform: Transform2;
      Code:
      (
        ($2D, $0F, $D3),
        ($11, $27, $A4),
        ($13, $12, $D5),
        ($17, $63, $64),
        ($45, $16, $B1),
        ($0A, $26, $B8),
        ($10, $0F, $A2),
        ($51, $4B, $DA),
        ($0E, $3E, $C2),
        ($59, $0F, $B7),
        ($47, $0D, $DB)
      )
    ),
    (
      Name: 'Small Editor';
      Id: $00004762;
      Transform: Transform3;
      Code:
      (
        ($21, $11, $7B),
        ($2C, $4E, $A7),
        ($47, $2C, $D7),
        ($42, $62, $DD),
        ($1B, $0D, $D3),
        ($3E, $44, $A6),
        ($45, $1A, $AD),
        ($0F, $30, $C7),
        ($1F, $11, $83),
        ($4E, $1D, $79),
        ($5B, $15, $D7)
      )
    ),
    (
      Name: 'Volume Keys';
      Id: $000051EC;
      Transform: Transform2;
      Code:
      (
        ($0C, $2C, $9D),
        ($52, $0B, $DE),
        ($3E, $0E, $A6),
        ($1A, $1A, $C0),
        ($5F, $4A, $D7),
        ($4F, $55, $88),
        ($18, $30, $DE),
        ($11, $54, $BB),
        ($53, $49, $66),
        ($43, $35, $DA),
        ($24, $4E, $AE)
      )
    )
  );

function GenerateSerial(const ProductInfo: TProductInfo;
  const UserName: String): String;
{$IFDEF DEBUG}
function ValidateSerial(const ProductInfo: TProductInfo; const UserName,
  Serial: String): Boolean;
{$ENDIF}

implementation

uses
  StrUtils,
  SysUtils;

//------------------------------------------------------------------------------

function Calc(a1: Int64; a2: Byte): Integer;
var
  v2: Byte;
begin
  v2 := a2 and $3F;

  if v2 < $20 then
    Result := a1 shr (v2 and $1F)
  else
    Result := (a1 shr $20) shr v2;
end;

//------------------------------------------------------------------------------

function Transform1(a1, a2, a3: Byte; a4: Int64): Byte;
var
  v5, v10: Byte;
begin
  v5 := a1 mod $0C;
  v10 := a2 mod $22;

  if (v5 and 1) <> 0 then
    Result := (a3 and Calc(a4, v10)) xor Calc(a4, v5)
  else
    Result := (a3 or Calc(a4, v10)) xor Calc(a4, v5);
end;

//------------------------------------------------------------------------------

function Transform2(a1, a2, a3: Byte; a4: Int64): Byte;
var
  v5, v10: Byte;
begin
  v5 := a1 mod $1F;
  v10 := a2 mod $1D;

  if (v5 and 1) <> 0 then
    Result := (a3 and Calc(a4, v10)) xor Calc(a4, v5)
  else
    Result := (a3 or Calc(a4, v10)) xor Calc(a4, v5);
end;

//------------------------------------------------------------------------------

function Transform3(a1, a2, a3: Byte; a4: Int64): Byte;
var
  v5, v10: Byte;
begin
  v5 := a1 mod $16;
  v10 := a2 mod $0D;

  if (v5 and 1) <> 0 then
    result := (a3 and Calc(a4, v10)) xor Calc(a4, v5)
  else
    result := (a3 or Calc(a4, v10)) xor Calc(a4, v5);
end;

//------------------------------------------------------------------------------

function GetUserNameChecksum(const S: String): Integer;
var
  I: Integer;
begin
  Result := 0;

  for I := 1 to Length(S) do
  begin
    if I = 1 then
      Inc(Result, Byte(S[I]) + Byte(S[I + 1]))
    else
      Inc(Result, Byte(S[I]) + Byte(S[I - 1]));
  end;
end;

//------------------------------------------------------------------------------

function GetSerialCheskum(const S: String): String;
var
  I, v2 ,v3: Integer;
begin
  v2 := 86;
  v3 := 175;

  for I := 1 to Length(S) do
  begin
    Inc(v3, Byte(S[I]));

    if Word(v3) > $FF then
      Dec(v3, 255);

    Inc(v2, v3);

    if Word(v2) > $FF then
      Dec(v2, 255);
  end;

  Result := IntToHex(Word(v3 + (v2 shl 8)), 4);
end;

//------------------------------------------------------------------------------

function ValidateUserNameLen(S: String): Boolean;
begin
  S := Trim(S);
  Result := (Length(S) >= 25) and (Length(S) <= 200);
end;

//------------------------------------------------------------------------------

function GenerateSerial(const ProductInfo: TProductInfo;
  const UserName: String): String;
var
  Value: Int64;
  I: Integer;
begin
  if not ValidateUserNameLen(UserName) then
  begin
    Result := '';
    Exit;
  end;

  with ProductInfo do
  begin
    Value := GetUserNameChecksum(UserName) * Id;

    Result := IntToHex(Transform(Code[0, 0], Code[0, 1], Code[0, 2], Value), 2);
    Result := Result + IntToHex(Transform(Code[1, 0], Code[1, 1], Code[1, 2], Value), 2);
    Result := Result + IntToHex(Transform(Code[2, 0], Code[2, 1], Code[2, 2], Value), 2);
    Result := Result + IntToHex(Transform(Code[3, 0], Code[3, 1], Code[3, 2], Value), 2);
    Result := Result + IntToHex(Transform(Code[4, 0], Code[4, 1], Code[4, 2], Value), 2);
    Result := Result + IntToHex(Transform(Code[5, 0], Code[5, 1], Code[5, 2], Value), 2);
    Result := Result + IntToHex(Transform(Code[6, 0], Code[6, 1], Code[6, 2], Value), 2);
    Result := Result + IntToHex(Transform(Code[7, 0], Code[7, 1], Code[7, 2], Value), 2);
    Result := Result + IntToHex(Transform(Code[8, 0], Code[8, 1], Code[8, 2], Value), 2);
    Result := Result + IntToHex(Transform(Code[9, 0], Code[9, 1], Code[9, 2], Value), 2);
    Result := Result + IntToHex(Transform(Code[10, 0], Code[10, 1], Code[10, 2], Value), 2);
  end;

  Result := Result + IntToHex(Random(256), 2);
  Result := Result + GetSerialCheskum(Result);

  for I := Length(Result) downto 1 do
    if (I mod 5) = 0 then Insert('-', Result, I)
end;

//------------------------------------------------------------------------------

{$IFDEF DEBUG}
function RemoveHipensAndUpercase(const S: String): String;
begin
  Result := UpperCase(StringReplace(S, '-', EmptyStr, [rfReplaceAll]));
end;

//------------------------------------------------------------------------------

function ValidateSerialFormat(S: String): Boolean;
begin
  S := RemoveHipensAndUpercase(S);

  if Length(S) = 28 then
    Result := GetSerialCheskum(LeftStr(S, 24)) = RightStr(S, 4)
  else
    Result := False;
end;

//------------------------------------------------------------------------------

function ValidateSerial(const ProductInfo: TProductInfo; const UserName,
  Serial: String): Boolean;
var
  S: String;
  Value: Int64;
begin
  Result := False;

  if ValidateUserNameLen(UserName) and ValidateSerialFormat(Serial) then
  begin
    S := RemoveHipensAndUpercase(Serial);

    with ProductInfo do
    begin
      Value := GetUserNameChecksum(UserName) * Id;

      if Copy(S, 1, 2) <> IntToHex(Transform(Code[0, 0], Code[0, 1], Code[0, 2], Value), 2) then Exit;
      if Copy(S, 3, 2) <> IntToHex(Transform(Code[1, 0], Code[1, 1], Code[1, 2], Value), 2) then Exit;
      if Copy(S, 5, 2) <> IntToHex(Transform(Code[2, 0], Code[2, 1], Code[2, 2], Value), 2) then Exit;
      if Copy(S, 7, 2) <> IntToHex(Transform(Code[3, 0], Code[3, 1], Code[3, 2], Value), 2) then Exit;
      if Copy(S, 9, 2) <> IntToHex(Transform(Code[4, 0], Code[4, 1], Code[4, 2], Value), 2) then Exit;
      if Copy(S, 11, 2) <> IntToHex(Transform(Code[5, 0], Code[5, 1], Code[5, 2], Value), 2) then Exit;
      if Copy(S, 13, 2) <> IntToHex(Transform(Code[6, 0], Code[6, 1], Code[6, 2], Value), 2) then Exit;
      if Copy(S, 15, 2) <> IntToHex(Transform(Code[7, 0], Code[7, 1], Code[7, 2], Value), 2) then Exit;
      if Copy(S, 17, 2) <> IntToHex(Transform(Code[8, 0], Code[8, 1], Code[8, 2], Value), 2) then Exit;
      if Copy(S, 19, 2) <> IntToHex(Transform(Code[9, 0], Code[9, 1], Code[9, 2], Value), 2) then Exit;
      if Copy(S, 21, 2) <> IntToHex(Transform(Code[10, 0], Code[10, 1], Code[10, 2], Value), 2) then Exit;
    end;

    Result := True;
  end;
end;
{$ENDIF}

end.
