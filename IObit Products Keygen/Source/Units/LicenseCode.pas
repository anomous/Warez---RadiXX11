//==============================================================================
// License codes generation
//------------------------------------------------------------------------------
// IObit Products Keygen
// © 2016, RadiXX11
//------------------------------------------------------------------------------
// DISCLAIMER
//
// This program is provided "AS IS" without any warranty, either expressed or
// implied, including, but not limited to, the implied warranties of
// merchantability and fitness for a particular purpose.
//
// This program and its source code are distributed for educational and
// practical purposes ONLY.
//
// You are not allowed to get a monetary profit of any kind through its use.
//
// The author will not take any responsibility for the consequences due to the
// improper use of this program and/or its source code.
//==============================================================================

unit LicenseCode;

interface

type
  // Function types for license code generation/verification
  TGenerateCodeFunction = function(Version: Integer): String;
  TVerifyCodeFunction = function(const Code: String; Version: Integer): Boolean;

type
  // Information needed about each product
  TProductInfo = record
    Name: String;           // <--- name of the product
    Host: String;           // <--- host address used for license verification
    Version: Integer;       // <--- major version of the product
    GenerateCode: TGenerateCodeFunction;  // pointer to generation function
    VerifyCode: TVerifyCodeFunction;      // pointer to verification function
  end;


// functions used for license codes generation
function GenerateCodeForAdvancedSystemCare(Version: Integer): String;
function GenerateCodeForAdvancedSystemCareUltimate(Version: Integer): String;
function GenerateCodeForDriverBooster(Version: Integer): String;
function GenerateCodeForiFreeUp(Version: Integer): String;
function GenerateCodeForMalwareFighter(Version: Integer): String;
function GenerateCodeForProtectedFolder(Version: Integer): String;
function GenerateCodeForSmartDefrag(Version: Integer): String;
function GenerateCodeForStartMenu8(Version: Integer): String;
function GenerateCodeForUninstaller(Version: Integer): String;

{$IFDEF DEBUG}
// these functions are provided only for debugging purposes
function IsCodeForAdvancedSystemCare(const Code: String; Version: Integer): Boolean;
function IsCodeForAdvancedSystemCareUltimate(const Code: String; Version: Integer): Boolean;
function IsCodeForDriverBooster(const Code: String; Version: Integer): Boolean;
function IsCodeForiFreeUp(const Code: String; Version: Integer): Boolean;
function IsCodeForMalwareFighter(const Code: String; Version: Integer): Boolean;
function IsCodeForProtectedFolder(const Code: String; Version: Integer): Boolean;
function IsCodeForSmartDefrag(const Code: String; Version: Integer): Boolean;
function IsCodeForStartMenu8(const Code: String; Version: Integer): Boolean;
function IsCodeForUninstaller(const Code: String; Value: Integer): Boolean;
{$ENDIF}

implementation

uses
  MD5,
  SysUtils;

//------------------------------------------------------------------------------
//  -1 = INVALID LICENSE
//   0 = LIFETIME LICENSE
//   1 = GIVEAWAY LICENSE
//   2 = 1 YEAR LICENSE
//------------------------------------------------------------------------------
function GetLicenseKeyType(const Key: String): Integer;
var
  S: String;
begin
  Result := -1;

  S := StringReplace(Key, '-', '', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, ' ', '', [rfReplaceAll, rfIgnoreCase]);
  S := LowerCase(S);

  if Length(S) = 20 then
  begin
    if S[20] in ['0','1','4','5','8','9','c','d'] then
    begin
      if S[19] = '8' then
        Result := 0
      else
        Result := 1;
    end
    else if S[19] in ['e','f'] then
    begin
      if not (S[20] in ['a','b']) then
        Result := 0; // 1 year license?
    end
    else
      Result := 2;
  end;
end;

//------------------------------------------------------------------------------

function RandomHexStr(Len: Integer; UpperCase: Boolean = False): String;
const
  HexCharset = '0123456789abcdef';
var
  I: Integer;
begin
  Result := '';

  for I := 1 to Len do
    Result := Result + HexCharset[Random(Length(HexCharset)) + 1];

  if UpperCase then
    Result := SysUtils.UpperCase(Result);
end;

//------------------------------------------------------------------------------
// Functions for license code generation
//------------------------------------------------------------------------------

function GenerateCodeForAdvancedSystemCare(Version: Integer): String;
var
  S: array[0..4] of String;
  I: Integer;
begin
  Result := '';

  S[2] := RandomHexStr(5, True);
  S[3] := RandomHexStr(4, True);
  S[4] := 'B' + IntToStr(Version mod 10);
  S[0] := Copy(MD5ToString(MD5FromString(S[3]), True), 29, 4);
  S[1] := Copy(MD5ToString(MD5FromString(S[2]), True), 1, 5);

  for I := 0 to 4 do
    Result := Result + UpperCase(S[I]);

  Insert('-', Result, 6);
  Insert('-', Result, 12);
  Insert('-', Result, 18);
end;

//------------------------------------------------------------------------------

function GenerateCodeForAdvancedSystemCareUltimate(Version: Integer): String;
var
  S: array[0..4] of String;
  I: Integer;
begin
  Result := '';

  S[1] := RandomHexStr(4);
  S[3] := RandomHexStr(5);
  S[4] := '8' + IntToStr(Version mod 10);
  S[0] := Copy(MD5ToString(MD5FromString(S[1])), 29, 4);
  S[2] := Copy(MD5ToString(MD5FromString(S[3])), 1, 5);

  for I := 0 to 4 do
    Result := Result + UpperCase(S[I]);

  Insert('-', Result, 6);
  Insert('-', Result, 12);
  Insert('-', Result, 18);
end;

//------------------------------------------------------------------------------

function GenerateCodeForDriverBooster(Version: Integer): String;
var
  S: array[0..4] of String;
  I: Integer;
begin
  Result := '';

  S[2] := RandomHexStr(5);
  S[3] := RandomHexStr(4);
  S[4] := 'F' + IntToStr(Version mod 10);
  S[0] := Copy(MD5ToString(MD5FromString(S[2])), 1, 5);
  S[1] := Copy(MD5ToString(MD5FromString(S[3])), 29, 4);

  for I := 0 to 4 do
    Result := Result + UpperCase(S[I]);

  Insert('-', Result, 6);
  Insert('-', Result, 12);
  Insert('-', Result, 18);
end;

//------------------------------------------------------------------------------

function GenerateCodeForiFreeUp(Version: Integer): String;
var
  S: array[0..4] of String;
  I: Integer;
begin
  Result := '';

  S[0] := RandomHexStr(5);
  S[2] := RandomHexStr(4);
  S[1] := Copy(MD5ToString(MD5FromString(S[2])), 1, 4);
  S[3] := Copy(MD5ToString(MD5FromString(S[0])), 28, 5);
  S[4] := 'F' + IntToStr(Version mod 10);

  for I := 0 to 4 do
    Result := Result + UpperCase(S[I]);

  Insert('-', Result, 6);
  Insert('-', Result, 12);
  Insert('-', Result, 18);
end;

//------------------------------------------------------------------------------

function GenerateCodeForMalwareFighter(Version: Integer): String;
var
  S: array[0..4] of String;
  I: Integer;
begin
  Result := '';

  S[2] := RandomHexStr(4, True);
  S[3] := RandomHexStr(5, True);
  S[4] := 'F' + IntToStr(Version mod 10);
  S[0] := Copy(MD5ToString(MD5FromString(S[3]), True), 28, 5);
  S[1] := Copy(MD5ToString(MD5FromString(S[2]), True), 1, 4);

  for I := 0 to 4 do
    Result := Result + UpperCase(S[I]);

  Insert('-', Result, 6);
  Insert('-', Result, 12);
  Insert('-', Result, 18);
end;

//------------------------------------------------------------------------------

function GenerateCodeForProtectedFolder(Version: Integer): String;
var
  S: array[0..4] of String;
  I: Integer;
begin
  Result := '';

  S[2] := RandomHexStr(4, True);
  S[3] := RandomHexStr(5, True);
  S[4] := 'F' + IntToStr(Version mod 10);
  S[0] := Copy(MD5ToString(MD5FromString(S[2]), True), 29, 4);
  S[1] := Copy(MD5ToString(MD5FromString(S[3]), True), 1, 5);

  for I := 0 to 4 do
    Result := Result + UpperCase(S[I]);

  Insert('-', Result, 6);
  Insert('-', Result, 12);
  Insert('-', Result, 18);
end;

//------------------------------------------------------------------------------

function GenerateCodeForSmartDefrag(Version: Integer): String;
var
  S: array[0..4] of String;
  I: Integer;
begin
  Result := '';

  S[2] := RandomHexStr(4);
  S[3] := RandomHexStr(5);
  S[4] := 'F' + IntToStr(Version mod 10);
  S[0] := Copy(MD5ToString(MD5FromString(S[3])), 1, 5);
  S[1] := Copy(MD5ToString(MD5FromString(S[2])), 29, 4);

  for I := 0 to 4 do
    Result := Result + UpperCase(S[I]);

  Insert('-', Result, 6);
  Insert('-', Result, 12);
  Insert('-', Result, 18);
end;

//------------------------------------------------------------------------------

function GenerateCodeForStartMenu8(Version: Integer): String;
var
  S: array[0..4] of String;
  I: Integer;
begin
  Result := '';

  S[0] := RandomHexStr(6);
  S[1] := RandomHexStr(3);
  S[2] := Copy(MD5ToString(MD5FromString(S[0])), 1, 6);
  S[3] := Copy(MD5ToString(MD5FromString(S[1])), 30, 3);
  S[4] := 'F' + IntToStr(Version mod 10);

  for I := 0 to 4 do
    Result := Result + UpperCase(S[I]);

  Insert('-', Result, 6);
  Insert('-', Result, 12);
  Insert('-', Result, 18);
end;

//------------------------------------------------------------------------------

function GenerateCodeForUninstaller(Version: Integer): String;
var
  S: array[0..4] of String;
  I: Integer;
begin
  Result := '';

  S[2] := RandomHexStr(4);
  S[3] := RandomHexStr(5);
  S[4] := 'F' + IntToStr(Version mod 10);
  S[0] := Copy(MD5ToString(MD5FromString(S[2])), 29, 4);
  S[1] := Copy(MD5ToString(MD5FromString(S[3])), 1, 5);

  for I := 0 to 4 do
    Result := Result + UpperCase(S[I]);

  Insert('-', Result, 6);
  Insert('-', Result, 12);
  Insert('-', Result, 18);
end;

{$IFDEF DEBUG}
//------------------------------------------------------------------------------
// Functions for license code verification
//------------------------------------------------------------------------------

function IsCodeForAdvancedSystemCare(const Code: String;
  Version: Integer): Boolean;
var
  S, Part1, Part2, Part3, Part4: String;
begin
  S := StringReplace(Code, '-', '', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, ' ', '', [rfReplaceAll, rfIgnoreCase]);
  S := UpperCase(S);

  if Length(S) = 20 then
  begin
    S := StringReplace(S, 'o', '0', [rfReplaceAll, rfIgnoreCase]);
    S := StringReplace(S, 'i', '1', [rfReplaceAll, rfIgnoreCase]);
    S := StringReplace(S, 'l', '1', [rfReplaceAll, rfIgnoreCase]);

    Part1 := Copy(S, 1, 4);
    Part2 := Copy(S, 5, 5);
    Part3 := Copy(S, 10, 5);
    Part4 := Copy(S, 15, 4);

    Part3 := MD5ToString(MD5FromString(Part3), True);
    Part4 := MD5ToString(MD5FromString(Part4), True);

    Result := (Part1 = Copy(Part4, 29, 4)) and (Part2 = Copy(Part3, 1, 5));
  end
  else
    Result := False;
end;

//------------------------------------------------------------------------------

function IsCodeForAdvancedSystemCareUltimate(const Code: String;
  Version: Integer): Boolean;
var
  S, Part1, Part2, Part3, Part4: String;
begin
  S := StringReplace(Code, '-', '', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, ' ', '', [rfReplaceAll, rfIgnoreCase]);
  S := LowerCase(S);

  if Length(S) = 20 then
  begin
    S := StringReplace(S, 'o', '0', [rfReplaceAll, rfIgnoreCase]);
    S := StringReplace(S, 'i', '1', [rfReplaceAll, rfIgnoreCase]);
    S := StringReplace(S, 'l', '1', [rfReplaceAll, rfIgnoreCase]);

    Part1 := Copy(S, 1, 4);
    Part2 := Copy(S, 5, 4);
    Part3 := Copy(S, 9, 5);
    Part4 := Copy(S, 14, 5);

    Part2 := MD5ToString(MD5FromString(Part2));
    Part4 := MD5ToString(MD5FromString(Part4));

    Result := (Part1 = Copy(Part2, 29, 4)) and (Part3 = Copy(Part4, 1, 5));
  end
  else
    Result := False;
end;

//------------------------------------------------------------------------------

function IsCodeForDriverBooster(const Code: String; Version: Integer): Boolean;
var
  S, Part1, Part2, Part3, Part4: String;
begin
  S := StringReplace(Code, '-', '', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, ' ', '', [rfReplaceAll, rfIgnoreCase]);
  S := LowerCase(S);

  if Length(S) = 20 then
  begin
    S := StringReplace(S, 'o', '0', [rfReplaceAll, rfIgnoreCase]);
    S := StringReplace(S, 'i', '1', [rfReplaceAll, rfIgnoreCase]);
    S := StringReplace(S, 'l', '1', [rfReplaceAll, rfIgnoreCase]);

    Part1 := Copy(S, 1, 5);
    Part2 := Copy(S, 6, 4);
    Part3 := Copy(S, 10, 5);
    Part4 := Copy(S, 15, 4);

    Part3 := MD5ToString(MD5FromString(Part3));
    Part4 := MD5ToString(MD5FromString(Part4));

    Result := (Part2 = Copy(Part4, 29, 4)) and (Part1 = Copy(Part3, 1, 5));
  end
  else
    Result := False;
end;

//------------------------------------------------------------------------------

function IsCodeForiFreeUp(const Code: String; Version: Integer): Boolean;
var
  S, S2, Part1, Part2, Part3, Part4, Part5: String;
  I: Integer;
begin
  S := LowerCase(Code);
  S := StringReplace(S, '-', '', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, ' ', '', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, 'o', '0', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, 'l', '1', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, 'i', '1', [rfReplaceAll, rfIgnoreCase]);

  if Length(S) = 20 then
  begin
    for I := 1 to Length(S) do
    begin
      if not (S[I] in ['0'..'9', 'a'..'f']) then
      begin
        Result := False;
        Exit;
      end;
    end;

    Result := (Copy(S, 6, 4) = Copy(MD5ToString(MD5FromString(Copy(S, 10, 4))), 1, 4)) and
              (Copy(S, 14, 5) = Copy(MD5ToString(MD5FromString(Copy(S, 1, 5))), 28, 5)) and
              (Copy(S, 19, 2) = 'f' + IntToStr(Version mod 10));
  end
  else
    Result := False;
end;

//------------------------------------------------------------------------------

function IsCodeForMalwareFighter(const Code: String; Version: Integer): Boolean;
var
  S, Part1, Part2, Part3, Part4: String;
begin
  S := StringReplace(Code, '-', '', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, ' ', '', [rfReplaceAll, rfIgnoreCase]);
  S := UpperCase(S);

  if Length(S) = 20 then
  begin
    S := StringReplace(S, 'o', '0', [rfReplaceAll, rfIgnoreCase]);
    S := StringReplace(S, 'i', '1', [rfReplaceAll, rfIgnoreCase]);
    S := StringReplace(S, 'l', '1', [rfReplaceAll, rfIgnoreCase]);

    Part1 := Copy(S, 1, 5);
    Part2 := Copy(S, 6, 4);
    Part3 := Copy(S, 10, 4);
    Part4 := Copy(S, 14, 5);

    Part3 := MD5ToString(MD5FromString(Part3), True);
    Part4 := MD5ToString(MD5FromString(Part4), True);

    Result := (Part2 = Copy(Part3, 1, 4)) and (Part1 = Copy(Part4, 28, 5));
  end
  else
    Result := False;
end;

//------------------------------------------------------------------------------

function IsCodeForProtectedFolder(const Code: String; Version: Integer): Boolean;
begin
  // TODO
  Result := True;
end;

//------------------------------------------------------------------------------

function IsCodeForSmartDefrag(const Code: String; Version: Integer): Boolean;
var
  S, Part1, Part2, Part3, Part4: String;
begin
  S := StringReplace(Code, '-', '', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, ' ', '', [rfReplaceAll, rfIgnoreCase]);
  S := LowerCase(S);

  if Length(S) = 20 then
  begin
    S := StringReplace(S, 'o', '0', [rfReplaceAll, rfIgnoreCase]);
    S := StringReplace(S, 'i', '1', [rfReplaceAll, rfIgnoreCase]);
    S := StringReplace(S, 'l', '1', [rfReplaceAll, rfIgnoreCase]);

    Part1 := Copy(S, 1, 5);
    Part2 := Copy(S, 6, 4);
    Part3 := Copy(S, 10, 4);
    Part4 := Copy(S, 14, 5);

    Part3 := MD5ToString(MD5FromString(Part3));
    Part4 := MD5ToString(MD5FromString(Part4));

    Result := (Part2 = Copy(Part3, 29, 4)) and (Part1 = Copy(Part4, 1, 5));
  end
  else
    Result := False;
end;

//------------------------------------------------------------------------------

function IsCodeForStartMenu8(const Code: String; Version: Integer): Boolean;
var
  S, S2, Part1, Part2, Part3, Part4, Part5: String;
  I: Integer;
begin
  S := LowerCase(Code);
  S := StringReplace(S, '-', '', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, ' ', '', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, 'o', '0', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, 'l', '1', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, 'i', '1', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, 'z', '2', [rfReplaceAll, rfIgnoreCase]);

  if Length(S) = 20 then
  begin
    for I := 1 to Length(S) do
    begin
      if not (S[I] in ['0'..'9', 'a'..'f']) then
      begin
        Result := False;
        Exit;
      end;
    end;

    Result := (Copy(S, 16, 3) = Copy(MD5ToString(MD5FromString(Copy(S, 7, 3))), 30, 3)) and
              (Copy(S, 10, 6) = Copy(MD5ToString(MD5FromString(Copy(S, 1, 6))), 1, 6)) and
              (Copy(S, 19, 2) = 'f' + IntToStr(Version mod 10));
  end
  else
    Result := False;
end;

//------------------------------------------------------------------------------

function IsCodeForUninstaller(const Code: String; Value: Integer): Boolean;
var
  S, S2, Part1, Part2, Part3, Part4, Part5: String;
  I: Integer;
begin
  S := LowerCase(Code);
  S := StringReplace(S, ' ', '', [rfReplaceAll, rfIgnoreCase]);
  //S := StringReplace(S, '0', '', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, 'o', '0', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, 'l', '1', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, 'i', '1', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, 'z', '2', [rfReplaceAll, rfIgnoreCase]);
  S := StringReplace(S, '-', '', [rfReplaceAll, rfIgnoreCase]);

  if Length(S) = 20 then
  begin
    for I := 1 to Length(S) do
    begin
      if not (S[I] in ['0'..'9', 'a'..'f']) then
      begin
        Result := False;
        Exit;
      end;
    end;

    Part1 := Copy(S, 1, 4);
    Part2 := Copy(S, 5, 5);
    Part3 := Copy(S, 10, 4);
    Part4 := Copy(S, 14, 5);
    Part5 := UpperCase(Copy(S, 19, 2));

    Part2 := MD5ToString(MD5FromString(MD5ToString(MD5FromString(Part2))));
    Part3 := MD5ToString(MD5FromString(Part3));

    Result := (MD5ToString(MD5FromString(Part1)) = MD5ToString(MD5FromString(Copy(Part3, 29, 4)))) and
              (Part2 = MD5ToString(MD5FromString(MD5ToString(MD5FromString(Copy(MD5ToString(MD5FromString(Part4)), 1, 5))))));

    S2 := IntToStr(Value);
    Result := Result and ((Part5 = 'E1') or (Part5 = 'B' + S2) or (Part5 = 'F' + S2));
  end
  else
    Result := False;
end;
{$ENDIF}

end.
 