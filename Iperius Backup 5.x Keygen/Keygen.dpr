program Keygen;

{$APPTYPE CONSOLE}

uses
  SHA1,
  SysUtils;

function GenerateActivationCode(const ComputerCode: String): String;
const
  Data: PChar = #$51#$75#$65#$73#$74#$61#$20#$C3#$A8#$20#$6C#$61#$20#$76#$65#$72 +
                #$73#$69#$6F#$6E#$65#$20#$63#$6F#$6D#$70#$6C#$65#$74#$61#$20#$64 +
                #$65#$6C#$20#$70#$72#$6F#$67#$72#$61#$6D#$6D#$61;
var
  Buffer: PChar;
  I: Integer;
begin
  if ComputerCode <> '' then
  begin
    // Calculate SHA1 of computer code + data constant and get the hex string
    // of the resulting hash value.

    GetMem(Buffer, Length(ComputerCode) + StrLen(Data) + 1);
    StrCopy(Buffer, PChar(ComputerCode));
    StrCat(Buffer, Data);
    Result := SHA1ToString(SHA1FromBuffer(Buffer^, StrLen(Buffer)), True);
    FreeMem(Buffer);

    // Insert hyphens ("-") into the hex string to make the final code.
    
    I := 6;
    repeat
      Insert('-', Result, I);
      Inc(I, 6);
    until I > 42;
  end
  else
    Result := '';
end;

var
  ComputerCode: String;

begin
  WriteLn('Iperius Backup 5.x Keygen [by RadiXX11]');
  WriteLn('=======================================');
  WriteLn;
  Write('Computer Code..: ');

  ReadLn(ComputerCode);

  if ComputerCode <> '' then
  begin
    WriteLn('Activation Code: ', GenerateActivationCode(ComputerCode));
    ReadLn;
  end;
end.
 