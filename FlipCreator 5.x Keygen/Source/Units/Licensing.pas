unit Licensing;

interface

type
  TLicenseType = (
    ltStandard,
    ltAnnual,
    ltProfessional,
    ltEnterprise,
    ltGlobal
  );

const
  LicenseTypes: array[TLicenseType] of String = (
    'Standard',
    'Annual',
    'Professional',
    'Enterprise',
    'Global'
  );

function GenerateRegCode(const Name: String; LicenseType: TLicenseType): String;

implementation

uses
  SysUtils;

function GenerateRegCode(const Name: String; LicenseType: TLicenseType): String;
const
  Strs: array[TLicenseType] of String = (
    'x?W',
    'R8m#a',
    'M3t@Jb0',
    'V7He%Yrv9',
    'N2s&Kz6QfU'
  );
var
  S1, S2: String;
  I, J, K, L: Integer;
begin
  if Trim(Name) <> '' then
  begin
    Result := Trim(Name) + Strs[LicenseType];
    I := Length(Result) div 2;
    Result := Copy(Result, I + 1, Length(Result)) + Copy(Result, 1, I);

    S1 := Copy(Result, 1, 10);
    S2 := Copy(Result, 6, Length(Result));

    if S2 = '' then
      S2 := Strs[LicenseType] + S1;

    if S2 = '' then
      S2 := 'Think Space';

    Result := '100';
    J := 256;
    K := 0;

    for I := 1 to Length(S1) do
    begin
      L := (Ord(S1[I]) + J) mod 255;

      if K >= Length(S2) then
        K := 1
      else
        Inc(K);

      J := Ord(S2[K]) xor L;
      Result := Result + Format('%1.2x', [J]);
    end;

    Result := Copy(Result, 1, 5) + '-' + Copy(Result, 6, 5) + '-' + Copy(Result, 11, 5);
  end
  else
    Result := '';
end;

end.
