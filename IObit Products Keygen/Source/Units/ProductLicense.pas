//==============================================================================
// Supported products list
//------------------------------------------------------------------------------
// IObit Products Keygen
// © 2016, RadiXX11
//------------------------------------------------------------------------------
// DISCLAIMER
//
// This program is provided "AS IS" without any warranty, either expressed or
// implied, including, but not limited to, the implied warranties of
// merchantability and fitness for a particular purpose.
//
// This program and its source code are distributed for educational and
// practical purposes ONLY.
//
// You are not allowed to get a monetary profit of any kind through its use.
//
// The author will not take any responsibility for the consequences due to the
// improper use of this program and/or its source code.
//==============================================================================

unit ProductLicense;

interface

uses
  LicenseCode;

const
  // List of supported products from IObit; note that the VerifyCode pointer
  // will be valid only if the keygen was compiled with the DEBUG conditional
  // flag.
  ProductCount = 9;
  ProductList: array[0..ProductCount - 1] of TProductInfo = (
    (
      Name: 'Advanced SystemCare PRO';
      Host: 'asc.iobit.com';
      Version: 10;
      GenerateCode: GenerateCodeForAdvancedSystemCare;
      {$IFDEF DEBUG}
      VerifyCode: IsCodeForAdvancedSystemCare;
      {$ELSE}
      VerifyCode: nil;
      {$ENDIF}
    ),
    (
      Name: 'Advanced SystemCare Ultimate';
      Host: 'asc55.iobit.com';
      Version: 9;
      GenerateCode: GenerateCodeForAdvancedSystemCareUltimate;
      {$IFDEF DEBUG}
      VerifyCode: IsCodeForAdvancedSystemCareUltimate;
      {$ELSE}
      VerifyCode: nil;
      {$ENDIF}
    ),
    (
      Name: 'Driver Booster';
      Host: 'idb.iobit.com';
      Version: 4;
      GenerateCode: GenerateCodeForDriverBooster;
      {$IFDEF DEBUG}
      VerifyCode: IsCodeForDriverBooster;
      {$ELSE}
      VerifyCode: nil;
      {$ENDIF}
    ),
    (
      Name: 'iFreeUp PRO';
      Host: 'ifrpc.ifreeup.com';
      Version: 1;
      GenerateCode: GenerateCodeForiFreeUp;
      {$IFDEF DEBUG}
      VerifyCode: IsCodeForiFreeUp;
      {$ELSE}
      VerifyCode: nil;
      {$ENDIF}
    ),
    (
      Name: 'Malware Fighter PRO';
      Host: 'is360.iobit.com';
      Version: 4;
      GenerateCode: GenerateCodeForMalwareFighter;
      {$IFDEF DEBUG}
      VerifyCode: IsCodeForMalwareFighter;
      {$ELSE}
      VerifyCode: nil;
      {$ENDIF}
    ),
    (
      Name: 'Protected Folder PRO';
      Host: 'pf.iobit.com';
      Version: 1;
      GenerateCode: GenerateCodeForProtectedFolder;
      {$IFDEF DEBUG}
      VerifyCode: IsCodeForProtectedFolder;
      {$ELSE}
      VerifyCode: nil;
      {$ENDIF}
    ),
    (
      Name: 'Smart Defrag PRO';
      Host: 'sd.iobit.com';
      Version: 5;
      GenerateCode: GenerateCodeForSmartDefrag;
      {$IFDEF DEBUG}
      VerifyCode: IsCodeForSmartDefrag;
      {$ELSE}
      VerifyCode: nil;
      {$ENDIF}
    ),
    (
      Name: 'Start Menu 8 PRO';
      Host: 'sm.iobit.com';
      Version: 4;
      GenerateCode: GenerateCodeForStartMenu8;
      {$IFDEF DEBUG}
      VerifyCode: IsCodeForStartMenu8;
      {$ELSE}
      VerifyCode: nil;
      {$ENDIF}
    ),
    (
      Name: 'Uninstaller PRO';
      Host: 'iunins.iobit.com';
      Version: 6;
      GenerateCode: GenerateCodeForUninstaller;
      {$IFDEF DEBUG}      
      VerifyCode: IsCodeForUninstaller;
      {$ELSE}
      VerifyCode: nil;
      {$ENDIF}
    )
  );

implementation

end.
