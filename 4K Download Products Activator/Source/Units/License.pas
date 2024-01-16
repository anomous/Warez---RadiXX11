unit License;

interface

type
  TProductInfo = record
    Id: Integer;
    Name: String;
    RegKey: String;
  end;

const
  ProductList: array[0..5] of TProductInfo = (
    (
      Id: 109;
      Name: '4K Image Compressor';
      RegKey: 'SOFTWARE\4kdownload.com\4K Image Compressor\License';
    ),
    (
      Id: 105;
      Name: '4K Stogram';
      RegKey: 'SOFTWARE\4kdownload.com\4K Stogram\License';
    ),
    (
      Id: 107;
      Name: '4K Tokkit';
      RegKey: 'SOFTWARE\4kdownload.com\4K Tokkit\License';
    ),
    (
      Id: 108;
      Name: '4K Video Downloader+';
      RegKey: 'SOFTWARE\4kdownload.com\4K Video Downloader+\License';
    ),
    (
      Id: 101;
      Name: '4K Video Downloader';
      RegKey: 'SOFTWARE\4kdownload.com\4K Video Downloader\License';
    ),
    (
      Id: 103;
      Name: '4K YouTube To MP3';
      RegKey: 'SOFTWARE\4kdownload.com\4K YouTube to MP3\License';
    )
  );

type
  TActivationResult = (
    arOk,
    arInvalidExpirationDate,
    arCannotWriteRegistryEntry
  );
  
function ActivateProduct(const ProductInfo: TProductInfo; ExpDate: TDateTime): TActivationResult;

implementation

uses
  Windows,
  DateUtils,
  DCPbase64,
  DCPrijndael,
  Registry,
  SysUtils;

//--------------------------------------------------------------------------------------------------

const
  AESKey            = #$FC#$6B#$FB#$1D#$71#$26#$4F#$BB#$0F#$B6#$C8#$7B#$5E#$02#$B2#$01#$4B#$37#$33#$7D#$A7#$CB#$DE#$69#$83#$3A#$80#$F3#$EB#$6A#$EC#$A6;
  ByteArrayFormat   = '@ByteArray(%s)';
  LicenseDataFormat = '{"product_id":"%d","license_key":"%s","expiration_date":"%.4d-%.2d-%.2d"}';
  LicenseBodyFormat = '{"data":"%s","key":"1/9u//1/4FiVYqZ+M70mpdu0SCW+uUifnSIuqFdzR+n1OEudKiMQPz9eu5eNspQ30XZxFYWt48VleDqsGU/o4nKcbGRXwWL2' +
                      'haq6vl4lIoQ6xzS5AOR1zIHR3zl3fpfokKxzpOSQnc3n+eFRzUWhBgOaoXw46y+sbDcIOX04sdajOLhBgk2k9X3jnFYM0A1wWus1Mo+lA8G8zDieH2LB' +
                      'OClzGJVEJtcKbnVlPIASzLAXgP3Om/iXpcJR79Ff6ABLiMZGUZ9D8mhSMuMVX5yEQ1pssvL1O/JfFzu2l6l3UZU63Xyb77eqBYeyRrIYUf3SKmGHdAB5uDyPlFbO3V6l9Q=="}';

//--------------------------------------------------------------------------------------------------

procedure PKCS7BytePadding(var Data: String; BlockSize: Integer);
var
  DataBlocks, DataLength, PaddingStart, PaddingCount: integer;
begin
  BlockSize := BlockSize div 8; // convert bits to bytes
  DataBlocks := (Length(Data) div BlockSize) + 1;
  DataLength := DataBlocks * BlockSize;
  PaddingCount := DataLength - Length(Data);

  // PKCS7 store the padding length in a 1 byte end-marker, so any padding length > $FF is not supported
  if PaddingCount > $FF then
    Exit;

  PaddingStart := Length(Data) + 1;
  SetLength(Data, DataLength);
  FillChar(Data[PaddingStart], PaddingCount, PaddingCount);
end;

//--------------------------------------------------------------------------------------------------

function AESEncryptToBase64(const S, Key: String): String;
const
  IV: array[0..15] of Byte = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
begin
  with TDCP_rijndael.Create(nil) do
  try
    Init(Key[1], Length(Key) * 8, @IV);
    Result := S;
    PKCS7BytePadding(Result, BlockSize);
    EncryptCBC(Result[1], Result[1], Length(Result));
    Result := Base64EncodeStr(Result);
  finally
    Free;
  end;
end;

//--------------------------------------------------------------------------------------------------

function GenerateKey: String;
var
  I: Integer;
begin
  Result := '';

  for I := 1 to 16 do
    Result := Result + IntToHex(Random(256), 2);

  Insert('-', Result, 9);
  Insert('-', Result, 14);
  Insert('-', Result, 19);
  Insert('-', Result, 24);
  
  Result := LowerCase(Result);
end;

//--------------------------------------------------------------------------------------------------

function ActivateProduct(const ProductInfo: TProductInfo; ExpDate: TDateTime): TActivationResult;
var
  LicenseBody: String;
  Y, M, D: Word;
begin
  Result := arOk;

  if CompareDate(ExpDate, Now) <= 0 then
  begin
    Result := arInvalidExpirationDate;
    Exit;
  end;

  DecodeDate(ExpDate, Y, M, D);

  LicenseBody := AESEncryptToBase64(Format(LicenseDataFormat, [ProductInfo.Id, GenerateKey, Y, M, D]), AESKey);
  LicenseBody := Base64EncodeStr(Format(LicenseBodyFormat, [LicenseBody]));
  LicenseBody := Format(ByteArrayFormat, [LicenseBody]);

  try
    with TRegistry.Create do
    try
      RootKey := HKEY_CURRENT_USER;

      if not OpenKey(ProductInfo.RegKey, True) then
      begin
        Result := arCannotWriteRegistryEntry;
        Exit;
      end;

      WriteString('licenseBody', LicenseBody);
      CloseKey;

    finally
      Free;
    end;
  except
    Result := arCannotWriteRegistryEntry;
  end;
end;

end.
