program Keygen;

{$APPTYPE CONSOLE}

uses
  SysUtils;

//------------------------------------------------------------------------------

const
  Charset = '23456789ABCDEFGHJKMNPQRSTUVWXYZ01ILO-,.qwertyuiopasdfghjklzxcvbnm?<> ():/\';

//------------------------------------------------------------------------------

function StringHash1(const S: String): LongWord;
var
  I: Integer;
begin
  Result := $4E67C6A7;
  for I := 1 to Length(S) do
    Result := Result xor ((Result shr 2) + 32 * Result + Ord(S[I]));
end;

//------------------------------------------------------------------------------

function StringHash2(const S: String): LongWord;
var
  I, J, K: Integer;
begin
  Result := 0;
  for I := 1 to Length(S) do
  begin
    J := 16 * Result + Ord(S[I]);
    K := J and $F0000000;

    if K <> 0 then
      J := J xor (K shr 24);

    Result := not K and J;
  end;
end;

//------------------------------------------------------------------------------

function EncodeValue1(Value: LongWord): String;
var
  I, J: LongWord;
begin
  Result := '';

  repeat
    I := Value div 31;
    J := Value mod 31;
    Value := I;
    Result := Charset[J + 1] + Result;
  until I < 32;

  if (I > 0) and (I < 32) then
    Result := Charset[I + 1] + Result;
end;

//------------------------------------------------------------------------------

function EncodeValue2(Value: LongWord): String;
begin
  Result := EncodeValue1(Value);

  while Length(Result) < 7 do
    Result := Result + EncodeValue1(27);

  Result := Copy(Result, 1, 7);
end;

//------------------------------------------------------------------------------

function GetIndexInCharset(C: Char): Integer;
begin
  Result := Pos(C, Charset);
end;

//------------------------------------------------------------------------------

function GenerateKey(const Name, Company: String;
  const ReleaseDate: TDateTime): String;
var
  I, Y, M, D: Word;
begin
  DecodeDate(ReleaseDate, Y, M, D);

  Result := Charset[M] + Charset[D] + Charset[Y - 2000];

  if Random(10) < 5 then
    Result := Result + 'D'
  else
    Result := Result + 'E';

  Result := Result + 'F' + EncodeValue2(StringHash2(Name + '*' + Company)) + '3';

  for I := 1 to 5 do
    Result := Result + Charset[Random(31) + 1];

  Result := EncodeValue2(StringHash1(Result)) + Result;

  Insert('-', Result, 6);
  Insert('-', Result, 12);
  Insert('-', Result, 18);
  Insert('-', Result, 24);
end;

//------------------------------------------------------------------------------

var
  Name, Company, Key: String;

begin
  // Document Converter Pro - https://neevia.com

  Randomize;

  WriteLn('Neevia Document Converter Pro 7.x Keygen [by RadiXX11]');
  WriteLn('======================================================');
  WriteLn;

  Write('Name...: ');
  ReadLn(Name);

  if Trim(Name) <> '' then
  begin
    Write('Company: ');
    ReadLn(Company);

    if Trim(Company) <> '' then
    begin
      // Important: Don't modify the release date
      Key := GenerateKey(Name, Company, EncodeDate(2018, 6, 24));

      WriteLn('Key....: ', Key);
      ReadLn;
    end;
  end;
end.
