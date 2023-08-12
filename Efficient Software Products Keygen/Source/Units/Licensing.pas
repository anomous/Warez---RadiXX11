unit Licensing;

interface

type
  TProductInfo = record
    Name: String;
    Id: String;
    Code: Word;
    Key: Byte;
  end;

const
  ProductCount = 11;
  ProductList: array[0..ProductCount - 1] of TProductInfo = (
    (
      Name: 'Efficient Address Book';
      Id: 'EAB';
      Code: 2;
      Key: $62;
    ),
    (
      Name: 'Efficient Calendar';
      Id: 'EC';
      Code: 3;
      Key: $63;
    ),
    (
      Name: 'Efficient Diary Pro';
      Id: 'ED';
      Code: 6;
      Key: $66;
    ),
    (
      Name: 'Efficient Efficcess/PIM';
      Id: 'EP';
      Code: 1;
      Key: $61;
    ),
    (
      Name: 'Efficient Lady''s Organizer';  // Added 2019-05-13
      Id: 'ELO';
      Code: 10;
      Key: $6A;
    ),
    (
      Name: 'Efficient Man''s Organizer';   // Added 2019-05-13
      Id: 'EMO';
      Code: 10;
      Key: $6A;
    ),
    (
      Name: 'Efficient Notes';
      Id: 'EN';
      Code: 7;
      Key: $67;
    ),
    (
      Name: 'Efficient Password Manager Pro';
      Id: 'EPM';
      Code: 9;
      Key: $69;
    ),
    (
      Name: 'Efficient Reminder';
      Id: 'ER';
      Code: 4;
      Key: $64;
    ),
    (
      Name: 'Efficient Sticky Notes Pro';
      Id: 'ESN';
      Code: 8;
      Key: $68;
    ),
    (
      Name: 'Efficient ToDo List';
      Id: 'ETDL';
      Code: 5;
      Key: $65;
    )
  );

function GenerateRegCode(const ProductInfo: TProductInfo;
  LicValidity, AuthUsers: Word; NetworkEdition: Boolean): String;

implementation

uses
  StrUtils,
  SysUtils;

//------------------------------------------------------------------------------

function RandomHexStr(Len: Integer): String;
const
  Charset = '0123456789ABCDEF';
var
  I: Integer;
begin
  SetLength(Result, Len);

  for I := 1 to Len do
    Result[I] := Charset[Random(Length(Charset)) + 1];
end;

//------------------------------------------------------------------------------

function Encode1(const S: String): String;
var
  I: Integer;
begin
  Result := '';

  for I := 1 to (Length(S) div 2) do
    Result := Result + Char(StrToInt('$' + Copy(S, (I - 1) * 2 + 1, 2)));
end;

//------------------------------------------------------------------------------

function Encode2(const Data: String; Value1, Value2, Value3: Integer): String;
var
  S: String;
  I, J, K, L, M: Integer;
begin
  Result := '';
  S := '';
  K := Value1 - Value2 + 1;
  L := Value3 mod K;
  M := 2 * Value3 mod K;

  for I := 1 to Length(Data) do
  begin
    if (I and $80000001) <> 0 then
      S := S + IntToHex(Integer((M + Ord(Data[I]) - Value2) mod K + Value2), 1)
    else
      S := S + IntToHex(Integer((Ord(Data[I]) + L - Value2) mod K + Value2), 1);
  end;

  S := ReverseString(Encode1(S));
  J := 1;

  for I := 1 to Length(S) - 22  do
  begin
    Result := Result + S[J + 1] + S[J + 2] + S[J];
    Inc(J, 3);
  end;

  Result := Result + S[31] + S[32];
end;

//------------------------------------------------------------------------------

function Encode3(const S: String; Value: Integer): String;
var
  I: Integer;
begin
  Result := '';

  for I := 1 to Length(S) do
  begin
    if Byte(Ord(S[I]) - 48) >= 10 then
      Result := Result + IntToHex(Ord(S[I]), 1)
    else
      Result := Result + IntToHex(Ord(S[I]) + 23, 1);
  end;

  Result := Encode2(Encode1(Result), 80, 65, Value);
end;

//------------------------------------------------------------------------------

function GenerateRegCode(const ProductInfo: TProductInfo;
  LicValidity, AuthUsers: Word; NetworkEdition: Boolean): String;
var
  Flags: Byte;
begin
  if (LicValidity = 0) or (AuthUsers = 0) then
  begin
    Result := '';
    Exit;
  end;

  if NetworkEdition then
    Flags := 3
  else
    Flags := 2;

  Result := IntToHex(StrToInt64(FormatDateTime('yyyymmdd', Date)), 7) +
            IntToHex(LicValidity, 4) + IntToHex(ProductInfo.Code, 4) +
            IntToHex(Flags, 1) + IntToHex(AuthUsers, 4) + RandomHexStr(12);
  Result := ProductInfo.Id + '-' + Encode3(Result, ProductInfo.Key);
end;

end.
