unit Licensing;

interface

type
  TProductInfo = record
    Name: String;
    EditionValue: String;
  end;

const
  ProductCount = 4;
  ProductList: array[0..ProductCount - 1] of TProductInfo = (
    (
      Name: 'CrossFTP Enterprise (Site License)';
      EditionValue: '27';
    ),
    (
      Name: 'CrossFTP Enterprise (Multi-User License)';
      EditionValue: '40';
    ),
    (
      Name: 'CrossFTP Pro (Multi-User License)';
      EditionValue: '10';
    ),
    (
      Name: 'CrossFTP Pro (Single User License)';
      EditionValue: '07';
    )
  );

function GenerateKey(const ProductInfo: TProductInfo;
  const Name, EMail: String): String;

implementation

uses
  MD5,
  SysUtils;

//------------------------------------------------------------------------------

function StrToHex(const S: String): String;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(S) do
    Result := Result + IntToHex(Ord(S[I]), 2);
end;

//------------------------------------------------------------------------------

function GenerateKey(const ProductInfo: TProductInfo;
  const Name, EMail: String): String;
var
  S: String;
begin
  // Check if Name or EMail are empty
  if (Name = '') or (EMail = '') then
  begin
    Result := '1';
    Exit;
  end;

  S := StrToHex(Name) + '7C' + StrToHex(EMail);

  // Check if Name or EMail must be shorter
  if Length(S) >= 126 then
  begin
    Result := '2';
    Exit;
  end;

  // Calculate and return key
  S := S + StringOfChar('0', 127 - Length(S)) + ProductInfo.EditionValue +
        'FFFFFFFFFFFFFFF';
  Result := S + MD5ToString(MD5FromString(S + 'B639229835D842E3FB4EE89CD8FAE6CB'), True);
end;

end.
