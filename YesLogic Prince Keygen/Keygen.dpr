program Keygen;

{$APPTYPE CONSOLE}

uses
  MD5,
  SysUtils;

//------------------------------------------------------------------------------

const
  Table: array[0..255] of Byte = (
    $5B, $1C, $AB, $3B, $B7, $AF, $02, $22, $86, $01, $9C, $28, $9A, $EA, $6E,
    $F4, $E2, $08, $F8, $5B, $40, $C5, $B2, $7B, $F3, $B1, $32, $55, $7D, $58,
    $07, $0F, $71, $2C, $03, $5E, $48, $8B, $7D, $DA, $A9, $9D, $82, $B7, $CA,
    $72, $07, $60, $AE, $9A, $40, $60, $06, $49, $16, $05, $C7, $8D, $EA, $38,
    $DC, $8C, $7A, $F4, $37, $48, $9A, $3D, $10, $93, $AF, $60, $D7, $42, $E0,
    $1A, $71, $47, $B0, $7B, $D5, $85, $89, $7F, $B8, $2E, $93, $4D, $A6, $1B,
    $92, $E4, $5D, $8C, $41, $BD, $52, $9F, $54, $83, $54, $2A, $7C, $92, $3F,
    $4D, $23, $E5, $5E, $17, $B0, $2C, $98, $FC, $76, $17, $86, $1C, $0F, $BB,
    $96, $2F, $93, $04, $D9, $A0, $AE, $DA, $7D, $58, $F0, $0B, $9D, $B1, $36,
    $AB, $15, $A9, $6F, $80, $D8, $12, $5B, $C7, $6E, $C5, $52, $07, $88, $0F,
    $A6, $EE, $80, $E6, $37, $A7, $18, $7E, $F6, $E8, $77, $14, $DF, $C4, $75,
    $A2, $25, $E4, $7A, $6F, $EC, $49, $05, $A5, $7F, $BA, $95, $96, $AA, $5A,
    $94, $00, $74, $78, $25, $9A, $B1, $D0, $F4, $5F, $9F, $8E, $C3, $14, $1D,
    $01, $E7, $33, $4B, $67, $B9, $EA, $1B, $06, $AA, $70, $C7, $40, $8B, $7A,
    $2B, $F9, $5E, $9C, $38, $2F, $85, $50, $7F, $84, $9E, $4B, $81, $36, $B5,
    $18, $4A, $AD, $06, $1F, $3A, $25, $A4, $C2, $76, $2D, $60, $E4, $0C, $BB,
    $C5, $32, $68, $24, $87, $86, $0C, $FC, $11, $72, $C3, $26, $4C, $D3, $7C,
    $00
  );

//------------------------------------------------------------------------------

function CreateLicenseFile(const Path, Name, Vendor, License: String): Boolean;
var
  F: File;
  Date, FileName, LicData, Signature, Value: AnsiString;
  I, Year, Month, Day: Word;
begin
  Result := False;

  if (Length(Name) >= 5) and (Length(Name) <= 250) then
  begin
    Value := Format('%.7d', [Random(10000000)]);
    DecodeDate(Now, Year, Month, Day);
    Date := Format('%d-%.2d-%.2d', [Year, Month, Day]);
    LicData := Format('(%s)(%s)(%s)(Prince)(latest)(%s)(%s)(all=yes)',
                [Value, License, Vendor, Name, Date]);

    for I := 1 to Length(LicData) do
      LicData[I] := Char(Byte(LicData[I]) xor Table[I - 1]);

    Signature := MD5ToString(MD5FromString(LicData), True);
    LicData := Format('<license id="%s"><name>%s</name><vendor>%s</vendor>' +
                '<product>Prince</product><version>latest</version>' +
                '<end-user>%s</end-user><date>%s</date><signature>%s</signature>' +
                '<option id="all">yes</option></license>'#13#10,
                [Value, License, Vendor, Name, Date, Signature]);
    FileName := IncludeTrailingPathDelimiter(Path) + 'license.dat';

    AssignFile(F, FileName);
    try
      ReWrite(F, 1);
      BlockWrite(F, LicData[1], Length(LicData));
      Result := True;
    except
      CloseFile(F);
    end;
  end;
end;

//------------------------------------------------------------------------------

var
  Name, Vendor, License: String;
  Done: Boolean;

begin
  Randomize;

  WriteLn('YesLogic Prince Keygen [ByRadiXX11]');
  WriteLn('===================================');

  repeat
    WriteLn;
    Write('Name...: ');
    ReadLn(Name);

    Done := (Length(Name) >= 5) and (Length(Name) <= 250);

    if not Done then
    begin
      WriteLn;
      WriteLn('Name length is not valid! Name must have from 5 to 250 characters.');
    end;

  until Done;

  Write('Vendor.: ');
  ReadLn(Vendor);

  if Vendor = '' then
    Vendor := 'YesLogic';

  Write('License: ');
  ReadLn(License);

  if License = '' then
    License := 'Desktop License';

  WriteLn;

  if CreateLicenseFile(GetCurrentDir, Name, Vendor, License) then
    WriteLn('License file created. Now import the license file from the program.')
  else
    WriteLn('Cannot create license file!');

  WriteLn;
  WriteLn('Press ENTER to continue...');
  ReadLn;
end.
