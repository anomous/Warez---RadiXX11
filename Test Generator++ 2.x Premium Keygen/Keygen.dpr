program Keygen;

{$APPTYPE CONSOLE}

uses
  Math,
  SysUtils;

//------------------------------------------------------------------------------

function GenerateAppKey: String;
var
  S, S1, S2, S3, S4, S5: String;
  I, J, K: Integer;
begin
  SetLength(S1, 10);

  for I := 1 to 10 do
    S1[I] := Char(Random(10) + 48);

  SetLength(S2, 10);
  SetLength(S3, 10);

  K := 0;

  for I := 1 to 10 do
  begin
    repeat
      J := RandomRange(65, 90);
      S := IntToStr(J);
    until S[Length(S)] = S1[I];

    S2[I] := Char(J);

    repeat
      J := RandomRange(0, 25);
      S := IntToStr(J);
    until S[Length(S)] = S1[I];

    S3[I] := Char(J + 65);

    Inc(K, StrToInt(S1[I]));
  end;

  S4 := Format('%.2d', [K]);

  for I := 1 to 2 do
  begin
    repeat
      J := RandomRange(0, 25);
      S := IntToStr(J);
    until S[Length(S)] = S4[I];

    S4[I] := Char(J + 65);
  end;

  SetLength(S5, 5);

  S5[1] := S2[5];
  S5[2] := S3[1];
  S5[3] := S4[1];
  S5[4] := S4[2];
  S5[5] := S2[1];

  Result := Copy(S2, 1, 3) + Copy(S3, 1, 2) + Copy(S2, 4, 2) + S3[3] + S2[6] +
            Copy(S3, 4, 4) + Copy(S2, 7, 3) + Copy(S3, 8, 2) + S2[10] + S3[10] + S5;

  Insert('-', Result, 6);
  Insert('-', Result, 12);
  Insert('-', Result, 18);
  Insert('-', Result, 24);
end;

//------------------------------------------------------------------------------

function GenerateUnlockKey(const MachineCode: String): String;
var
  S: String;
  I, J: Integer;
begin
  Result := '';

  if Length(MachineCode) = 4 then
  begin
    SetLength(S, 4);

    for I := 1 to 4 do
    begin
      if not (MachineCode[I] in ['0'..'9']) then
        Exit;

      S[I] := Char(StrToInt(MachineCode[I]) + 65);
    end;

    Result := StringOfChar(' ', 30);
    Result[6] := S[4];
    Result[12] := S[3];
    Result[18] := S[2];
    Result[24] := S[1];
    J := 0;

    for I := 1 to 29 do
    begin
      if Result[I] = ' ' then
        Result[I] := Char(Random(26) + 65);

      Inc(J, Ord(Result[I]));
    end;

    S := IntToStr(J);

    while Length(S) > 1 do
    begin
      J := 0;

      for I := 1 to Length(S) do
        Inc(J, StrToInt(S[I]));

      S := IntToStr(J);
    end;

    Result[30] := Char(StrToInt(S) + 65);

    Insert('-', Result, 7);
    Insert('-', Result, 14);
    Insert('-', Result, 21);
    Insert('-', Result, 28);
  end;
end;

//------------------------------------------------------------------------------

var
  MachineCode, UnlockKey: String;

begin
  // http://techior.com/Test-Generator-plus.html

  Randomize;
  
  WriteLn('Test Generator++ 2.x Premium Keygen [by RadiXX11]');
  WriteLn('=================================================');
  WriteLn;

  while True do
  begin
    Write('Machine Code: ');
    ReadLn(MachineCode);

    if MachineCode <> '' then
    begin
      UnlockKey := GenerateUnlockKey(MachineCode);

      if UnlockKey <> '' then
      begin
        WriteLn('App Key.....: ', GenerateAppKey);
        WriteLn('Unlock Key..: ', UnlockKey);
        WriteLn;
        WriteLn('*** DEFAULT LOGIN CREDENTIALS ***');
        WriteLn('User Id.: admin');
        WriteLn('Password: techior');
        WriteLn('*********************************');
        Break;
      end
      else
      begin
        WriteLn('Incorrect Machine Code format!');
        WriteLn;
      end;
    end
    else
      Break;
  end;

  ReadLn;
end.
