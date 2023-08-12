unit Licensing;

interface

type
  TProductInfo = record
    Name: String;
    Code: String;
  end;

const
  ProductCount = 9;
  ProductList: array[0..ProductCount - 1] of TProductInfo = (
    (
      Name: 'Game Boost';
      Code: #$23#$7B#$3C#$57#$49#$2D#$59#$5F#$21#$20#$27#$30#$3D#$31#$25#$47#$24#$5C#$60#$55#$54#$2B#$51#$2C#$38#$26#$3A#$4B#$28#$52#$39#$32#$3F#$4F#$50#$43#$35#$2A#$3B#$5E#$5B#$34#$3E#$22#$45#$5D#$7D#$7E#$44#$41#$40#$4D#$4E#$2F#$29#$33#$53#$2E#$56#$56#$4C#$48#$46#$36#$58#$7C#$4A#$42#$5A;
    ),
    (
      Name: 'GameGain';
      Code: #$23#$49#$34#$3F#$29#$25#$24#$3E#$5F#$35#$4C#$51#$30#$4D#$5B#$50#$5C#$58#$5E#$41#$45#$42#$32#$33#$44#$54#$31#$36#$4F#$39#$5A#$28#$4A#$46#$3A#$22#$20#$7D#$2B#$3C#$57#$7B#$5D#$47#$53#$53#$60#$4B#$38#$48#$2A#$2F#$56#$59#$2E#$2D#$4E#$21#$52#$43#$55#$3B#$27#$2C#$7C#$40#$3D#$7E#$26;
    ),
    (
      Name: 'Game Swift';
      Code: #$3E#$40#$3D#$4A#$26#$27#$23#$5C#$54#$50#$44#$33#$43#$53#$5D#$3C#$4E#$22#$22#$7D#$2B#$21#$3F#$39#$25#$5B#$7C#$5A#$2A#$52#$41#$2F#$58#$28#$4C#$7E#$3B#$59#$4B#$29#$32#$7B#$30#$46#$47#$2C#$4D#$55#$56#$4F#$51#$35#$49#$2E#$20#$5E#$31#$34#$48#$60#$42#$24#$57#$3A#$2D#$36#$5F#$38#$45;
    ),
    (
      Name: 'PC Boost';
      Code: #$56#$22#$28#$4F#$3F#$7E#$33#$45#$7D#$2C#$32#$23#$30#$38#$57#$58#$36#$3D#$2E#$3C#$21#$53#$39#$29#$5C#$24#$4B#$4E#$4A#$46#$3E#$4D#$20#$3B#$2B#$44#$5D#$60#$40#$47#$7C#$7B#$35#$43#$2A#$42#$54#$55#$2D#$4C#$50#$49#$5F#$5E#$5E#$52#$2F#$5B#$34#$26#$41#$5A#$48#$3A#$59#$27#$31#$51#$25;
    ),
    (
      Name: 'PC Medik';
      Code: #$53#$34#$38#$42#$4C#$49#$23#$24#$7D#$48#$29#$26#$2C#$2F#$3D#$5D#$3F#$51#$5C#$5C#$25#$4B#$7B#$28#$39#$5F#$4D#$36#$59#$55#$58#$54#$7E#$50#$33#$21#$2B#$46#$60#$47#$31#$4A#$32#$52#$56#$3B#$45#$2D#$3A#$41#$5E#$43#$5A#$3E#$20#$30#$22#$2E#$3C#$35#$35#$2A#$27#$40#$7C#$5B#$57#$44#$4E;
    ),
    (
      Name: 'PC Swift';
      Code: #$30#$45#$31#$3F#$50#$3E#$48#$46#$5D#$59#$3A#$4A#$5A#$41#$4D#$49#$5C#$60#$4F#$2A#$29#$4C#$2E#$47#$23#$20#$27#$24#$7E#$28#$2D#$52#$25#$40#$2F#$7B#$32#$3B#$7C#$5E#$34#$5B#$22#$53#$21#$5F#$7D#$7D#$51#$43#$38#$42#$33#$44#$4B#$35#$2B#$3C#$2C#$57#$4E#$56#$36#$26#$55#$58#$3D#$39#$54;
    ),
    (
      Name: 'SuperRam';
      Code: #$23#$40#$20#$45#$2E#$29#$4A#$41#$7E#$43#$7C#$44#$5A#$33#$58#$5C#$36#$60#$3C#$5F#$35#$52#$27#$55#$37#$2A#$5B#$34#$4F#$3E#$5E#$53#$56#$42#$39#$2C#$3D#$30#$2B#$25#$3B#$22#$51#$2F#$46#$2D#$7D#$26#$3A#$4D#$49#$38#$32#$59#$21#$5D#$4C#$3F#$54#$31#$28#$4E#$4B#$48#$47#$50#$7B#$24#$57;
    ),
    (
      Name: 'System Swift';
      Code: #$59#$7C#$24#$5B#$2E#$53#$23#$5C#$44#$52#$20#$20#$55#$4C#$34#$46#$2F#$39#$5A#$33#$3E#$5E#$30#$36#$5F#$7B#$21#$4D#$3D#$3A#$31#$45#$47#$4E#$43#$60#$50#$51#$2B#$42#$49#$7E#$22#$56#$57#$4B#$41#$4A#$3C#$29#$32#$25#$4F#$26#$27#$2D#$58#$54#$5D#$40#$38#$2A#$3F#$48#$28#$3B#$35#$7D#$2C;
    ),
    (
      Name: 'Throttle';
      Code: #$59#$3A#$22#$49#$53#$37#$26#$3B#$5B#$2D#$50#$3E#$57#$21#$39#$7B#$4D#$4F#$3F#$2B#$2F#$25#$5C#$32#$24#$48#$23#$2C#$47#$5F#$3C#$29#$46#$4E#$51#$33#$4C#$36#$58#$55#$40#$45#$4B#$28#$3D#$7C#$41#$2E#$5A#$7D#$43#$60#$31#$7E#$52#$30#$20#$27#$54#$35#$34#$5D#$38#$5E#$42#$44#$4A#$56#$2A;
    )
  );

function GenerateSerial(const ProductInfo: TProductInfo; const Name: String;
  Computers: Word): String;

implementation

uses
  SysUtils;

//------------------------------------------------------------------------------

function GetChecksum(const S, Code: String): Integer;
var
  I, J: Integer;
begin
  Result := 0;

  for I := 1 to Length(S) do
  begin
    if not (S[I] in ['0'..'9']) then
    begin
      J := 1;

      while True do
      begin
        if Code[J] = S[I] then
        begin
          Inc(Result, J + 9);
          Break;
        end;

        Inc(J);

        if J > Length(Code) then
        begin
          Inc(Result, 99);
          Break;
        end;
      end;
    end
    else
      Inc(Result, Byte(S[I]) - 48);
  end;
end;

//------------------------------------------------------------------------------

function GetHash(const S, Code: String): Integer;
var
  I, J: Integer;
begin
  Result := 0;

  for I := 1 to Length(S) do
  begin
    J := 1;

    while True do
    begin
      if Code[J] = S[I] then
      begin
        Inc(Result, J + 9);
        Break;
      end;

      Inc(J);

      if J > Length(Code) then
      begin
        Inc(Result, 99);
        Break;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------

function GenerateSerial(const ProductInfo: TProductInfo; const Name: String;
  Computers: Word): String;
const
  Charset = '0123456789ABCDEFGHIJLMNOPQRSTUVWXYZ';
var
  I: Integer;
begin
  Result := '';

  if (Length(Trim(Name)) >= 6) and (Computers > 0) and (Computers < 1000) then
  begin
    for I := 1 to 5 do
      Result := Result + Charset[Random(Length(Charset)) + 1];
    Result := Format('L%uC%uN', [GetHash(UpperCase(Trim(Name)), ProductInfo.Code), Computers]) + Result;
    Result := IntToStr(GetChecksum(Result, ProductInfo.Code)) + Result;
  end;
end;

end.
 