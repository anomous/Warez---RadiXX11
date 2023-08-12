//------------------------------------------------------------------------------
// HDD Low Level Format Tool 4.x Keygen
// Product homepage: http://hddguru.com
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
  SysUtils;

//------------------------------------------------------------------------------

type
  TLicenseType = (
    ltCommercial,
    ltHome    
  );

const
  Charset = '2345689QWERTYUPASDFHGJKLZXCVBNM';

//------------------------------------------------------------------------------

function GenerateLicenseCode(LicenseType: TLicenseType): String;
var
  I, Total: Integer;
begin
  SetLength(Result, 16);

  if LicenseType = ltHome then
    Total := 60
  else
    Total := 62;

  repeat
    for I := 1 to 16 do
      Result[I] := Charset[Random(Length(Charset)) + 1];
  until (Pos(Result[2], Charset) + Pos(Result[3], Charset) +
        Pos(Result[14], Charset) + Pos(Result[15], Charset)) = Total;

  for I := 15 downto 0 do
    if (I > 0) and ((I mod 4) = 0) then
      Insert('-', Result, I + 1);
end;

//------------------------------------------------------------------------------

var
  Code: String;
  Option: Char;

begin
  Randomize;

  WriteLn('==================================================');
  WriteLn('HDD Low Level Format Tool 4.x Keygen [by RadiXX11]');
  WriteLn('==================================================');
  WriteLn;

  repeat
    WriteLn('---------------------');
    WriteLn('1. Commercial License');
    WriteLn('2. Home License');
    WriteLn('0. Exit');
    WriteLn('---------------------');
    Write('Option: ');
    ReadLn(Option);
  until Option in ['0'..'2'];

  WriteLn;

  case Option of
    '1': Code := GenerateLicenseCode(ltCommercial);
    '2': Code := GenerateLicenseCode(ltHome);
  else
    Exit;
  end;

  WriteLn('License Code: ', Code);
  WriteLn;
  WriteLn('Press ENTER to exit...');

  ReadLn;
end.
 