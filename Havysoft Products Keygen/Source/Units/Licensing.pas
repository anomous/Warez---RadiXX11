unit Licensing;

interface

type
  TProductInfo = record
    Name: String;
    Hint: String;
    KeyParams: array[0..2] of Byte;
  end;

const
  ProductList: array[0..1] of TProductInfo = (
    (
      Name: 'InnoExtractor';
      Hint: '1. Copy the generated key.'#13#10 +
            '2. Go to "Help"->"Donate to Upgrade to Plus..."'#13#10 +
            '3. Hit Ctrl + Alt + Shift + I and paste the generated key in the "Donation Key" box.'#13#10 +
            '4. Done.';
      KeyParams: (2, 3, 0);
    ),
    (
      Name: 'MassTube';
      Hint: '1. Copy the generated key.'#13#10 +
            '2. Go to "Help"->"Donate to Upgrade to Plus..."'#13#10 +
            '3. Hit Ctrl + Alt + Shift + M and paste the generated key in the "Donation Key" box.'#13#10 +
            '4. Done.';
      KeyParams: (3, 3, 1);
    )
  );

function GenerateKey(const ProductInfo: TProductInfo): String;

implementation

uses
  SysUtils;

//-----------------------------------------------------------------------------

var
  CRC32Table: array[Byte] of LongWord;
  CRC32TableInit: Boolean = False;

//------------------------------------------------------------------------------

procedure InitCRC32Table;
const
  CRC32Poly: LongWord = $EDB88320;
var
  R: LongWord;
  I, J: Byte;
begin
  for I := $00 to $FF do
  begin
    R := I;

    for J := 8 downto 1 do
      if R and 1 <> 0 then
        R := (R shr 1) xor CRC32Poly
      else
         R := R shr 1;

    CRC32Table[I] := R;
  end;

  CRC32TableInit := True;
end;

//------------------------------------------------------------------------------

function GetCRC32(Buffer: PChar; Len: Integer): LongWord;
var
  I: Integer;
begin
  Result := $FFFFFFFF;

  if not CRC32TableInit then
    InitCRC32Table;

  for I := 0 to Len - 1 do
    Result := CRC32Table[Byte(Result) xor Byte(Buffer[I])] xor (Result shr 8);
end;

//------------------------------------------------------------------------------

function GetChecksum(const S: String; V1, V2, V3: Byte): String;
var
  S4: WideString;
  S1, S2, S3: String;
  I: Integer;
begin
  S1 := '';
  S2 := '';

  for I := 1 to Length(S) do
    if (I mod V1) = 1 then
      S1 := S1 + S[I]
    else
      S2 := S2 + S[I];

  if V3 <> 0 then
    S3 := S1 + S2
  else
    S3 := S2 + S1;

  S4 := UTF8Decode(S3);
  S3 := IntToHex(GetCRC32(@S4[1], Length(S3)), 8);
  S1 := '';
  S2 := '';

  for I := 1 to Length(S3) do
    if (I mod V2) = 1 then
      S1 := S1 + S3[I]
    else
      S2 := S2 + S3[I];

  Result := S1 + S2
end;

//------------------------------------------------------------------------------

function GenerateKey(const ProductInfo: TProductInfo): String;
const
  Charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
var
  I, J, K: Integer;
  C: Char;
begin
  repeat
    Result := '';
    J := 0;
    K := 0;

    for I := 1 to 16 do
    begin
      C := Charset[Random(Length(Charset)) + 1];

      if C = Chr(Ord(C) and $DF) then
        Inc(J);

      if C in ['a', 'e', 'i', 'o', 'u'] then
        Inc(K);

      Result := Result + C;
    end;
  until (J >= 2) and (J <= 4) and (K > 2);

  Result := Result + '-' + GetChecksum(Result, ProductInfo.KeyParams[0],
                            ProductInfo.KeyParams[1], ProductInfo.KeyParams[2]);
end;

end.
 