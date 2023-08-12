//------------------------------------------------------------------------------
// Windows System Control Center 4.x (WSCC4) Keygen
//
// Product homepage: https://www.kls-soft.com/wscc
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
  MD5,
  SysUtils;

//------------------------------------------------------------------------------
// UPDATED: 2020-07-09 - WSCC 4.0.5.3
//------------------------------------------------------------------------------

function GenerateRegCode(const Name: String): String;
const
  Charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
  S: String;
  I: Integer;
begin
  SetLength(Result, 35);

  for I := 1 to 35 do
    Result[I] := Charset[Random(Length(Charset)) + 1];

  // Chars for name hash check

  S := MD5ToString(MD5FromString(Name + 'WSCC41'), True);
  Result[26] := S[11];
  S := MD5ToString(MD5FromString(Name + 'WSCC43'), True);
  Result[35] := S[16];
  S := MD5ToString(MD5FromString(Name + 'WSCC430'), True);
  Result[4] := S[10];
  S := '';

  for I := 1 to 35 do
    if not (I in [3, 15, 33]) then
      S := S + Result[I];

  S := MD5ToString(MD5FromString(S), True);

  // Chars for regcode hash check

  Result[3] := S[11];
  Result[15] := S[29];
end;

//------------------------------------------------------------------------------

var
  Name: String;
  
begin
  Randomize;

  WriteLn('Windows System Control Center 4.x (WSCC4) Keygen [by RadiXX11]');
  WriteLn('==============================================================');
  WriteLn;

  Write('Name.............: ');
  ReadLn(Name);

  if Trim(Name) <> '' then
    WriteLn('Registration Code: ', GenerateRegCode(Name));

  WriteLn;

  ReadLn;
end.
