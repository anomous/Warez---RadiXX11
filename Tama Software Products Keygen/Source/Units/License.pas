unit License;

interface

type
  TKeyCode = array[0..11] of Byte;
  TKeyCodeChecker = function(KeyCode: TKeyCode): Boolean;

type
  TProductInfo = record
    Name: String;
    KeyCodeChecker: TKeyCodeChecker;
  end;

//------------------------------------------------------------------------------

function PD4KeyCodeChecker(KeyCode: TKeyCode): Boolean;
function PUCDPKeyCodeChecker(KeyCode: TKeyCode): Boolean;

//------------------------------------------------------------------------------

const
  ProductList: array[0..1] of TProductInfo = (
    (
      Name: 'Pepakura Designer 4.x';
      KeyCodeChecker: PD4KeyCodeChecker;
    ),
    (
      Name: 'Pop-Up Card Designer PRO 3.x';
      KeyCodeChecker: PUCDPKeyCodeChecker;
    )
  );

function GenerateKeyCode(const ProductInfo: TProductInfo): String;  

implementation

uses
  SysUtils;
  
//------------------------------------------------------------------------------

const
  Indexes: array[0..11] of Byte = (0, 1, 2, 10, 5, 9, 6, 4, 7, 8, 3, 11);

//------------------------------------------------------------------------------

function PD4KeyCodeChecker(KeyCode: TKeyCode): Boolean;
begin
  if KeyCode[0] = 0 then
    Result := (KeyCode[1] = 4) or (KeyCode[1] = 8)
  else if KeyCode[0] = 1 then
    Result := KeyCode[1] = 2
  else
    Result := False;
end;

//------------------------------------------------------------------------------

function PUCDPKeyCodeChecker(KeyCode: TKeyCode): Boolean;
begin
  Result := (KeyCode[0] = 0) and (KeyCode[1] = 6);
end;

//------------------------------------------------------------------------------

function GenerateKeyCode(const ProductInfo: TProductInfo): String;
var
  Idx: array[0..11] of Byte;
  KeyCode1, KeyCode2: TKeyCode;
  I: Integer;
  B: Byte;
begin
  Result := '';

  repeat
    for I := 0 to 11 do
      KeyCode1[I] := Random(10);

    KeyCode1[9] := ((KeyCode1[1] + KeyCode1[3] + KeyCode1[5] + KeyCode1[7]) * (KeyCode1[0] + KeyCode1[2] + KeyCode1[6] + KeyCode1[4])) mod 10;
    KeyCode1[10] := (KeyCode1[1] + KeyCode1[7] + KeyCode1[0] + KeyCode1[2] + KeyCode1[3] * KeyCode1[5] * KeyCode1[4] * KeyCode1[6]) mod 10;
    KeyCode1[11] := (KeyCode1[7] + KeyCode1[5] * KeyCode1[4] + KeyCode1[6] + KeyCode1[3] * KeyCode1[2] + KeyCode1[1] * KeyCode1[0]) mod 10;

    Move(Indexes, Idx, SizeOf(Indexes));

    if KeyCode1[2] > 0 then
    begin
      for I := 1 to KeyCode1[2] do
      begin
        B := Idx[3];
        Idx[3] := Idx[4];
        Idx[4] := Idx[5];
        Idx[5] := Idx[6];
        Idx[6] := Idx[7];
        Idx[7] := Idx[8];
        Idx[8] := Idx[9];
        Idx[9] := Idx[10];
        Idx[10] := Idx[11];
        Idx[11] := B;
      end;
    end;

    for I := 0 to 11 do
      KeyCode2[I] := KeyCode1[Idx[I]];

  until ProductInfo.KeyCodeChecker(KeyCode2);

  for I := 0 to 11 do
    Result := Result + IntToStr(KeyCode2[I]);

  Insert('-', Result, 5);
  Insert('-', Result, 10);
end;

end.
