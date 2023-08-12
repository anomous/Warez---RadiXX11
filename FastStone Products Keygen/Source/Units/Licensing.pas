unit Licensing;

interface

uses
  DCPblowfish,
  DCPidea,
  DCPsha1,
  DCPsha512,
  SysUtils;

//------------------------------------------------------------------------------

type
  TLicenseType = (
    ltCorporateSite,
    ltCorporateWorldwide,
    ltEducationalSite,
    ltEducationalWorldwide,
    ltFamily,
    ltFixedNumber,
    ltSingleUser
  );

  TLicenseInfo = record
    Name: String;
    Count: SmallInt;
  end;

const
  LicenseList: array[TLicenseType] of TLicenseInfo = (
    (
      Name: 'Corporate Site License';
      Count: 4998;
    ),
    (
      Name: 'Corporate Worldwide License';
      Count: 4999;
    ),
    (
      Name: 'Educational Site License';
      Count: 4996;
    ),
    (
      Name: 'Educational Worldwide License';
      Count: 4997;
    ),
    (
      Name: 'Family License';
      Count: 1110;
    ),
    (
      Name: 'Fixed Number of Licenses';
      Count: -1;
    ),
    (
      Name: 'Single-User License';
      Count: 0;
    )
  );

//------------------------------------------------------------------------------

type
  TProductInfo = record
    Name: String;
    Id: String;
  end;

const
  ProductCount = 4;
  ProductList: array[0..ProductCount - 1] of TProductInfo = (
    (
      Name: 'FastStone Capture';
      Id: '96338';
    ),
    (
      Name: 'FastStone Image Viewer';
      Id: '96332';
    ),
    (
      Name: 'FastStone MaxView';
      Id: '68386';
    ),
    (
      Name: 'FastStone Photo Resizer';
      Id: '98332';
    )
  );

//------------------------------------------------------------------------------

function GenerateRegCode(const ProductInfo: TProductInfo; const Name: String;
  LicenseType: TLicenseType; LicenseCount: Word; var RegCode: String): Boolean;
    
implementation

function EncodeLicense(const S: String; Value: Word): String;
var
  Id: String;
begin
  Result := S;

  if Length(Result) >= 8 then
  begin
    Id := Format('%.04d', [Value mod 10000]);
    Result[4] := Char(StrToInt(Id[1]) + 77);
    Result[8] := Char(StrToInt(Id[2]) + 68);
    Result[6] := Char(StrToInt(Id[3]) + 73);
    Result[2] := Char(StrToInt(Id[4]) + 80);
  end;
end;

//------------------------------------------------------------------------------

function GetAlphaStr(const S: String; Len: Integer): String;
var
  I: Integer;
begin
  Result := '';

  for I := 1 to Length(S) do
    if S[I] in ['A'..'Z'] then
      Result := Result + S[I];
      
  Result := Copy(Result, 1, Len);
end;

//------------------------------------------------------------------------------

function GenerateRegCode(const ProductInfo: TProductInfo; const Name: String;
  LicenseType: TLicenseType; LicenseCount: Word; var RegCode: String): Boolean;
var
  BlowFish: TDCP_blowfish;
  Idea: TDCP_idea;
  S0, S1, S2, S3, S4, S5: String;
  I, J, Value: Integer;
begin
  Result := False;
  S0 := Trim(Name);

  if Length(S0) < 3 then
  begin
    RegCode := 'Invalid name length';
    Exit;
  end;

  if (LicenseCount < 1) or (LicenseCount > 5000) then
  begin
    RegCode := 'Invalid license count';
    Exit;
  end;

  try
    BlowFish := TDCP_blowfish.Create(nil);
    try
      Idea := TDCP_idea.Create(nil);
      try
        repeat
          S1 := '';

          for I := 1 to 8 do
            S1 := S1 + Char(Random(26) + 65);

          Value := LicenseList[LicenseType].Count;

          if Value < 0 then
            Value := LicenseCount - 1;

          RegCode := EncodeLicense(S1, Value);
          S1 := RegCode;
          S2 := 'me4T6cBLV' + S1 + 'CpCwxrvCJZ30pKLu8Svxjhnhut437glCpofVssnFeBh2G0ekUq4VcxFintMix52vL0iJNbdtWqHPyeumkDUC+4AaoSX+xpl56Esonk4=';

          BlowFish.InitStr(S2, TDCP_sha1);

          S3 := UpperCase(S0);
          J := Length(S3);
          S4 := S1;

          for I := 1 to J do
            Insert(S3[I], S4, ((I - 1) * 2) + 1);

          S4 := S4 + Copy(S0, J + 1, MaxInt);
          S3 := S1 + ProductInfo.Id + S4;

          Idea.InitStr(S3, TDCP_sha512);

          S5 := GetAlphaStr(Idea.EncryptString(BlowFish.EncryptString(S4)), 8);

          BlowFish.InitStr('09232849248398340903834873297239340547237623242043324398489390309284343843223493299435', TDCP_sha512);
          Idea.InitStr(S3, TDCP_sha1);

          for I := Byte(S1[1]) - 50 downto 0 do
            S1 := Idea.EncryptString(S4);

          S1 := GetAlphaStr(BlowFish.EncryptString(S1), 4);
        until ((Length(S5) = 8) and (Length(S1) = 4));

        RegCode := RegCode + S5 + S1;

        for I := 1 to 3 do
          Insert('-', RegCode, I * 6);

        Result := True;

      finally
        Idea.Free;
      end;
    finally
      BlowFish.Free;
    end;
  except
    RegCode := 'Cannot generate reg code';
  end;
end;

end.
