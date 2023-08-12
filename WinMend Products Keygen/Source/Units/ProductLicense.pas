//==============================================================================
// Registration codes generator
//------------------------------------------------------------------------------
// WinMend Products Keygen
// © 2016, RadiXX11
//------------------------------------------------------------------------------
// DISCLAIMER
//
// This program is provided "AS IS" without any warranty, either expressed or
// implied, including, but not limited to, the implied warranties of
// merchantability and fitness for a particular purpose.
//
// This program and its source code are distributed for educational and
// practical purposes ONLY.
//
// You are not allowed to get a monetary profit of any kind through its use.
//
// The author will not take any responsibility for the consequences due to the
// improper use of this program and/or its source code.
//==============================================================================

unit ProductLicense;

interface

type
  // Enum to identify each supported product
  TProductId = (
    piAll,
    piSystemDoctor,
    piRegistryCleaner,
    piDiskCleaner,
    piHistoryCleaner,
    piDataRecovery
  );

const
  // List of supported products from WinMend
  ProductName: array[TProductId] of String = (
    'All',
    'System Doctor',
    'Registry Cleaner',
    'Disk Cleaner',
    'History Cleaner',
    'Data Recovery'
  );


// function for registration codes generation
function GenerateRegKey(ProductId: TProductId): String;

// this function is provided only for debugging purposes
{$IFDEF DEBUG}
function VerifyRegKey(ProductId: TProductId; const RegKey: String): Boolean;
{$ENDIF}

implementation

uses
  SysUtils;

//------------------------------------------------------------------------------

function GenerateRegKey(ProductId: TProductId): String;
var
  S: String;
  I, J, K, Total: Integer;
  Arr: array[0..24] of Integer;
begin
  for I := 0 to 14 do
    Arr[I] := Random(10);

  Arr[1] := Integer(ProductId);

  J := 15;
  K := 1;

  repeat
    if J = 15 then K := 3;
    if J = 16 then K := 5;
    if J = 17 then K := 7;
    if J = 18 then K := 11;
    if J = 19 then K := 13;
    if J = 20 then K := 17;
    if J = 21 then K := 19;
    if J = 22 then K := 23;
    if J = 23 then K := 29;
    if J = 24 then K := 31;

    Total := 0;

    for I := 1 to J do
      Inc(Total, Arr[I - 1]);

    Total := Total * K;

    S := IntToStr(Total);
    Arr[J] := StrToInt(Copy(S, Length(S), 1));

    if Arr[J] = 0 then
      Arr[J] := Arr[J] + Arr[14] + (Arr[13] * 10) + K;

    S := IntToStr(Arr[J]);
    Arr[J] := StrToInt(Copy(S, Length(S), 1));

    if Arr[J] = Arr[J - 1] then
    begin
      if Arr[J] = Arr[J - 2] then
        Inc(Arr[J]);
    end;

    S := IntToStr(arr[J]);
    Arr[J] := StrToInt(Copy(S, Length(S), 1));

    if (J = 23) or (J = 24) then
      Inc(Arr[J], Arr[1]);

    S := IntToStr(Arr[J]);
    Arr[J] := StrToInt(Copy(S, Length(S), 1));

    Inc(J);
  until J = 25;

  Result := '';

  for I := 0 to 24 do
  begin
    Result := Result + IntToStr(Arr[I]);

    if (((I + 1) mod 5) = 0) and (I < 24) then
      Result := Result + '-';
  end;
end;

//------------------------------------------------------------------------------

{$IFDEF DEBUG}
function VerifyRegKey(ProductId: TProductId; const RegKey: String): Boolean;
var
  Key, S: String;
  I, J, K, Value, Total: Integer;
  Arr: array[0..24] of Integer;
begin
  Key := StringReplace(RegKey, ' ', '', [rfReplaceAll, rfIgnoreCase]);
  Key := StringReplace(Key, '-', '', [rfReplaceAll, rfIgnoreCase]);

  if Length(Key) <> 25 then
  begin
    Result := False;
    Exit;
  end;

  for I := 1 to 15 do
  begin
    if not TryStrToInt(Key[I], Value) then
    begin
      Result := False;
      Exit;
    end;

    Arr[I - 1] := Value;
  end;

  if TProductId(Arr[1]) <> ProductId then
  begin
    Result := False;
    Exit;  
  end;

  J := 15;
  K := 1;

  repeat
    if J = 15 then K := 3;
    if J = 16 then K := 5;
    if J = 17 then K := 7;
    if J = 18 then K := 11;
    if J = 19 then K := 13;
    if J = 20 then K := 17;
    if J = 21 then K := 19;
    if J = 22 then K := 23;
    if J = 23 then K := 29;
    if J = 24 then K := 31;

    Total := 0;

    for I := 1 to J do
      Inc(Total, Arr[I - 1]);

    Total := Total * K;

    S := IntToStr(Total);
    Arr[J] := StrToInt(Copy(S, Length(S), 1));

    if Arr[J] = 0 then
      Arr[J] := Arr[J] + Arr[14] + (Arr[13] * 10) + K;

    S := IntToStr(Arr[J]);
    Arr[J] := StrToInt(Copy(S, Length(S), 1));

    if Arr[J] = Arr[J - 1] then
    begin
      if Arr[J] = Arr[J - 2] then
        Inc(Arr[J]);
    end;

    S := IntToStr(arr[J]);
    Arr[J] := StrToInt(Copy(S, Length(S), 1));

    if (J = 23) or (J = 24) then
      Inc(Arr[J], Arr[1]);

    S := IntToStr(Arr[J]);
    Arr[J] := StrToInt(Copy(S, Length(S), 1));

    Inc(J);
  until J = 25;

  S := '';

  for I := 0 to 24 do
    S := S + IntToStr(Arr[I]);

  Result := Key = S;
end;
{$ENDIF}

end.
