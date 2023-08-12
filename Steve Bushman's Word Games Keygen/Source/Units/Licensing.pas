//------------------------------------------------------------------------------
// Changelog (2019-05-18)
// - Added support for version 6 of the games
// - Key generation function rewritten
//------------------------------------------------------------------------------

unit Licensing;

interface

type
  TProductInfo = record
    Name: String;
    Prefix: String;
    Salt: String;
    Version: Byte;
  end;

const
  ProductList: array[0..11] of TProductInfo = (
    (
      Name: 'Super Bingo Card Maker DELUXE 5';
      Prefix: 'BINGO';
      Salt: '!!! SuperBingoCardMakerDELUXE 5 by Steve Bushman !!!';
      Version: 5;
    ),
    (
      Name: 'Super Bingo Card Maker eduBakery 6';
      Prefix: 'BINGO';
      Salt: '!!! SuperBingoCardMaker eduBakery 6 by Steve Bushman !!!';
      Version: 6;
    ),
    (
      Name: 'Super Crossword Creator DELUXE 5';
      Prefix: 'CROSSWORD';
      Salt: '!!! SuperCrosswordCreatorDELUXE 5 by Steve Bushman !!!';
      Version: 5;
    ),
    (
      Name: 'Super Crossword Creator eduBakery 6';
      Prefix: 'CROSSWORD';
      Salt: '!!! SuperCrosswordCreator eduBakery 6 by Steve Bushman !!!';
      Version: 6;
    ),
    (
      Name: 'Super Crossword Creator + All Friends eduBakery 6';
      Prefix: 'DELUXE';
      Salt: '!!! SuperCrosswordCreator and All Friends eduBakery 6 by Steve Bushman !!!';
      Version: 6;
    ),
    (
      Name: 'Super Crossword Creator + Super Word Search Maker DELUXE 5';
      Prefix: 'COMBOCW';
      Salt: '!!! SuperCrosswordCreatorDELUXE and SuperWordSearchMakerDELUXE 5 by Steve Bushman !!!';
      Version: 5;
    ),
    (
      Name: 'Super Crossword Creator + Super Word Search Maker eduBakery 6';
      Prefix: 'COMBOA';
      Salt: '!!! SuperCrosswordCreator and SuperWordSearchMaker eduBakery 6  by Steve Bushman !!!';
      Version: 6;
    ),
    (
      Name: 'Super Crossword Creator + Super Word Search Maker + Super Bingo Card Maker DELUXE 5';
      Prefix: 'COMBO3';
      Salt: '!!! SuperCrosswordCreatorDELUXE and SuperWordSearchMakerDELUXE and SuperBingoCardMakerDELUXE 5 by Steve Bushman !!!';
      Version: 5;
    ),
    (
      Name: 'Super Word Search Maker DELUXE 5';
      Prefix: 'WORDSEARCH';
      Salt: '!!! SuperWordSearchMakerDELUXE 5 by Steve Bushman !!!';
      Version: 5;
    ),
    (
      Name: 'Super Word Search Maker eduBakery 6';
      Prefix: 'WORDSEARCH';
      Salt: '!!! SuperWordSearchMaker eduBakery 6 by Steve Bushman !!!';
      Version: 6;
    ),
    (
      Name: 'Super Word Scrambler eduBakery 6';
      Prefix: 'WORDSCRAMBLE';
      Salt: '!!! SuperWordScrambler eduBakery 6 by Steve Bushman !!!';
      Version: 6;
    ),
    (
      Name: 'Super Word Studio';
      Prefix: 'STUDIOTL-2050-11-31';
      Salt: '!!! SuperWordStudioTimeLimited by Steve Bushman !!!2050-11-31';
      Version: 5;
    )
  );

function GenerateKey(const ProductInfo: TProductInfo;
  const Name: AnsiString; ExpirationDate: TDateTime): AnsiString;
    
implementation

uses
  MD5,
  SysUtils;

//------------------------------------------------------------------------------
  
function GetKey10From16CharAt(const S: String; N: Integer): Char;
begin
  case S[N] of
    'A': Result := '7';
    'B': Result := '4';
    'C': Result := '1';
    'D': Result := '3';
    'E': Result := '9';
    'F': Result := '5';
  else
    Result := S[N];
  end;
end;

//------------------------------------------------------------------------------

function GenerateKey(const ProductInfo: TProductInfo;
  const Name: AnsiString; ExpirationDate: TDateTime): AnsiString;
var
  Digest: TMD5Digest;
  S2: WideString;
  S1, S3: AnsiString;
  Y, M, D: Word;
begin
  S1 := StringReplace(Trim(UpperCase(Name)), ' ', '-', [rfReplaceAll]);
  S1 := StringReplace(S1, ' ', '', [rfReplaceAll]);
  S1 := StringReplace(S1, '@', '', [rfReplaceAll]);
  S1 := StringReplace(S1, '.', '', [rfReplaceAll]);
  S1 := StringReplace(S1, '!', '', [rfReplaceAll]);
  S1 := StringReplace(S1, '(', '', [rfReplaceAll]);
  S1 := StringReplace(S1, ')', '', [rfReplaceAll]);

  case ProductInfo.Version of
    5:
      begin
        Result := ProductInfo.Prefix + '-' + UpperCase(S1);
        S2 := UTF8Decode(StringReplace(S1, '-', '', [rfReplaceAll]) + ProductInfo.Salt + ProductInfo.Prefix);
        Digest := MD5FromBuffer(PWideChar(S2)^, Length(S2) * 2);
        Result := Result + '-';
        Result := Result + IntToStr(Digest.Bytes[15] mod 10);
        Result := Result + IntToStr(Digest.Bytes[6] mod 10);
        Result := Result + IntToStr(Digest.Bytes[4] mod 10);
        Result := Result + IntToStr(Digest.Bytes[5] mod 10);
        Result := Result + '-';
        Result := Result + IntToStr(Digest.Bytes[0] mod 10);
        Result := Result + IntToStr(Digest.Bytes[3] mod 10);
        Result := Result + IntToStr(Digest.Bytes[2] mod 10);
        Result := Result + IntToStr(Digest.Bytes[1] mod 10);
        Result := Result + '-';
        Result := Result + IntToStr(Digest.Bytes[11] mod 10);
        Result := Result + IntToStr(Digest.Bytes[7] mod 10);
        Result := Result + IntToStr(Digest.Bytes[8] mod 10);
        Result := Result + IntToStr(Digest.Bytes[13] mod 10);
        Result := Result + '-';
        Result := Result + IntToStr(Digest.Bytes[12] mod 10);
        Result := Result + IntToStr(Digest.Bytes[9] mod 10);
        Result := Result + IntToStr(Digest.Bytes[14] mod 10);
        Result := Result + IntToStr(Digest.Bytes[10] mod 10);
      end;
    6:
      begin
        DecodeDate(ExpirationDate, Y, M, D);
        S3 := Format('%.2u%.2u%.2u', [D, M - 1, Y - 2000]);
        Result := S3 + '-' + ProductInfo.Prefix + '-' + UpperCase(S1);
        S3 := MD5ToString(MD5FromString(StringReplace(S1, '-', '', [rfReplaceAll]) +
              ProductInfo.Salt + ProductInfo.Prefix + S3), True);
        Result := Result + '-';
        Result := Result + GetKey10From16CharAt(S3, 16);
        Result := Result + GetKey10From16CharAt(S3, 4);
        Result := Result + GetKey10From16CharAt(S3, 3);
        Result := Result + GetKey10From16CharAt(S3, 2);
        Result := Result + '-';
        Result := Result + GetKey10From16CharAt(S3, 12);
        Result := Result + GetKey10From16CharAt(S3, 8);
        Result := Result + GetKey10From16CharAt(S3, 9);
        Result := Result + GetKey10From16CharAt(S3, 14);
        Result := Result + '-';
        Result := Result + GetKey10From16CharAt(S3, 13);
        Result := Result + GetKey10From16CharAt(S3, 10);
        Result := Result + GetKey10From16CharAt(S3, 15);
        Result := Result + GetKey10From16CharAt(S3, 11);
        Result := Result + '-';
        Result := Result + GetKey10From16CharAt(S3, 1);
        Result := Result + GetKey10From16CharAt(S3, 7);
        Result := Result + GetKey10From16CharAt(S3, 5);
        Result := Result + GetKey10From16CharAt(S3, 6);
      end;
  else
    Result := '';
  end;
end;

end.
