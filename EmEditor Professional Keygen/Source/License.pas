unit License;

interface

function GenerateKey(const ExpDate: TDateTime): String;
function GetMinExpirationDate: TDateTime;
function GetMaxExpirationDate: TDateTime;

implementation

uses
  Dateutils,
  Math,
  MD5,
  SysUtils;

//------------------------------------------------------------------------------

function Calc(Value: Integer; const S: String): String;
var
  I, J, K, L: Integer;
begin
  Result := '';

  for I := 0 to 4 do
  begin
    J := 4 - I;

		if J = 0 then
      K := 1
		else
    begin
      L := 32;
      K := L;

      if J > 1 then
      begin
        Dec(J);

        repeat
          L := L shl 5;
          Dec(J);
        until J = 0;

				K := L;
      end;
    end;

    J := Value;
    L := J mod K;
		Value := L;
		Result := Result + S[((J div K) and 31) + 1];
  end;
end;

//------------------------------------------------------------------------------

function GetSubString(const S: String; const Indexes: array of Integer): String;
var
  I: Integer;
begin
  Result := '';
  for I := Low(Indexes) to High(Indexes) do
    Result := Result + S[Indexes[I]];
end;

//------------------------------------------------------------------------------

function GenerateKey(const ExpDate: TDateTime): String;
const
  Arr: array[0..8] of String = ('EM', 'VE', 'SH', 'RN', 'PA', 'SB', 'MA', 'TH', 'VA');
  Charset1 =  '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
  Charset2 =  '2T3YKWEPXB8FQJLU5HZS4V7NDG9AC6RMD5T3Y8NMAK7FQJLUCVHZ6RG942XBWEPSSQ' +
              'PXJC36DRLAU5HZM74GBTKE9WVN2Y8FEPXB82T3YKWFQJLU5HZS4V7NDG9AC6RMKWEP' +
              'X2T3YB8FQJLU5HZS4V9AC6RM7NDGSQPXJCLAU5HZ36DRM74GE9WVN2Y8FBTKD5T3Y8' +
              'NFQJLUCVHZ6RMAK7G94BWEPS2X4BWEPS2D5T3Y8NFQJLUCVHZ6RMAK7G9XS4V9ACKW' +
              'EPX2T3YB8FQJLU5HZ6RM7NDGVN2TY8FBSQPXJCLAU5HZ36DRM74GE9WKS4VNBAKWEP' +
              '2D5T3Y8FQJLUCHZ6RM7G9XBS4V9NACDKWEPX2T3Y8FQJLU5HZ6RM7GVNCDW2T3Y8FB' +
              'SQEPXJLAU5HZ6RM74G9KS';
  Charset3  = '36DRSQPXJCLAU5HZM74GBTKE9WVN2Y8F2T3YKWEPXB8FQJLU5HZS4V7NDG9AC6RMD5' +
              'T3Y8NMAK7FQJLUCVHZ6RG942XBWEPSSQPXJC36DRLAU5HZM74GBTKE9WVN2Y8FEPXB' +
              '82T3YKWFQJLU5HZS4V7NDG9AC6RMKWEPX2T3YB8FQJLU5HZS4V9AC6RM7NDGSQPXJC' +
              'LAU5HZ36DRM74GE9WVN2Y8FBTKD5T3Y8NFQJLUCVHZ6RMAK7G94BWEPS2X4BWEPS2D' +
              '5T3Y8NFQJLUCVHZ6RMAK7G9XS4V9ACKWEPX2T3YB8FQJLU5HZ6RM7NDGVN2TY8FBSQ' +
              'PXJCLAU5HZ36DRM74GE9WKS4VNBAKWEP2D5T3Y8FQJLUCHZ6RM7G9XBS4V9NACDKWE' +
              'PX2T3Y8FQJLU5HZ6RM7GVNCDW2T3Y8FBSQEPXJLAU5HZ6RM74G9KS';
  Charset4  = 'MAK7D5T3Y8NFQJLUCVHZ6RG942XBWEPS36DRSQPXJCLAU5HZM74GBTKE9WVN2Y8F2T' +
              '3YKWEPXB8FQJLU5HZS4V7NDG9AC6RMD5T3Y8NMAK7FQJLUCVHZ6RG942XBWEPSSQPX' +
              'JC36DRLAU5HZM74GBTKE9WVN2Y8FEPXB82T3YKWFQJLU5HZS4V7NDG9AC6RMKWEPX2' +
              'T3YB8FQJLU5HZS4V9AC6RM7NDGSQPXJCLAU5HZ36DRM74GE9WVN2Y8FBTKD5T3Y8NF' +
              'QJLUCVHZ6RMAK7G94BWEPS2X4BWEPS2D5T3Y8NFQJLUCVHZ6RMAK7G9XS4V9ACKWEP' +
              'X2T3YB8FQJLU5HZ6RM7NDGVN2TY8FBSQPXJCLAU5HZ36DRM74GE9WKS4VNBAKWEP2D' +
              '5T3Y8FQJLUCHZ6RM7G9XBS4V9NACDKWEPX2T3Y8FQJLU5HZ6RM7GVNCDW2T3Y8FBSQ' +
              'EPXJLAU5HZ6RM74G9KS';
var
  MinExpDate: TDateTime;
  ExpStr, S1, S2, S3, S4, S5: String;
  I: Integer;
  Days, Rem: Word;
begin
  MinExpDate := GetMinExpirationDate;

  // Check if we have a lifetime license or we have an expiration date. If we
  // have an expirartion date, it must be between today's date and 2102-09-19.
  if (CompareDate(ExpDate, MinExpDate) = 0) or
    ((CompareDate(ExpDate, Today) >= 0) and
    (CompareDate(ExpDate, GetMaxExpirationDate) <= 0)) then
  begin
    // Encode expiration date
    Days := DaysBetween(ExpDate, MinExpDate);
    ExpStr := '';

    repeat
      DivMod(Days, Length(Charset1), Days, Rem);
      ExpStr := Charset1[Rem + 1] + ExpStr;
    until Days < Length(Charset1);

    ExpStr := Charset1[Days + 1] + ExpStr;
    ExpStr := StringOfChar(Charset1[1], 3 - Length(ExpStr)) + ExpStr;  // Padding.

    // Encode key
    S1 := '';

    for I := 1 to 18 do
      S1 := S1 + Charset1[Random(Length(Charset1)) + 1];

    S1 := 'D' + Arr[Random(Length(Arr))] + 'Z' + S1;

    Insert('-', S1, 6);
    Insert('-', S1, 12);
    Insert(ExpStr + '-', S1, 15);
    Insert('-', S1, 24);

    S2 := MD5ToString(MD5FromString(GetSubString(S1, [10, 4, 1, 5, 11, 6, 2, 7, 3, 9, 8, 17, 12, 16, 15])));
    S3 := GetSubString(Calc(StrToInt('$' + GetSubString(S2, [4, 11, 2, 22, 7, 32, 29])), Charset2), [4, 2]);
    S4 := GetSubString(Calc(StrToInt('$' + GetSubString(S2, [9, 3, 31, 19, 30, 10, 27])), Charset3), [2, 5, 3, 4,	1]);
    S5 := GetSubString(Calc(StrToInt('$' + GetSubString(S2, [24, 15, 6, 26, 21, 8, 23])), Charset4), [5, 1, 3, 4, 2]);
    Result := Copy(S1, 1, 12) + S3 + Copy(S1, 15, 4) + S4 + '-' + S5;
  end
  else
    Result := '';
end;

//------------------------------------------------------------------------------

function GetMinExpirationDate: TDateTime;
begin
  // Also used to indicate a lifetime license.
  Result := EncodeDate(2013, 1, 1);
end;

//------------------------------------------------------------------------------

function GetMaxExpirationDate: TDateTime;
begin
  // Max expiration date is 2102-09-19
  Result := IncDay(GetMinExpirationDate, 32767);
end;

end.
