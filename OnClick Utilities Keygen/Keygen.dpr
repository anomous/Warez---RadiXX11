//------------------------------------------------------------------------------
// OnClick Utilities Keygen
//
// Product homepage: https://www.2brightsparks.com/onclick/index.html
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
  CRC32,
  SysUtils;

//------------------------------------------------------------------------------

function GenerateSerial: String;
const
  Charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
  S1, S2: String;
  I: Integer;
begin
  SetLength(S1, 8);

  for I := 1 to 8 do
    S1[I] := Charset[Random(Length(Charset)) + 1];

  S2 := CRC32ToString(CRC32FromString('fkfg785474JGHJ744HGFJUe8e594ed' + S1), True);

  SetLength(Result, 19);

  Result[1] := S1[1];
  Result[3] := S1[2];
  Result[6] := S1[3];
  Result[8] := S1[4];
  Result[11] := S1[5];
  Result[13] := S1[6];
  Result[16] := S1[7];
  Result[18] := S1[8];
  Result[2] := S2[1];
  Result[4] := S2[2];
  Result[7] := S2[3];
  Result[9] := S2[4];
  Result[12] := S2[5];
  Result[14] := S2[6];
  Result[17] := S2[7];
  Result[19] := S2[8];
  Result[5] := '-';
  Result[10] := '-';
  Result[15] := '-';
end;

//------------------------------------------------------------------------------

begin
  Randomize;

  WriteLn('OnClick Utilities Keygen [by RadiXX11]');
  WriteLn('======================================');
  WriteLn;
  WriteLn('Serial: ', GenerateSerial);

  ReadLn;
end.
 