unit Licensing;

interface

function GenerateLicenseKey(const Name, Info: String;
  LicenseCount: Integer): String;
  
implementation

uses
  SysUtils;

function RandomIntStr(Len: Integer): String;
var
  I: Integer;
begin
  SetLength(Result, Len);
  for I := 1 to Len do
    Result[I] := IntToStr(Random(10))[1];
end;

function IntToStrPad(Value: Integer; Len: Integer): String;
var
  I: Integer;
begin
  Result := IntToStr(Value);
  for I := 1 to Len - Length(Result) do
    Result := '0' + Result;
end;

function GenerateLicenseKey(const Name, Info: String;
  LicenseCount: Integer): String;
const
  LineCount = 10;
var
  I, J: Integer;
begin
  Result := Format('PD:{HyperSnap 8}'#13#10 +
            'LO:{%s}'#13#10 +
            'A1:{%s}'#13#10 +
            'SN:{%s}'#13#10 +
            'NC:{%d}'#13#10 +
            'KI:{%s}'#13#10 +
            'KD:{%d'#13#10,
            [Name,
            Info,
            RandomIntStr(10),
            LicenseCount,
            RandomIntStr(10),
            LineCount * 10]);

  for I := 1 to LineCount do
  begin
    for J := 1 to 10 do
    begin
      Result := Result + IntToStrPad(Random($100), 3);

      if J < 10 then
        Result := Result + ' ';
    end;

    Result := Result + #13#10;
  end;

  Result := Result + 'EK:}';
end;

end.
