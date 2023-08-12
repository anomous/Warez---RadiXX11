unit Licensing;

interface

type
  TLicenseType = (
    ltPersonal,
    ltCyberCoffee,
    ltBusiness
  );

const
  LicenseTypes: array[TLicenseType] of String = (
    'Personal',
    'CyberCoffee',
    'Business'
  );

function GetLicenseKey(const Name: String; LicenseType: TLicenseType): String;

implementation

uses
  SysUtils;

function GetLicenseKey(const Name: String; LicenseType: TLicenseType): String;
const
  Data: array[0..21] of Byte = ($26, $38, $39, $39, $63, $0F, $3A, $0C, $0D, $11, $13, $12, $58, $3A, $34, $34, $0C, $0D, $0C, $39, $34, $62);
var
  Buffer: array[0..2] of Integer;
  S1, S2: String;
  I, J, Len, A, B: Integer;
begin
  S1 := UpperCase(Name);
  S2 := '';

  for I := 1 to Length(S1) do
    if S1[I] in ['0'..'9', 'A'..'Z'] then
      S2 := S2 + S1[I];

  FillChar(Buffer, SizeOf(Buffer), 0);
  Len := Length(S2);
  J := 0;

  for I := 1 to Len do
  begin
    Buffer[J] := ((Ord(S2[I]) * Len) + Buffer[J]) mod $64;
    Inc(J);
    
    if J > 2 then
      J := 0;
  end;

  A := 0;
  J := 0;
  B := Buffer[j];

  for I := 1 to 5 do
  begin
    A := ((B * Len) + a) mod $16;

    Inc(J);

    if J > 2 then
    begin
      if LicenseType = ltPersonal then
      begin
        if J = 4 then
          B := 0
        else
          B := $50;
      end
      else
        B := $63;
    end
    else
      B := Buffer[J];
  end;

  case LicenseType of
    ltPersonal:
      Result := Format('08%.2d00%.2d%.2d%.2d', [Data[A], Buffer[0], Buffer[1], Buffer[2]]);

    ltCyberCoffee:
      Result := Format('77%.2d77%.2d%.2d%.2d', [Data[A], Buffer[0], Buffer[1], Buffer[2]]);

    ltBusiness:
      Result := Format('99%.2d99%.2d%.2d%.2d', [Data[A], Buffer[0], Buffer[1], Buffer[2]]);
  end;
end;

end.
