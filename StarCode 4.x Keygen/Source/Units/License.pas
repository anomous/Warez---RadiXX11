unit License;

interface

type
  TProductEdition = (pePro, pePlus, peLite);

function GenerateKeys(ProductEdition: TProductEdition;
  const MachineCode: String; var LicenseKey, ActivationKey: String): Boolean;

implementation

uses
  MD5,
  SysUtils;

//------------------------------------------------------------------------------

const
  ProductCode: array[TProductEdition] of Byte = (10, 12, 14);

//------------------------------------------------------------------------------

function ValidateMachineCode(const MachineCode: String): Boolean;
var
  S: String;
  I: Integer;
begin
  Result := False;
  S := UpperCase(Trim(MachineCode));

  if Length(S) = 35 then
  begin
    for I := 1 to 35 do
    begin
      if ((S[I] = '-') and ((I mod 9) <> 0)) or
          (not (S[I] in ['-', '0'..'9', 'A'..'F'])) then Exit;
    end;

    Result := True;
  end;
end;

//------------------------------------------------------------------------------

function GenerateKeys(ProductEdition: TProductEdition;
  const MachineCode: String; var LicenseKey, ActivationKey: String): Boolean;
var
  I: Integer;
begin
  if ValidateMachineCode(MachineCode) then
  begin
    // Generate the license key

    I := Random(MaxInt) + 1;
    LicenseKey := Format('%d-PC000%.2dlC?t48lh52J~La-wRMC(D+>{~A|&U}e?tqEdj>dF_f+p(,1gnl$jxh-xNlVhKBD2', [I, ProductCode[ProductEdition]]);
    LicenseKey := Copy(MD5ToString(MD5FromString(LicenseKey), True), 9, MaxInt);
    LicenseKey := IntToHex(I, 8) + LicenseKey;

    Insert('-', LicenseKey, 9);
    Insert('-', LicenseKey, 18);
    Insert('-', LicenseKey, 27);

    // Make the activation key from license key and machine code

    ActivationKey := LicenseKey + UpperCase(Trim(MachineCode)) + 'HhdJzn}/@.MfH~Om{i<YjfKcf.Eu$jpq';
    ActivationKey := MD5ToString(MD5FromString(ActivationKey), True);

    Insert('-', ActivationKey, 9);
    Insert('-', ActivationKey, 18);
    Insert('-', ActivationKey, 27);

    Result := True;
  end
  else
    Result := False;
end;

end.
