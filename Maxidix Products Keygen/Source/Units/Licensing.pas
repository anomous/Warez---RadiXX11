unit Licensing;

interface

type
  TProductInfo = record
    Name: String;
    Pass: String;
  end;

const
  ProductCount = 5;
  ProductList: array[0..ProductCount - 1] of TProductInfo = (
    (
      Name: 'HotSpot';
      Pass: #$4F#$36#$3E#$31#$7C#$54#$4B#$71#$23#$5E#$7D#$3F#$6D#$7D#$5C#$62;
    ),
    (
      Name: 'IP Switcher';
      Pass: #$6B#$62#$79#$5B#$4A#$68#$66#$36#$6D#$2E#$35#$34#$5E#$25#$68#$6A;
    ),
    (
      Name: 'Password Angel';
      Pass: #$39#$65#$72#$24#$64#$56#$3D#$33#$6C#$6B#$70#$4F#$28#$33#$2E#$78;
    ),
    (
      Name: 'Wifi Autoconnection';
      Pass: #$40#$39#$61#$3D#$44#$6B#$7B#$73#$5A#$77#$3A#$23#$30#$2A#$21#$46;
    ),
    (
      Name: 'Wifi Suite';
      Pass: #$65#$72#$68#$24#$34#$53#$33#$38#$2A#$64#$5D#$66#$5E#$67#$2B#$2E;
    )
  );

function GenerateSerial(const ProductInfo: TProductInfo;
  const Name: String): String;

implementation

uses
  Base64,
  SHA1;

function GenerateSerial(const ProductInfo: TProductInfo;
  const Name: String): String;
var
  Digest: TSHA1Digest;
begin
  Digest := SHA1FromString(Name + ProductInfo.Pass);
  Result := Base64Encode(@Digest, SizeOf(Digest));
end;

end.
