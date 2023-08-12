unit Licensing;

interface

type
  TEditionType = (
    etAdmin,
    etEnterprise,
    etEnterpriseLTFU,
    etProBU,
    etProHU,
    etProfessional,
    etProfessionalLTFU,
    etServer,
    etServerLTFU,
    etTechnician,
    etUnlimited,
    etUnlimited5C,
    etUnlimited30C,
    etUnlimitedUC
  );

const
  EditionTypeId: array[TEditionType] of String = (
    'MDE-OEM1-ADMIN-.23',
    'MDE-OEM1-ENTE-.23',
    'MDE-OEM1-ENTE_2',
    'MDE-OEM1-PROFB_2',
    'MDE-OEM1-PROFH_2',
    'MDE-OEM1-PROF-.23',
    'MDE-OEM1-PROF_2',
    'MDE-OEM1-SERV-.23',
    'MDE-OEM1-SERV_2',
    'MDE-OEM1-TECH',
    'MDE-OEM1-UNLIMITED',
    'MDE-OEM1-UNLI_1',
    'MDE-OEM1-UNLI_2',
    'MDE-OEM1-UNLI_3'
  );
    
const
  EditionTypeStr: array[TEditionType] of String = (
    'Admin Edition',
    'Enterprise Edition',
    'Enterprise Edition + Life-time FREE Upgrades',
    'Pro for Business Users',
    'Pro for Home Users',
    'Professional Edition',
    'Professional Edition + Life-time FREE Upgrades',
    'Server Edition',
    'Server Edition + Life-time FREE Upgrades',
    'Technician Edition',
    'Unlimited Edition',
    'Unlimited Edition (5 Computers)',
    'Unlimited Edition (30 Computers)',
    'Unlimited Edition (Unlimited Computers)'
  );


function GenerateKey(const EditionType: TEditionType): String;

implementation

uses
  SysUtils;

//------------------------------------------------------------------------------
{$IFDEF DEBUG}
function DecodeKey(const Key: String): String;
const
  Password = 'max.wang';
var
  I, J, V1, V2, V3: Integer;
begin
  Result := '';
  V1 := StrToInt('$' + Copy(Key, 1, 2));
  I := 3;
  J := 0;

  repeat
    V2 := StrToInt('$' + Copy(Key, I, 2));

    if J = Length(Password) then
      J := 0;

    Inc(J);

    V3 := Byte(Password[J]) xor V2;

    if V3 > V1 then
      Dec(V3, V1)
    else
      V3 := V3 - V1 + 255;

    Result := Result + Char(V3);
    V1 := V2;

    Inc(I, 2);
  until I >= Length(Key);
end;
{$ENDIF}

//------------------------------------------------------------------------------

function GenerateKey(const EditionType: TEditionType): String;
const
  Password = 'max.wang';
var
  Id: String;
  I, J, C: Integer;
  B: Byte;
begin
  Id := EditionTypeId[EditionType];
  B := Random(256);

  Result := IntToHex(B, 2);

  J := 0;
  for I := 1 to Length(Id) do
  begin
    C := Byte(Id[I]) + B - 255;

    if C < 0 then
      C := C + 255;

    if J = Length(Password) then
      J := 0;

    Inc(J);

    C := C xor Byte(Password[J]);

    Result := Result + IntToHex(C, 2);

    B := C;
  end;
end;

end.
