unit Licensing;

interface

type
  TProductInfo = record
    Name: String;   // Product name
    Key: String;    // Registry key where activation info must be written
    Params: String; // If UseEncription=TRUE -> parameters (M,p,a,b,x) for ElGamal algo
                    // If UseEncription=FALSE -> magic string for MD5 hash algo
    UseEC: Boolean; // TRUE -> use ElGamal encription algo
                    // FALSE -> use simple MD5 hash algo
  end;

const
  ProductCount = 16;
  ProductList: array[0..ProductCount - 1] of TProductInfo = (
    (
      Name: 'Digital Editions Converter';
      Key: 'Software\pdfsvg\DigitalEditions';
      Params: 'Digital,jDMzO1K3pTKLli,Ai,aa,MRi=LZ8=P6ds';
      UseEC: True;
    ),
    (
      Name: 'eBook Converter Bundle';
      Key: 'Software\eBookConverter\ebookConverter';
      Params: '()&^%#:';
      UseEC: False;
    ),
    (
      Name: 'eBook DRM Removal Bundle';
      Key: 'Software\eBookConverter\ebookDRMRemoval';
      Params: '*&^()f';
      UseEC: False;
    ),
    (
      Name: 'ePub Converter';
      Key: 'Software\eBookConverter\ePubConverter';
      Params: '(e34#:';
      UseEC: False;
    ),
    (
      Name: 'ePub DRM Removal';
      Key: 'Software\eBookConverter\ePubDRM';
      Params: '?></]';
      UseEC: False;
    ),
    (
      Name: 'Google Books Download';
      Key: 'Software\ebook-converter.com\Google eBook Downloader\Program';
      Params: 'google';
      UseEC: False;
    ),
    (
      Name: 'Kindle Converter';
      Key: 'Software\eBookConverter\kindleConverter';
      Params: 'GM(e4#:';
      UseEC: False;
    ),
    (
      Name: 'Kindle DRM Removal';
      Key: 'Software\eBookConverter\KindleDRMRemoval';
      Params: '4df*$';
      UseEC: False;
    ),
    (
      Name: 'Kindle PC Converter';
      Key: 'Software\pdfsvg\KindPc';
      Params: 'KindleP,oCCyoZIrldy1oy,aa,ay,krxtcySGmhi';
      UseEC: True;
    ),
    (
      Name: 'Kobo Converter';
      Key: 'Software\eBookConverter\KoboConverter';
      Params: '(e34#:';
      UseEC: False;
    ),
    (
      Name: 'Mobipocket Converter';
      Key: 'Software\pdfsvg\Mobipocket';
      Params: 'Mobipoc,JTIgkRCLjSMBNi,aq,aa,IQIiUYNduD0';
      UseEC: True;
    ),
    (
      Name: 'Mobipocket DRM Removal';
      Key: 'Software\eBookConverter\MobipocketDRMRemoval';
      Params: '{"&M#$';
      UseEC: False;
    ),
    (
      Name: 'NOOK ebook to PDF Converter';
      Key: 'Software\myebook\BNConverter';
      Params: 'BNReade,jtG1os9bhdICGi,ba,aa,wtCH7AiUINu';
      UseEC: True;
    ),
    (
      Name: 'NOOK DRM Removal';
      Key: 'Software\eBookConverter\NookDRM';
      Params: '78></]';
      UseEC: False;
    ),
    (
      Name: 'PDB DRM Removal';
      Key: 'Software\eBookConverter\PDBDRMRemoval';
      Params: '|[}\*()';
      UseEC: False;
    ),
    (
      Name: 'PDF ePub DRM Removal';
      Key: 'Software\eBookConverter\PDFDRM';
      Params: '?></]';
      UseEC: False;
    )
  );

function ActivateProduct(const ProductInfo: TProductInfo): Boolean;
function ProductIsActivated(const ProductInfo: TProductInfo): Boolean;

implementation

uses
  Windows,
  Classes,
  ECElGamal,
  ECGFp,
  FGInt,
  MD5,
  Registry,
  SysUtils;

//------------------------------------------------------------------------------

function ActivateUsingEC(const ProductInfo: TProductInfo): Boolean;
var
  g, y: TECPoint;
  p, a, b, x, k, tmp: TFGInt;
  S, Key: String;
begin
  Result := False;
  Key := '';

  try
    with TStringList.Create do
    try
      CommaText := ProductInfo.Params;

      // Number of parameters must be 5
      if Count = 5 then
      begin
        // Extract parameters
        ConvertBase64to256(Strings[1], S);   // param p
        Base256StringToFGInt(S, p);
        ConvertBase64to256(Strings[2], S);   // param a
        Base256StringToFGInt(S, a);
        ConvertBase64to256(Strings[3], S);   // param b
        Base256StringToFGInt(S, b);
        Base256StringToFGInt(Strings[4], x); // param x
        Base10StringToFGInt(IntToStr(Random(MaxInt) + 1), Tmp);
        FGIntRandom1(Tmp, k);
        Base2StringToFGInt('1', Tmp);
        FGIntCopy(Tmp, g.XCoordinate);
        FGIntCopy(Tmp, g.YCoordinate);
        g.Infinity := False;
        ECFindNextPointOnEC(p, a, b, g);
        ECPointkmultiple(g, p, a, x, y);

        // Encript secret word and create key
        ECElGamalEncrypt(Strings[0], p, a, b, k, g, y, False, S);
        Base256StringToFGInt(S, Tmp);
        FGIntToBase2String(Tmp, S);
        ConvertBase2to64(S, Key);
      end;

    finally
      // Cleanup
      FGIntDestroy(p);
      FGIntDestroy(a);
      FGIntDestroy(b);
      FGIntDestroy(x);
      FGIntDestroy(k);
      FGIntDestroy(Tmp);
      ECPointDestroy(g);
      ECPointDestroy(y);
      Free;
    end;
  except
    Key := '';
  end;

  // Save key to registry if available
  if Key <> '' then
  begin
    try
      with TRegistry.Create do
      try
        RootKey := HKEY_CURRENT_USER;

        if OpenKey(ProductInfo.Key, True) then
        begin
          WriteString('Key', Key);
          CloseKey;
          Result := True;
        end;

      finally
        Free;
      end;
    except
      Result := False;
    end;
  end;
end;

//------------------------------------------------------------------------------

function ActivateUsingHash(const ProductInfo: TProductInfo): Boolean;
const
  // Key charset (any set of chars can be used here)
  Charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
var
  SN, Key: String;
  I: Integer;
begin
  Result := False;
  
  try
    // Generate a random key with 16 characters (can be any other length, just
    // choosed to match SN length)
    SetLength(Key, 16);

    for I := 1 to Length(Key) do
      Key[I] := Charset[Random(Length(Charset)) + 1];

    // Calculate SN from generated key (first 16 characters of MD5 from
    // Key + magic string)
    SN := Copy(MD5ToString(MD5FromString(Key + ProductInfo.Params)), 1, 16);

    // Save generated values to registry
    with TRegistry.Create do
    try
      RootKey := HKEY_CURRENT_USER;

      if OpenKey(ProductInfo.Key, True) then
      begin
        WriteString('Key', Key);
        WriteString('SN', SN);
        CloseKey;
        Result := True;
      end;

    finally
      Free;
    end;
  except
    Result := False;
  end;
end;

//------------------------------------------------------------------------------

function ActivateProduct(const ProductInfo: TProductInfo): Boolean;
begin
  if ProductInfo.UseEC then
    Result := ActivateUsingEC(ProductInfo)
  else
    Result := ActivateUsingHash(ProductInfo);
end;

//------------------------------------------------------------------------------

function ProductIsActivated(const ProductInfo: TProductInfo): Boolean;
begin
  Result := False;

  try
    with TRegistry.Create(KEY_READ) do
    try
      RootKey := HKEY_CURRENT_USER;

      if OpenKey(ProductInfo.Key, False) then
      begin
        if ProductInfo.UseEC then
          Result := ValueExists('Key')
        else
          Result := ValueExists('Key') and ValueExists('SN');

        CloseKey;
      end;

    finally
      Free;
    end;
  except
    Result := False;
  end;
end;

end.
