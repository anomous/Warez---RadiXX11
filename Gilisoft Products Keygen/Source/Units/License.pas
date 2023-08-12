unit License;

interface

type
  TProductInfo = record
    Name: String;
    Id: Integer;
  end;

const
  ProductCount = 27;
  ProductList: array[0..ProductCount - 1] of TProductInfo = (
    (Name: 'Any Video Encryptor'; Id: 21878),
    (Name: 'Audio Converter Ripper'; Id: 21837),
    (Name: 'Audio Editor'; Id: 21854),
    (Name: 'Audio Recorder Pro'; Id: 21853),
    (Name: 'Audio Toolbox'; Id: 21882),
    (Name: 'EXE Lock'; Id: 21825),
    (Name: 'File Lock Pro'; Id: 21829),
    (Name: 'Full Disk Encryption'; Id: 21836),
    (Name: 'Movie DVD Converter'; Id: 21852),
    (Name: 'Movie DVD Copy'; Id: 21834),
    (Name: 'Movie DVD Creator'; Id: 21840),
    (Name: 'MP3 CD Maker'; Id: 21855),
    (Name: 'Private Disk'; Id: 21832),
    (Name: 'Privacy Protector'; Id: 21822),
    (Name: 'RAMDisk'; Id: 21826),
    (Name: 'Screen Recorder'; Id: 21838),
    (Name: 'Screen Recorder Pro'; Id: 21881),
    (Name: 'Secure Disc Creator'; Id: 21833),
    (Name: 'Slideshow Movie Creator'; Id: 21849),
    (Name: 'USB Lock'; Id: 21850),
    (Name: 'USB Stick Encryption'; Id: 21828),
    (Name: 'Video Converter'; Id: 21839),
    (Name: 'Video Cropper'; Id: 21871),
    (Name: 'Video Cutter'; Id: 21846),
    (Name: 'Video Editor'; Id: 21851),
    (Name: 'Video Splitter'; Id: 21848),
    (Name: 'Video Watermark Removal Tool'; Id: 21883)
  );

function GenerateRegCode(const ProductInfo: TProductInfo): String;

implementation

uses
  SysUtils;

function GenerateRegCode(const ProductInfo: TProductInfo): String;
var
  v1, v2, v3, v4, v5: Integer;
begin
  v1 := Random($1869F);
  v2 := Random($1869F);
  v3 := Random($1869F);
  v4 := (v1 + $C3BC) mod $1869F;
  v5 := (v2 + $C3BC) mod $1869F;
  Result := Format('%.5d-%.5d-%.5d-%.5d-%.5d-%.5d', [v1, v2, ProductInfo.Id, v5, v4, v3]);
end;

end.
