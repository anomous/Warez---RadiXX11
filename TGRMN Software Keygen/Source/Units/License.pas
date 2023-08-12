//------------------------------------------------------------------------------
// TGRMN Software Keygen
//
// Products homepages:
// - https://www.bulkrenameutility.co.uk
// - https://www.tgrmn.com
//
// © 2020, RadiXX11
// https://radixx11rce2.blogspot.com
//
// DISCLAIMER: This source code is distributed AS IS, for educational purposes
// ONLY. No other use is permitted without expressed permission from the author.
//------------------------------------------------------------------------------

unit License;

interface

type
  TProductVersion = (
    pvVer20,
    pvVer25,
    pvVer30
  );

  TKeyMaker = function(const Text: String; ProductVer: TProductVersion;
                var Key: String): Boolean;

  TProductInfo = record
    Name: String;
    Homepage: String;
    KeyMaker: TKeyMaker;
  end;

// License key generator for each app
function GetLicenseKeyBRU(const Text: String; ProductVer: TProductVersion;
  var Key: String): Boolean;
function GetLicenseKeyVV(const Text: String; ProductVer: TProductVersion;
  var Key: String): Boolean;

const
  ProductList: array[0..1] of TProductInfo = (
    (
      Name: 'Bulk Rename Utility 3.x';
      Homepage: 'https://www.bulkrenameutility.co.uk';
      KeyMaker: GetLicenseKeyBRU
    ),
    (
      Name: 'ViceVersa PRO 3.x';
      Homepage: 'https://www.tgrmn.com';
      KeyMaker: GetLicenseKeyVV
    )
  );

implementation

uses
  CRC32,
  MD5,
  StrUtils,
  SysUtils;

//------------------------------------------------------------------------------

function CharCount(C: Char; const S: String): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length(S) do
    if S[I] = C then
      Inc(Result);
end;

//------------------------------------------------------------------------------

function GetLicenseKeyBRU(const Text: String; ProductVer: TProductVersion;
  var Key: String): Boolean;
var
  Arr: array[0..13] of Integer;
  S: String;
  L: LongWord;
  I, J, K, Sum, Value: Integer;
begin
  Result := False;
  S := Trim(Text);

  if Length(S) < 6 then
  begin
    Key := 'Text must have at least 6 chars';
    Exit;
  end;

  // A check for the following requirement is randomly performed in the program
  // so we must ensure that it will be always passed.

  if Pos('B', S) = 0 then
  begin
    Key := 'Text must contain an uppercase letter B on any place';
    Exit;
  end;

  S := StringReplace(LowerCase(S), ' ', '', [rfReplaceAll]);
  Sum := 0;

  for I := 1 to Length(S) do
    Inc(Sum, Ord(S[I]));

  Value := 25;

  if ProductVer <> pvVer30 then
    Value := 22;

  Value := Value - Length(S) + Sum;
  S := Format('%s%u%d', [S, CRC32FromString(S), Value]);
  S := ReverseString(S + IntToStr(Length(S)));
  J := 100 - Length(S);

  if J > 0 then
  begin
    for K := 0 to J - 1 do
      S := S + '#' + IntToStr(K);
  end;

  S := S + S;

  Arr[0] := CharCount('a', S);

  if Arr[0] > 9 then
    Arr[0] := 9;

  Arr[1] := CharCount('e', S);

  if Arr[1] > 9 then
    Arr[1] := 9;

  Arr[2] := CharCount('s', S);

  if Arr[2] > 9 then
    Arr[2] := 9;

  Arr[3] := CharCount('i', S);

  if Arr[3] > 9 then
    Arr[3] := 9;

  Arr[4] := CharCount('c', S);

  if Arr[4] > 9 then
    Arr[4] := 9;

  Arr[5] := CharCount('o', S);

  if Arr[5] > 9 then
    Arr[5] := 9;

  Arr[6] := CharCount('v', S);

  if Arr[6] > 9 then
    Arr[6] := 9;

  Arr[7] := CharCount('1', S);

  if Arr[7] > 9 then
    Arr[7] := 9;

  Arr[8] := CharCount('g', S);

  if Arr[8] > 9 then
    Arr[8] := 9;

  Arr[9] := CharCount('n', S);

  if Arr[9] > 9 then
    Arr[9] := 9;

  Arr[10] := CharCount('0', S);

  if Arr[10] > 9 then
    Arr[10] := 9;

  if ProductVer = pvVer30 then
  begin
    Arr[11] := CharCount('2', S);

    if Arr[11] > 9 then
      Arr[11] := 9;

    Arr[12] := CharCount('3', S);

    if Arr[12] > 9 then
      Arr[12] := 9;

    Arr[13] := 0;
  end
  else
  begin
    Arr[11] := 0;
    Arr[12] := 0;
    Arr[13] := Arr[0];
  end;

  S[96] := ':';
  S[3] := Chr(Arr[13] + 48);
  S[31] := '0';
  S[21] := Chr(Arr[5] + 48);
  S[10] := 'R';
  S[56] := Chr(Arr[2] + 48);
  S[26] := 'q';
  S[58] := Chr(Arr[3] + 48);
  S[30] := 'A';
  S[94] := Chr(Arr[4] + 48);
  S[61] := 'X';
  S[16] := Chr(Arr[6] + 48);
  S[41] := Chr(Arr[1] + 48);
  S[6] := Chr(Arr[8] + 48);
  S[2] := Chr(Arr[9] + 48);
  S[46] := Chr(Arr[10] + 48);

  if ProductVer = pvVer30 then
  begin
    S[30] := 'K';
    S[46] := Chr(Arr[11] + 48);
    S[26] := Chr(Arr[12] + 48);
    S[61] := ':';
  end;

  L := CRC32FromString(S);

  if ProductVer = pvVer30 then
    L := CRC32FromString(Format('%u', [CRC32FromString(Format('%u%sBRU-BRU', [L, S]))]));

  Key := Format('%u', [L]);

  Insert('-', Key, 4);
  Insert('-', Key, 8);

  if ProductVer = pvVer30 then
    Key := Key + Format('BRU-%dK', [Value]);

  Result := True;
end;

//------------------------------------------------------------------------------

function GetLicenseKeyVV(const Text: String; ProductVer: TProductVersion;
  var Key: String): Boolean;
var
  Arr: array[0..10] of Integer;
  S: String;
  L: LongWord;
  I, J, K, Sum, Value: Integer;
begin
  Result := False;
  S := Trim(Text);

  if Length(S) < 6 then
  begin
    Key := 'Text must have at least 6 chars';
    Exit;
  end;

  // App version 2.5 and 3.X only will check for the following requirement.
  
  if (ProductVer in [pvVer25, pvVer30]) and (Pos('vv', S) = 0) then
  begin
    Key := 'Text must contain "vv" (without quotes, in lowercase) on any place';
    Exit;
  end;

  S := StringReplace(LowerCase(S), ' ', '', [rfReplaceAll]);
  Sum := 0;

  for I := 1 to Length(S) do
    Inc(Sum, Ord(S[I]));

  Value := 15 - Length(S) + Sum;

  if ProductVer = pvVer25 then
    Inc(Value, 15)
  else if ProductVer = pvVer30 then
    Inc(Value, 19);

  S := Format('%s%u%d', [S, CRC32FromString(S), Value]);
  S := ReverseString(S + IntToStr(Length(S)));
  J := 100 - Length(S);

  if J > 0 then
  begin
    for K := 0 to J - 1 do
      S := S + '#' + IntToStr(K);
  end;

  S := S + S;

  Arr[0] := CharCount('a', S);

  if Arr[0] > 9 then
    Arr[0] := 9;

  Arr[1] := CharCount('h', S);

  if Arr[1] > 9 then
    Arr[1] := 9;

  Arr[2] := CharCount('e', S);

  if Arr[2] > 9 then
    Arr[2] := 9;

  Arr[3] := CharCount('s', S);

  if Arr[3] > 9 then
    Arr[3] := 9;

  Arr[4] := CharCount('i', S);

  if Arr[4] > 9 then
    Arr[4] := 9;

  Arr[5] := CharCount('c', S);

  if Arr[5] > 9 then
    Arr[5] := 9;

  Arr[6] := CharCount('o', S);

  if Arr[6] > 9 then
    Arr[6] := 9;

  Arr[7] := CharCount('v', S);

  if Arr[7] > 9 then
    Arr[7] := 9;

  Arr[8] := CharCount('1', S);

  if Arr[8] > 9 then
    Arr[8] := 9;

  if ProductVer = pvVer25 then
  begin
    Arr[9] := CharCount('0', S);

    if Arr[9] > 9 then
      Arr[9] := 9;
  end
  else
    Arr[9] := 0;

  if ProductVer = pvVer30 then
  begin
    Arr[9] := CharCount('2', S);

    if Arr[9] > 9 then
      Arr[9] := 9;

    Arr[10] := CharCount('v', S) + 1;

    if Arr[10] > 9 then
      Arr[10] := 9;
  end
  else
    Arr[10] := Arr[7];

  S[3] := Chr(Arr[0] + 48);
  S[6] := Chr(Arr[1] + 48);
  S[21] := Chr(Arr[6] + 48);
  S[56] := Chr(Arr[3] + 48);
  S[16] := Chr(Arr[10] + 48);
  S[58] := Chr(Arr[4] + 48);
  S[41] := Chr(Arr[2] + 48);
  S[10] := 'X';
  S[94] := Chr(Arr[5] + 48);
  S[96] := ':';
  S[31] := Chr(Arr[8] + 48);

  if ProductVer = pvVer25 then
  begin
    S[46] := Chr(Arr[9] + 48);
    S[61] := 'x';
  end
  else if ProductVer = pvVer30 then
  begin
    S[46] := Chr(Arr[9] + 48);
    S[59] := 'x';
    S[61] := 'y';
    S := S + MD5ToString(MD5FromString(S));
  end;

  L := CRC32FromString(S);
  Key := Format('%u', [L]);

  Insert('-', Key, 4);
  Insert('-', Key, 8);

  case ProductVer of
    pvVer20:  Key := Key + Format('PRO2-%d', [Value]);
    pvVer25:  Key := Key + Format('PRO25-%d', [Value]);
    pvVer30:  Key := Key + Format('PRO3-%d', [Value]);
  end;

  Result := True;
end;

end.
 