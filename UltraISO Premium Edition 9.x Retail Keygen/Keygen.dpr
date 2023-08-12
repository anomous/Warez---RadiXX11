program Keygen;

{$APPTYPE CONSOLE}

uses
  FGInt,
  SysUtils;

//------------------------------------------------------------------------------

procedure FGIntToHexString(const FGInt: TFGInt; var HexStr: String);
var
  S: String;
begin
  FGIntToBase256String(FGInt, S);
  ConvertBase256StringToHexString(S, HexStr);
end;

//------------------------------------------------------------------------------

procedure HexStringToFGInt(const HexStr : String; var FGInt: TFGInt);
var
  S: String;
begin
  ConvertHexStringToBase256String(HexStr, S);
  Base256StringToFGInt(S, FGInt);
end;

//------------------------------------------------------------------------------

function GenerateRegCode(const Name: String): String;
var
  FGI1, FGI2, FGI3, FGI4: TFGInt;
  I: LongWord;
begin
  Result := Copy(Name + StringOfChar(' ', 8 - Length(Name)), 1, 8);
  I := PLongWord(@Result[1])^ xor PLongWord(@Result[5])^ xor Random(MaxInt);
  Result := Format('55%.4X2C53%.4X4F', [I shr 16, I and $FFFF]);
  
  HexStringToFGInt(Result, FGI1);
  HexStringToFGInt('A70F8F62AA6E97D1', FGI2);
  HexStringToFGInt('A7CAD9177AE95A9', FGI3);
  FGIntModExp(FGI1, FGI3, FGI2, FGI4);
  FGIntToHexString(FGI4, Result);

  FGIntDestroy(FGI1);
  FGIntDestroy(FGI2);
  FGIntDestroy(FGI3);
  FGIntDestroy(FGI4);

  Insert('-', Result, 5);
  Insert('-', Result, 10);
  Insert('-', Result, 15);
end;

//------------------------------------------------------------------------------

var
  Name: String;

begin
  Randomize;

  WriteLn('UltraISO Premium Edition 9.x Retail Keygen [by RadiXX11]');
  WriteLn('========================================================');
  WriteLn;

  Write('Reg Name: ');
  ReadLn(Name);

  if Name <> '' then
    WriteLn('Reg Code: ', GenerateRegCode(Name));

  ReadLn;
end.
 