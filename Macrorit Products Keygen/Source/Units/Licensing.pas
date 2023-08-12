unit Licensing;

interface

type
  TEditionType = (
    etEnterpriseLTFU,
    etProfessional,
    etProfessionalLTFU,
    etServerLTFU,
    etTechnician,
    etUnlimited
  );

const
  EditionTypeStr: array[TEditionType] of String = (
    'Enterprise Life-time FREE Upgrades',
    'Professional',
    'Professional Life-time FREE Upgrades',
    'Server Life-time FREE Upgrades',
    'Technician',
    'Unlimited'
  );

type
  TProductInfo = record
    Name: String;
    EditionTypeId: array[TEditionType] of String;
  end;

const
  ProductCount = 4;
  ProductList: array[0..ProductCount - 1] of TProductInfo = (
    (
      Name: 'Data Wiper 4.x';
      EditionTypeId: (
        'MDE-WIPER-ENTE_2',
        'MDE-WIPER-PROFH_2',
        'MDE-WIPER-PROF_2',
        'MDE-WIPER-SERV_2',
        'MDE-WIPER-TECH',
        'MDE-WIPER-UNLIMITED'
      );
    ),  
    (
      Name: 'Disk Scanner 4.x';
      EditionTypeId: (
        'MDE-SCANNERENTE_2',
        'MDE-SCANNERPROFH_2',
        'MDE-SCANNERPROF_2',
        'MDE-SCANNERSERV_2',
        'MDE-SCANNERTECH',
        'MDE-SCANNERUNLIMITED'
      );
    ),
    (
      Name: 'Partition Expert 4.x';
      EditionTypeId: (
        'MDE-ENTE_2',
        'MDE-PROFH_2',
        'MDE-PROF_2',
        'MDE-SERV_2',
        'MDE-TECH',
        'MDE-UNLIMITED'
      );
    ),
    (
      Name: 'Partition Extender 1.x';
      EditionTypeId: (
        'MDE-MPEX-ENTE_2',
        'MDE-MPEX-PROFH_2',
        'MDE-MPEX-PROF_2',
        'MDE-MPEX-SERV_2',
        'MDE-MPEX-TECH',
        'MDE-MPEX-UNLIMITED'
      );
    )    
  );

function GenerateKey(const EditionTypeId: String): String;

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

function GenerateKey(const EditionTypeId: String): String;
const
  Password = 'max.wang';
var
  I, J, C: Integer;
  B: Byte;
begin
  B := Random(256);

  Result := IntToHex(B, 2);

  J := 0;
  for I := 1 to Length(EditionTypeId) do
  begin
    C := Byte(EditionTypeId[I]) + B - 255;

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
