unit License;

interface

type
  TProductInfo = record
    Name: String;
    Codes: array[0..7] of Integer;
  end;

  TLicenseOption = (
    loProBusinessEdition,
    loSiteLicense,
    loLifetimeLicense,
    loLifetimeUpgrades
  );

  TLicenseOptions = set of TLicenseOption;

const
  ProductList: array[0..1] of TProductInfo = (
    (
      Name: 'CD Label Designer';
      Codes: (69, 202, 5, 15, 3, 9, 800, 900);
    ),
    (
      Name: 'Web Log Storming';
      Codes: (52, 188, 4, 13, 9, 3, 800, 700);
    )
  );

function GenerateKey(const ProductInfo: TProductInfo;
  const Name: String; LicenseOptions: TLicenseOptions;
  const LicenseExpiration, UpgradesExpiration: TDateTime;
  var Key: String): Integer;

implementation

uses
  SysUtils;

//------------------------------------------------------------------------------

const
  // Max date that can be encoded for license/upgrades expiration
  MaxLicenseYear  = 2031;
  MaxLicenseMonth = 12;
  MaxLicenseDay   = 31;

  // Min date that can be encoded for license/upgrades expiration
  MinLicenseYear  = 2000;
  MinLicenseMonth = 1;
  MinLicenseDay   = 1;

//------------------------------------------------------------------------------

function GetMaxLicenseDate: TDateTime;
begin
  Result := EncodeDate(MaxLicenseYear, MaxLicenseMonth, MaxLicenseDay);
end;

//------------------------------------------------------------------------------

function GetMinLicenseDate: TDateTime;
begin
  Result := EncodeDate(MinLicenseYear, MinLicenseMonth, MinLicenseDay);
end;

//------------------------------------------------------------------------------

function GenerateKey(const ProductInfo: TProductInfo;
  const Name: String; LicenseOptions: TLicenseOptions;
  const LicenseExpiration, UpgradesExpiration: TDateTime;
  var Key: String): Integer;
const
  Charset = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
var
  Arr: array[0..3] of Integer;
  S: String;
  A, B, C, D, E, F, G, I, Flags: Integer;
  Year, Month, Day: Word;
begin
  Key := '';
  S := UpperCase(Trim(Name));

  if S = '' then
  begin
    Result := 1;  // Name must have at least 1 char
    Exit;
  end;

  // Name padding when length < 4 //////////////////////////////////////////////

  I := 1;
  A := Length(S);

  while Length(S) < 4 do
  begin
    S := S + Char(Byte(S[I]) + I);

    Inc(I);

    if I > A then I := 1;
  end;

  // Calculate name checksum ///////////////////////////////////////////////////

  FillChar(Arr, SizeOf(Arr), 0);

  for I := 1 to Length(S) do
  begin
    with ProductInfo do
    begin
      Inc(Arr[I mod 4], (Byte(S[I]) * Codes[2]) * I);
      Inc(Arr[(I + 1) mod 4], (Byte(S[I]) * Codes[3]) div I);
      Inc(Arr[(I + 2) mod 4], ((Byte(S[I]) + Codes[6]) * Codes[4]) * I);
      Inc(Arr[(I + 3) mod 4], ((Byte(S[I]) + Codes[7]) * Codes[5]) div I);
    end;
  end;

  for I := 0 to 3 do
    Key := Key + Charset[(Arr[I] mod 32) + 1];

  // Encode license options ////////////////////////////////////////////////////

  Flags := 0;

  if loProBusinessEdition in LicenseOptions then Flags := Flags or 1;
  if loSiteLicense in LicenseOptions then Flags := Flags or 2;
  if loLifetimeUpgrades in LicenseOptions then Flags := Flags or 4;

  repeat
    I := Random(32);
  until (I and 7) = Flags;

  Key := Key + Charset[I + 1];

  // Encode upgrades expiration date ///////////////////////////////////////////

  if loLifetimeUpgrades in LicenseOptions then
  begin
    // Note: we can't generate random values here because this date is always
    // decoded (even if upgrades has no expiration) and must be valid.
    
    Year := MaxLicenseYear;
    Month := MaxLicenseMonth;
    Day := MaxLicenseDay;
  end
  else
  begin
    // Validate date
    if (Trunc(UpgradesExpiration) < Trunc(GetMinLicenseDate)) or
      (Trunc(UpgradesExpiration) > Trunc(GetMaxLicenseDate)) or
      (Trunc(UpgradesExpiration) <= Trunc(Now)) then
    begin
      Result := 3;  // Upgrades expiration date is not valid
      Exit;
    end;

    DecodeDate(UpgradesExpiration, Year, Month, Day);
  end;

  Dec(Year, 2000);

  if Year >= 32 then
  begin
    Result := 3;  // Upgrades expiration date is not valid (year)
    Exit;
  end;

  repeat
    A := Random(32) + 1;
    B := Random(32) + 1;
    C := Random(32) + 1;
    D := Random(32) + 1;
    E := B - A;
    F := C - A;
    G := D - A;

    if E < 0 then Inc(E, 32);
    if F < 0 then Inc(F, 32);
    if G < 0 then Inc(G, 32);

    E := E mod 32;
    F := F mod 32;
    G := G mod 32;
  until (E = Year) and (F = Month) and (G = Day);

  Key := Key + Charset[B] + Charset[C] + Charset[D] + Charset[A];

  // Encode license expiration date ////////////////////////////////////////////

  if loLifetimeLicense in LicenseOptions then
  begin
    // Note: we pick some random values here, this date is not decoded unless
    // there is an expirarion date to validate.

    repeat
      A := Random(32);
    until (A mod 2) = 0;

    Inc(A);

    B := Random(32) + 1;
    C := Random(32) + 1;
    D := Random(32) + 1;
  end
  else
  begin
    // Validate date
    if (Trunc(LicenseExpiration) < Trunc(GetMinLicenseDate)) or
      (Trunc(LicenseExpiration) > Trunc(GetMaxLicenseDate)) or
      (Trunc(LicenseExpiration) <= Trunc(Now)) then
    begin
      Result := 2;  // License expiration date is not valid
      Exit;
    end;

    DecodeDate(LicenseExpiration, Year, Month, Day);
    Dec(Year, 2000);

    if Year > 32 then
    begin
      Result := 2;  // License expiration date is not valid (year)
      Exit;
    end;
    
    repeat
      repeat
        A := Random(32);
      until (A mod 2) = 1;

      Inc(A);

      B := Random(32) + 1;
      C := Random(32) + 1;
      D := Random(32) + 1;
      E := B - A;
      F := C - A;
      G := D - A;

      if E < 0 then Inc(E, 32);
      if F < 0 then Inc(F, 32);
      if G < 0 then Inc(G, 32);

      E := E mod 32;
      F := F mod 32;
      G := G mod 32;
    until (E = Year) and (F = Month) and (G = Day);
  end;

  Key := Key + Charset[B] + Charset[C] + Charset[D] + Charset[A];

  // Padding with random chars /////////////////////////////////////////////////

  for I := 1 to 8 do
    Key := Key + Charset[Random(Length(Charset)) + 1];

  // Calculate and append key checksum /////////////////////////////////////////

  A := ProductInfo.Codes[0];
  B := ProductInfo.Codes[1];

  for I := 1 to Length(Key) do
  begin
    Inc(B, Byte(Key[I]));

    if B > 255 then Dec(B, 255);

    Inc(A, B);

    if A > 255 then Dec(A, 255);
  end;

  Key := Key + IntToHex((A shl 8) or B, 4);

  // Note: optionally you can insert some hypens ("-") in the key at this point
  // in any place you want, since these are removed when the key validation is
  // performed.

  Result := 0;  // All Ok
end;

end.
 