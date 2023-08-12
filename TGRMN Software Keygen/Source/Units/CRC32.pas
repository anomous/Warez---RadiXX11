unit CRC32;

interface

procedure CRC32Init(var CRC32: LongWord);
function CRC32Update(const CRC32: LongWord; const Octet: Byte): LongWord; overload;
function CRC32Update(const CRC32: LongWord; const Buf;
  const BufSize: Integer): LongWord; overload;
function CRC32UpdateNoCase(const CRC32: LongWord; const Buf;
  const BufSize: Integer): LongWord;
procedure SetCRC32Poly(const Poly: LongWord);

function CRC32FromBuffer(const Buf; const BufSize: Integer): LongWord;
function CRC32FromString(const S: String): LongWord;
function CRC32ToString(const CRC32: LongWord; UpperCase: Boolean): String;

implementation

uses
  SysUtils;

var
  CRC32TableInit: Boolean = False;
  CRC32Table: array[Byte] of LongWord;
  CRC32Poly: LongWord = $EDB88320;

procedure InitCRC32Table;
var I, J : Byte;
    R    : LongWord;
begin
  for I := $00 to $FF do
    begin
      R := I;
      for J := 8 downto 1 do
        if R and 1 <> 0 then
          R := (R shr 1) xor CRC32Poly else
          R := R shr 1;
      CRC32Table[I] := R;
    end;
  CRC32TableInit := True;
end;

procedure SetCRC32Poly(const Poly: LongWord);
begin
  CRC32Poly := Poly;
  CRC32TableInit := False;
end;

function CalcCRC32Byte(const CRC32: LongWord; const Octet: Byte): LongWord; {$IFDEF UseInline}inline;{$ENDIF}
begin
  Result := CRC32Table[Byte(CRC32) xor Octet] xor ((CRC32 shr 8) and $00FFFFFF);
end;

function CRC32Update(const CRC32: LongWord; const Octet: Byte): LongWord;
begin
  if not CRC32TableInit then
    InitCRC32Table;

  Result := CalcCRC32Byte(CRC32, Octet);
end;

function CRC32Update(const CRC32: LongWord; const Buf;
  const BufSize: Integer): LongWord;
var P : PByte;
    I : Integer;
begin
  if not CRC32TableInit then
    InitCRC32Table;
  P := @Buf;
  Result := CRC32;
  for I := 1 to BufSize do
    begin
      Result := CalcCRC32Byte(Result, P^);
      Inc(P);
    end;
end;

function CRC32UpdateNoCase(const CRC32: LongWord; const Buf;
  const BufSize: Integer): LongWord;
var P : PByte;
    I : Integer;
    C : Byte;
begin
  if not CRC32TableInit then
    InitCRC32Table;
  P := @Buf;
  Result := CRC32;
  for I := 1 to BufSize do
    begin
      C := P^;
      if AnsiChar(C) in ['A'..'Z'] then
        C := C or 32;
      Result := CalcCRC32Byte(Result, C);
      Inc(P);
    end;
end;

procedure CRC32Init(var CRC32: LongWord);
begin
  CRC32 := $FFFFFFFF;
end;

function CRC32FromBuffer(const Buf; const BufSize: Integer): LongWord;
begin
  CRC32Init(Result);
  Result := not CRC32Update(Result, Buf, BufSize);
end;

function CRC32FromString(const S: String): LongWord;
begin
  Result := CRC32FromBuffer(Pointer(S)^, Length(S));
end;

function CRC32ToString(const CRC32: LongWord; UpperCase: Boolean): String;
begin
  Result := IntToHex(CRC32, 8);

  if not UpperCase then
    Result := LowerCase(Result);
end;

end.
