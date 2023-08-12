program Keygen;

{$APPTYPE CONSOLE}

uses
  SysUtils;

//------------------------------------------------------------------------------

const
  Product = 'Internet Download Accelerator';
  Charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz@.';

//------------------------------------------------------------------------------

function GetCharPos(C: Char): Integer;
begin
  Result := Pos(C, Charset);

  if Result > 0 then
    Result := (Result - 1) and $3F;
end;

//------------------------------------------------------------------------------

function GenerateKey(const EMail, Name: String; RusReg: Boolean): String;
var
  S: String;
  I, J, V1, V2, V3, V4, Total: Integer;
begin
  V1 := 0;
  V2 := 0;
  Total := GetCharPos(Name[Length(Name)]) * GetCharPos(Name[1]);

  for I := 1 to Length(Name) do
    Inc(V1, I + Total * GetCharPos(Name[I]));

  S := Name + 'rusreg';

  for I := 1 to Length(S) do
    Inc(V2, I + Total * GetCharPos(S[I]));

  for I := 1 to Length(Product) do
  begin
    J := I + Total * GetCharPos(Product[I]);
    Inc(V1, J);
    Inc(V2, J);
  end;

  V1 := V1 mod 64;
  V2 := V2 mod 64;
  V3 := 0;
  Total := GetCharPos(EMail[Length(EMail)]) * GetCharPos(EMail[1]);

  for I := 1 to Length(EMail) do
    Inc(V3, I + Total * GetCharPos(EMail[I]));

  V3 := (V3 mod 64 + V1) mod 64;

  if RusReg then
    Total := (V3 + V2) mod 64
  else
    Total := (V3 + V1) mod 64;

  SetLength(Result, 16);

  repeat
    V4 := 0;

    for I := 1 to 16 do
    begin
      Result[I] := Charset[Random(Length(Charset) - 2) + 1];
      Inc(V4, I + GetCharPos(Result[I]));
    end;
      
  until (V4 mod 64) = Total;
end;

//------------------------------------------------------------------------------

function ValidateEMail(const EMail: String): Boolean;
begin
  Result := (Trim(EMail) = EMail) and (Length(EMail) >= 5) and
            (Pos('@', EMail) > 0) and (Pos('.', EMail) > 0);
end;

//------------------------------------------------------------------------------

function ValidateName(const Name: String): Boolean;
begin
  Result := (Trim(Name) = Name) and (Length(Name) >= 5);
end;

//------------------------------------------------------------------------------
{$IFDEF DEBUG}
function VerifyKey(const EMail, Name, Key: String): Boolean;
var
  S: String;
  I, J, V1, V2, V3, V4, Total: Integer;
begin
  V1 := 0;
  V2 := 0;
  Total := GetCharPos(Name[Length(Name)]) * GetCharPos(Name[1]);

  for I := 1 to Length(Name) do
    Inc(V1, I + Total * GetCharPos(Name[I]));

  S := Name + 'rusreg';

  for I := 1 to Length(S) do
    Inc(V2, I + Total * GetCharPos(S[I]));

  for I := 1 to Length(Product) do
  begin
    J := I + Total * GetCharPos(Product[I]);
    Inc(V1, J);
    Inc(V2, J);
  end;

  V1 := V1 mod 64;
  V2 := V2 mod 64;
  V3 := 0;
  Total := GetCharPos(EMail[Length(EMail)]) * GetCharPos(EMail[1]);

  for I := 1 to Length(EMail) do
    Inc(V3, I + Total * GetCharPos(EMail[I]));

  V3 := (V3 mod 64 + V1) mod 64;
  V4 := 0;

  for I := 1 to Length(Key) do
    Inc(V4, I + GetCharPos(Key[I]));

  Result := (((V3 + V2) mod 64) = (V4 mod 64)) or (((V3 + V1) mod 64) = (V4 mod 64));
end;
{$ENDIF}
//------------------------------------------------------------------------------

var
  EMail, Name: String;

begin
  Randomize;

  WriteLn('Internet Download Accelerator 6.x Keygen [by RadiXX11]');
  WriteLn('======================================================');
  WriteLn;

  while True do
  begin
    Write('EMail: ');
    ReadLn(EMail);

    if (EMail = '') or ValidateEMail(EMail) then
      Break;

    WriteLn;
    WriteLn('EMail is not valid! Make sure that:');
    WriteLn;
    WriteLn('- It does not have spaces at beginning or end.');
    WriteLn('- It has at least 5 characters');
    WriteLn('- It has an @ and a dot.');
    WriteLn;
  end;

  if EMail <> '' then
  begin
    while True do
    begin
      Write('Name.: ');
      ReadLn(Name);

      if (Name = '') or ValidateName(Name) then
        Break;

      WriteLn;
      WriteLn('Name is not valid! Make sure that:');
      WriteLn;
      WriteLn('- It does not have spaces at beginning or end.');
      WriteLn('- It has at least 5 characters');
      WriteLn;
    end;

    if Name <> '' then
    begin
      WriteLn('Key..: ', GenerateKey(EMail, Name, False));
      ReadLn;
    end;
  end;
end.
