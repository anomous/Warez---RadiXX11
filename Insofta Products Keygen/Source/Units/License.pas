//------------------------------------------------------------------------------
// Insofta Products Keygen
//
// Products homepage: https://www.insofta.com
//
// © 2020, RadiXX11
// https://radixx11rce2.blogspot.com
//
// DISCLAIMER: This source code is distributed AS IS, for educational purposes
// ONLY. No other use is permitted without expressed permission from the author.
//------------------------------------------------------------------------------

unit License;

interface

type
  TSubscriptionType = (
    stOneYear,
    stOneMonth,
    stOneTime
  );

  TProductInfo = record
    Name: String;
    SubscriptionCodes: array[TSubscriptionType] of String;
  end;

const
  SubscriptionTypes: array[TSubscriptionType] of String = (
    'One-Year',
    'One-Month',
    'One-Time'
  );

  ProductList: array[0..1] of TProductInfo = (
    (
      Name: 'Insofta 3D Text Commander';
      SubscriptionCodes: ('1D', 'X2', 'M1');
    ),
    (
      Name: 'Insofta Cover Commander';
      SubscriptionCodes: ('0Y', 'M0', 'Z3');
    )
  );

function GenerateLicenseKey(const ProductInfo: TProductInfo;
  SubscriptionType: TSubscriptionType; const ExpDate: TDateTime): String;
  
implementation

uses
  SysUtils;
  
//------------------------------------------------------------------------------

function GenerateLicenseKey(const ProductInfo: TProductInfo;
  SubscriptionType: TSubscriptionType; const ExpDate: TDateTime): String;
const
  Charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
  I: Integer;
begin
  if ExpDate = MaxDateTime then
    Result := '999999'  // Unlimited (no expiration)
  else
  begin
    Result := FormatDateTime('yymmdd', ExpDate);

    if (SubscriptionType = stOneTime) and (StrToInt(Result) > 300000) then
      Result := '291231';
  end;

  // Encode expiration date
  for I := 1 to Length(Result) do
  begin
    if Result[I] <> '8' then
      Result[I] := Char(Byte(Result[I]) + I + 17);
  end;

  // Add 27 random chars
  for I := 1 to 27 do
    Result := Charset[Random(Length(Charset)) + 1] + Result;

  // Add subscription type code for this app
  Result := Charset[Random(Length(Charset)) + 1] + ProductInfo.SubscriptionCodes[SubscriptionType] + Result;

  // Complete key format
  I := 7;

  repeat
    Insert('-', Result, I);
    Inc(I, 7);
  until I > Length(Result);
end;

end.
