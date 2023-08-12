//------------------------------------------------------------------------------
// Focus Magic Keygen
//
// Product homepage: https://www.focusmagic.com
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
  Windows,
  SysUtils;

//------------------------------------------------------------------------------

const
  Data: array[0..9] of PChar = (
    '7615804293',
    '7816934250',
    '7650239418',
    '0912358647',
    '8932106754',
    '3982015674',
    '1390487625',
    '3190267854',
    '3105867942',
    '6584103297'
  );

//------------------------------------------------------------------------------

function GetNameHash(const Name: String): String;
var
  I: Integer;
  C: Byte;
begin
  Result := '';

  for I := 1 to Length(Name) do
  begin
    C := Ord(Name[I]);

    if C > 96 then
      Inc(C, 224);

    if Byte(C - 65) <= 25 then
      C := Byte((C - 64) mod 10) + 48
    else
      C := 48;

    Result := Result + Chr(C);
  end;
end;

//------------------------------------------------------------------------------

function GetValue(X, Y: Byte): Byte;
begin
  if (X <= 9) and (Y <= 9) then
    Result := Ord(Data[Y][X]) - 48
  else
    Result := 0;
end;

//------------------------------------------------------------------------------

function GenerateRegCode(const Name: String): String;
var
  ST: SYSTEMTIME;
  Digit: array[0..4] of Byte;
  I: Integer;
  A, B, C, D, Z: Byte;
begin
  Result := '';

  GetLocalTime(ST);
  Z := ST.wYear mod 10;

  repeat
    Digit[4] := Random(10);
    Digit[0] := Random(10);
    A := GetValue(Digit[0], Digit[4]);
    Digit[1] := Random(10);
    B := GetValue(Digit[1], Digit[4]);
    Digit[2] := Random(10);
    C := GetValue(Digit[2], Digit[4]);
    Digit[3] := Random(10);
    D := GetValue(Digit[3], Digit[4]);
  until (A = 1) and (B = Z) and ((((C + C * 4) * 2) + D) = ST.wMonth);

  for I := 0 to 4 do
    Result := Result + Chr(Digit[I] + 48);

  if Length(Name) = 4 then
    Result := Result + GetNameHash(Name)
  else
    Result := GetNameHash(Name) + Result;
end;

//------------------------------------------------------------------------------

var
  Name: String;

begin
  Randomize;

  WriteLn('Focus Magic Keygen [by RadiXX11]');
  WriteLn('================================');
  WriteLn;

  Write('User Name: ');
  ReadLn(Name);

  if Trim(Name) <> '' then
    WriteLn('Reg Code : ', GenerateRegCode(Name));

  ReadLn;
end.

