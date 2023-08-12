program Keygen;

{$APPTYPE CONSOLE}

uses
  SysUtils;

//------------------------------------------------------------------------------
// The following function was extracted from reggen4.pas, part of the freeware
// component for Delphi called TRegware4 (©2003 - WAK Productions), which is
// used by the target app for licensing.
//------------------------------------------------------------------------------

function GenerateCode(LicenseID: string; ExpireDate: TDateTime): string;
const
  FMaxChars: Integer = 50;
  FMinChars: Integer = 5;
  FRegCodeSize: Integer = 20;
  FSeed1: Integer = 114714403;
  FSeed2: Integer = 127144186;
  FSeed3: Integer = 30777866;
  SEED_D = $45B7;
var
  S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, STMP: string;
  V1, V2, V3, I1, I2: integer;
  Month, Day, Year: Word;
begin
  Result := '';
  if (Length(LicenseID) > FMaxChars) or (Length(LicenseID) < FMinChars) then Exit;

  //---- Encode Expiration Date ------------------------------------------
  if ExpireDate > 0 then
  begin
    DecodeDate(ExpireDate, Year, Month, Day);
  end else
  begin
    // Make expiration date of 0/00/0000 (no expiration)
    DecodeDate(0, Year, Month, Day);
  end;

  V1 := integer(Month) xor SEED_D and $000F;
  V2 := integer(Day)   xor SEED_D and $00FF;
  V3 := integer(Year)  xor SEED_D and $0FFF;

  S2 := IntToHex(V1, 1);  // Encoded month

  STMP := IntToHex(V2, 4);  // Encoded day
  S10 := STMP[3];
  S8 := STMP[4];

  STMP := IntToHex(V3, 4);  // Encoded year
  S4 := STMP[2];
  S6 := STMP[3];
  S12 := STMP[4];

  //---- Encode Segment 1 (chars #1,3,5) ---------------------------------
  V3 := Length(LicenseID);
  V1 := Ord(LicenseID[1]) + Ord(LicenseID[2]) + Ord(LicenseID[Trunc(V3 / 2)]) +
        Ord(LicenseID[V3]) + Ord(LicenseID[V3 - 1]);
  //V1 := V1 div 4;
  V2 := (FSeed1 mod V1) and $00FF;
  STMP := IntToHex(V2, 4);
  S1 := STMP[3];
  S3 := STMP[4];

  V1 := Length(LicenseID);
  if V1 > 16 then STMP := '0000' else STMP := IntToHex(V1, 4);
  S5 := STMP[4];

  //---- Encode Segment 2 (chars #7,9,11) --------------------------------
  V1 := 0;
  for I1 := 1 to Length(LicenseID) do
    V1 := V1 + Ord(LicenseID[I1]);
  V1 := ((V1 shl 4 xor FSeed2) and $0FFF);
  STMP := IntToHex(V1, 4);
  S7 := STMP[2];
  S9 := STMP[3];
  S11 := STMP[4];

  //------------- Check segment 3 (chars #13...) ----------------------------
  V2 := 0;
  STMP := '';
  for I1 := 1 to Length(LicenseID) do
    V2 := V2 + Ord(LicenseID[I1]);
  V2 := V2 * ($7FFFFFF div V2);
  I2 := 31;
  for I1 := 1 to 32 do
  begin
    // Rotates the bits in FSeed3 through shifting,
    // but bits that fall off are moved to the other end
    V3 := (FSeed3 shl I1) or (FSeed3 shr I2) and $7FFFFFFF;
    V3 := abs(V3);
    if V3 > V2 then
      V1 := V3 mod V2
    else
      V1 := V2 mod V3;
    STMP := STMP + IntToHex($00000FFF and V1, 3);
    Dec(I2);
  end;
  // Take only the characters needed
  //Delete(STMP, RegCodeSize - 11, Length(STMP) - RegCodeSize - 11);
  S13 := Copy(STMP, 1, FRegCodeSize - 12);

  Result := S1+S2+S3+S4+S5+S6+S7+S8+S9+S10+S11+S12+S13;
end;

var
  Name: String;

begin
  // SynthFont2 - http://www.synthfont.com

  WriteLn('SynthFont2 Keygen [by RadiXX11]');
  WriteLn('===============================');
  WriteLn;

  Write('Reg Name: ');
  ReadLn(Name);

  if Trim(Name) <> '' then
    WriteLn('Reg Code: ', GenerateCode(Name, 0));

  ReadLn;
end.
