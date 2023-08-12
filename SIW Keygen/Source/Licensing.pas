unit Licensing;

interface

function CreateLicenseFile(const FileName, Name, Key: String): Boolean;
function GenerateKey: String;

implementation

uses
  Windows,
  DIMime,
  MD5,
  SysUtils;

function CreateLicenseFile(const FileName, Name, Key: String): Boolean;
var
  F: TextFile;
begin
  try
    AssignFile(F, FileName);
    ReWrite(F);

    try
      WriteLn(F, MimeEncodeStringNoCRLF(Format('#Do not edit'#13#10'RegisteredTo: %s'#13#10'SerialNo: %s'#13#10, [Copy(Name, 1, 128), Trim(Key)])));
      Result := True;

    finally
      CloseFile(F);
    end;

  except
    Result := False;
  end;
end;

//------------------------------------------------------------------------------

function GenRandom(var RandomBuffer; RandomBufferLength: LongWord): Boolean;
type
  TRtlGenRandom = function(var RandomBuffer; RandomBufferLength: LongWord): Boolean; stdcall;
var
  RtlGenRandom: TRtlGenRandom;
  hLib: HMODULE;
begin
  Result := False;
  hLib := LoadLibrary(advapi32);

  if hLib <> 0 then
  begin
    RtlGenRandom := TRtlGenRandom(GetProcAddress(hLib, 'SystemFunction036'));

    if Assigned(RtlGenRandom) then
      Result := RtlGenRandom(RandomBuffer, RandomBufferLength);

    FreeLibrary(hLib);
  end;
end;

//------------------------------------------------------------------------------

function GetRandomUInt32: LongWord;
begin
  if not GenRandom(Result, SizeOf(Result)) then
    Result := (Word(Random($10000)) shl 16) or Word(Random($10000));
end;

//------------------------------------------------------------------------------

function GenerateKey: String;
var
  v0, v1, v2, v4: LongWord;
begin
  repeat
    repeat
      v4 := GetRandomUInt32;
      v0 := $FFFFFF06 - $1B58 * (v4 div $1B58);
      v1 := v0 + v4;
      v2 := v0 + v4 + $32;
    until (v2 > $30);
  until (v1 > $30) and (v1 - 3360 > $BC) and (v1 - 3641 > $6B) and
        (v1 - 5150 > $256);
        //(v1 - 3752 > $3E4) and (v1 - 7700 > $256);

  Inc(v1, $0F433A);

  Result := 'A-' + Copy(MD5ToString(MD5FromString(Format('Technician%d', [v1])), True), 1, 25);

  Insert('-', Result, 8);
  Insert('-', Result, 14);
  Insert('-', Result, 20);
  Insert('-', Result, 26);
end;

end.