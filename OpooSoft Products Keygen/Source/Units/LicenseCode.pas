//------------------------------------------------------------------------------
// License Code Generator for OpooSoft Products
// Products Homepage: http://www.opoosoft.com
//
// © 2020, RadiXX11
// https://radixx11rce2.blogspot.com
//
// DISCLAIMER: This source code is distributed AS IS, for educational purposes
// ONLY. No other use is permitted without expressed permission from the author.
//------------------------------------------------------------------------------

unit LicenseCode;

interface

type
  TProductCategory = (
    pcOptTools,
    pcPDFTools,
    pcPCLTools,
    pcPSTools,
    pcXPSTools
  );

  TProductInfo = record
    Name: String;
    Category: TProductCategory;
    Values: array[0..7] of Byte; // Unique set of values for each app
  end;

const
  Categories: array[TProductCategory] of String = (
    'Optimization Tools',
    'PDF Tools',
    'PCL Tools',
    'PS Tools',
    'XPS Tools'
  );

  ProductList: array[0..44] of TProductInfo = (
    // Optimization Tools //////////////////////////////////////////////////////
    (
      Name: 'PDF Decrypt';
      Category: pcOptTools;
      Values: ($01, $05, $0B, $0D, $12, $16, $19, $1D);
    ),
    (
      Name: 'PDF Decrypt Command Line';
      Category: pcOptTools;
      Values: ($01, $05, $0A, $0C, $13, $14, $18, $1E);
    ),
    (
      Name: 'PDF Encrypt';
      Category: pcOptTools;
      Values: ($01, $05, $0B, $0F, $10, $16, $19, $1D);
    ),
    (
      Name: 'PDF Encrypt Command Line';
      Category: pcOptTools;
      Values: ($01, $05, $0A, $0F, $10, $14, $18, $1E);
    ),
    (
      Name: 'PDF Split-Merge';
      Category: pcOptTools;
      Values: ($01, $05, $08, $0D, $11, $15, $19, $1D);
    ),
    (
      Name: 'PDF Split-Merge Command Line';
      Category: pcOptTools;
      Values: ($02, $07, $0B, $0E, $12, $17, $1A, $1F);
    ),
    (
      Name: 'PDF Stamp';
      Category: pcOptTools;
      Values: ($01, $06, $09, $0E, $13, $17, $18, $1D);
    ),
    (
      Name: 'PDF Stamp Command Line';
      Category: pcOptTools;
      Values: ($00, $05, $0B, $0D, $13, $15, $19, $1E);
    ),
    (
      Name: 'Print To PDF';
      Category: pcOptTools;
      Values: ($02, $07, $08, $0D, $13, $16, $1B, $1D);
    ),
    
    // PDF Tools ///////////////////////////////////////////////////////////////
    (
      Name: 'IMAGE To PDF Converter';
      Category: pcPDFTools;
      Values: ($03, $07, $0B, $0C, $10, $17, $1B, $1F);
    ),
    (
      Name: 'IMAGE To PDF Command Line';
      Category: pcPDFTools;
      Values: ($03, $05, $08, $0C, $11, $15, $19, $1C);
    ),
    (
      Name: 'JPEG To PDF Converter';
      Category: pcPDFTools;
      Values: ($00, $06, $0B, $0E, $12, $14, $19, $1E);
    ),
    (
      Name: 'JPEG To PDF Command Line';
      Category: pcPDFTools;
      Values: ($02, $06, $0A, $0F, $13, $16, $1A, $1D);
    ),
    (
      Name: 'PDF TEXT Converter';
      Category: pcPDFTools;
      Values: ($03, $07, $0B, $0F, $12, $16, $19, $1C);
    ),
    (
      Name: 'PDF TEXT Command Line';
      Category: pcPDFTools;
      Values: ($02, $07, $0B, $0E, $13, $17, $1A, $1C);
    ),
    (
      Name: 'PDF To HTML Converter';
      Category: pcPDFTools;
      Values: ($01, $05, $0B, $0C, $13, $16, $18, $1C);
    ),
    (
      Name: 'PDF To HTML Command Line';
      Category: pcPDFTools;
      Values: ($03, $06, $08, $0E, $13, $14, $19, $1D);
    ),
    (
      Name: 'PDF To IMAGE Converter';
      Category: pcPDFTools;
      Values: ($00, $06, $09, $0C, $10, $17, $18, $1F);
    ),
    (
      Name: 'PDF To IMAGE Command Line';
      Category: pcPDFTools;
      Values: ($00, $05, $09, $0C, $13, $14, $18, $1E);
    ),
    (
      Name: 'PDF To JPEG Converter';
      Category: pcPDFTools;
      Values: ($01, $05, $0A, $0E, $11, $16, $18, $1D);
    ),
    (
      Name: 'PDF To JPEG Command Line';
      Category: pcPDFTools;
      Values: ($01, $04, $0B, $0E, $12, $16, $19, $1C);
    ),
    (
      Name: 'PDF To More Converter';
      Category: pcPDFTools;
      Values: ($02, $06, $0B, $0F, $10, $17, $18, $1C);
    ),
    (
      Name: 'PDF To More Command Line';
      Category: pcPDFTools;
      Values: ($03, $06, $09, $0C, $11, $16, $19, $1D);
    ),
    (
      Name: 'PDF To TIFF Converter';
      Category: pcPDFTools;
      Values: ($03, $07, $08, $0D, $13, $14, $1A, $1C);
    ),
    (
      Name: 'PDF To TIFF Command Line';
      Category: pcPDFTools;
      Values: ($03, $07, $08, $0F, $10, $17, $1B, $1F);
    ),
    (
      Name: 'TIFF To PDF Converter';
      Category: pcPDFTools;
      Values: ($02, $05, $09, $0F, $13, $16, $18, $1C);
    ),
    (
      Name: 'TIFF To PDF Command Line';
      Category: pcPDFTools;
      Values: ($01, $04, $0B, $0D, $12, $14, $18, $1D);
    ),

    // PCL Tools ///////////////////////////////////////////////////////////////
    (
      Name: 'PCL To IMAGE Converter';
      Category: pcPCLTools;
      Values: ($01, $05, $0A, $0D, $12, $14, $18, $1D);
    ),
    (
      Name: 'PCL To IMAGE Command Line';
      Category: pcPCLTools;
      Values: ($03, $05, $0A, $0D, $10, $14, $18, $1D);
    ),
    (
      Name: 'PCL To PDF Converter';
      Category: pcPCLTools;
      Values: ($01, $04, $08, $0F, $10, $15, $19, $1C);
    ),
    (
      Name: 'PCL To PDF Command Line';
      Category: pcPCLTools;
      Values: ($03, $04, $08, $0C, $10, $15, $1A, $1C);
    ),
    (
      Name: 'PCL To TIFF Converter';
      Category: pcPCLTools;
      Values: ($00, $06, $0B, $0C, $13, $17, $19, $1E);
    ),
    (
      Name: 'PCL To TIFF Command Line';
      Category: pcPCLTools;
      Values: ($02, $06, $0B, $0F, $13, $17, $19, $1E);
    ),

    // PS Tools ////////////////////////////////////////////////////////////////
    (
      Name: 'PDF To PS Converter';
      Category: pcPSTools;
      Values: ($00, $04, $0A, $0C, $10, $14, $18, $1C);
    ),
    (
      Name: 'PDF To PS Command Line';
      Category: pcPSTools;
      Values: ($03, $07, $09, $0F, $13, $15, $1A, $1E);
    ),    
    (
      Name: 'PS To IMAGE Converter';
      Category: pcPSTools;
      Values: ($01, $05, $0B, $0C, $10, $14, $18, $1C);
    ),
    (
      Name: 'PS To IMAGE Command Line';
      Category: pcPSTools;
      Values: ($03, $06, $0B, $0C, $13, $17, $18, $1D);
    ),
    (
      Name: 'PS To PDF Converter';
      Category: pcPSTools;
      Values: ($01, $07, $09, $0F, $10, $16, $18, $1C);
    ),
    (
      Name: 'PS To PDF Command Line';
      Category: pcPSTools;
      Values: ($00, $04, $0B, $0C, $13, $14, $18, $1D);
    ),

    // XPS Tools ///////////////////////////////////////////////////////////////
    (
      Name: 'XPS To IMAGE Converter';
      Category: pcXPSTools;
      Values: ($00, $05, $09, $0E, $11, $15, $19, $1D);
    ),
    (
      Name: 'XPS To IMAGE Command Line';
      Category: pcXPSTools;
      Values: ($03, $05, $08, $0C, $10, $17, $1B, $1E);
    ),
    (
      Name: 'XPS To PDF Converter';
      Category: pcXPSTools;
      Values: ($01, $06, $0B, $0C, $12, $15, $19, $1D);
    ),
    (
      Name: 'XPS To PDF Command Line';
      Category: pcXPSTools;
      Values: ($02, $05, $0A, $0E, $10, $17, $1A, $1E);
    ),
    (
      Name: 'XPS To TIFF Converter';
      Category: pcXPSTools;
      Values: ($02, $06, $08, $0F, $13, $16, $18, $1F);
    ),
    (
      Name: 'XPS To TIFF Command Line';
      Category: pcXPSTools;
      Values: ($01, $07, $0A, $0D, $13, $14, $19, $1E);
    )
  );

function GenerateLicenseCode(const ProductInfo: TProductInfo): String;

implementation

function GenerateLicenseCode(const ProductInfo: TProductInfo): String;
const
  Charset = 'XVUTEQYONMLGIHJZFSDCBARKWP';
var
  Index: array[0..31] of Integer;
  I, J, K: Integer;
begin
  // Initialize with random indexes

  for I := 0 to 31 do
    Index[I] := Random(26);

  // Generate the first group of indexes: 0 to 23

  I := 0;

  for J := 0 to 5 do
  begin
    repeat
      repeat
        Index[I] := Random(26);
        Index[I + 1] := Random(26);
        Index[I + 2] := Random(26);
        Index[I + 3] := Random(26);
        Index[ProductInfo.Values[J]] := Random(26);
        K := (Index[I] + Index[I + 1] + Index[I + 2] + Index[I + 3] - Index[ProductInfo.Values[J]]) mod 26;
      until K >= ProductInfo.Values[J];
    until Index[ProductInfo.Values[J]] = (K - ProductInfo.Values[J]);

    Inc(I, 4);
  end;

  // Generate the second group of indexes: 24 to 27

  repeat
    repeat
      Index[24] := Random(26);
      Index[25] := Random(26);
      Index[26] := Random(26);
      Index[27] := Random(26);
      Index[ProductInfo.Values[6]] := Random(26);
      K := (Index[24] + Index[25] + Index[26] + Index[27] - Index[ProductInfo.Values[6]]) mod 26;
    until K >= (ProductInfo.Values[0] - ProductInfo.Values[6]);
  until Index[ProductInfo.Values[6]] = (K + ProductInfo.Values[0] - ProductInfo.Values[6]);

  // Generate the last group of indexes: 28 to 31

  repeat
    repeat
      Index[28] := Random(26);
      Index[29] := Random(26);
      Index[30] := Random(26);
      Index[31] := Random(26);
      Index[ProductInfo.Values[7]] := Random(26);
      K := (Index[28] + Index[29] + Index[30] + Index[31] - Index[ProductInfo.Values[7]]) mod 26;
    until K >= (ProductInfo.Values[1] - ProductInfo.Values[7]);
  until Index[ProductInfo.Values[7]] = (K + ProductInfo.Values[1] - ProductInfo.Values[7]);

  // Convert indexes into chars in the charset to make the license code

  SetLength(Result, 32);

  for I := 0 to 31 do
    Result[I + 1] := Charset[Index[I] + 1];
end;

end.
