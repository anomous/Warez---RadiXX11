unit Licensing;

interface

function GetLicenseKey(const RequestCode: String): String;
function GetRequestCode: String;

implementation

uses
  Windows,
  SysUtils;

//------------------------------------------------------------------------------

function TryStrToUInt64(S: String; var Value: UInt64): Boolean;
var
  NextValue: UInt64;
  N, Start, Base, Digit: Integer;
begin
  Result := False;
  Base := 10;
  Start := 1;
  S := Trim(UpperCase(S));

  if S = '' then
    Exit;

  if S[1] = '-' then
    Exit;

  if S[1] = '$' then
  begin
    Base := 16;
    Start := 2;

    if Length(S) > 17 then // $+16 hex digits = max hex length.
      Exit;
  end;

  Digit := 0;
  Value := 0;

  for N := Start to Length(S) do
  begin
    if S[N] in ['0'..'9'] then
      Digit := Ord(S[N]) - Ord('0')
    else if (Base = 16) and (S[N] >= 'A') and (S[N] <= 'F') then
      Digit := (Ord(S[N]) - Ord('A')) + 10
    else
      Exit; // invalid digit.

    NextValue := (Value * base) + digit;

    if NextValue < Value then
      Exit;

    Value := NextValue;
  end;

  Result := True; // success.
end;

//------------------------------------------------------------------------------

function StrToUInt64(Value: String): UInt64;
begin
  if not TryStrToUInt64(Value,Result) then
    raise EConvertError.Create('Invalid UInt64 value');
end;

//------------------------------------------------------------------------------

function GetLicenseKey(const RequestCode: String): String;
var
  Value: UInt64;
begin
  try
    Value := StrToUInt64(RequestCode);
    Value := (UInt64((Value shr 32) xor $132AB7EA) shl 32) or
              UInt64((Value and $FFFFFFFF) xor $681249EF);
    Result := Format('%.20u', [Value]);
  except
    Result := '';
  end;
end;

//------------------------------------------------------------------------------

function GetRequestCode: String;
var
  Serial: UInt64;
  SerialLo, SerialHi, MCL, FSF: DWORD;
begin
  try
    if GetVolumeInformation('C:\', nil, 0, @SerialLo, MCL, FSF, nil, 0) then
    begin
      SerialHi := ((((SerialLo and $FF000000) shr 24) xor $76) shl 24) or
                  ((((SerialLo and $FF0000) shr 16) xor $12) shl 16) or
                  ((((SerialLo and $FF00) shr 8) xor $F3) shl 8) or
                  ((SerialLo and $FF) xor $A2);
      Serial := (UInt64(SerialHi) shl 32) or UInt64(SerialLo);
      Result := Format('%.20u', [Serial]);
    end
    else
      Result := '';
  except
    Result := '';
  end;
end;

end.
