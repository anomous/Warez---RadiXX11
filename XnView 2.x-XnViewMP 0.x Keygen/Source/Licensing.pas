unit Licensing;

interface

function GenerateCode(const Name: String): String;

implementation

uses
  SysUtils;

function GenerateCode(const Name: String): String;
const
  Arr: array[0..19] of Byte = (
    $AA, $89, $C4, $FE, $46, $78, $F0, $D0, $03, $E7,
    $F7, $FD, $F4, $E7, $B9, $B5, $1B, $C9, $50, $73
  );
var
  A1: array[0..Length(Arr) - 1] of Byte;
  A2: array[0..3] of Byte;
  S: String;
  Code: LongWord;
  I, J, K: Integer;
  B: Byte;
begin
  Result := '';

  if Name <> '' then
  begin
    S := Name;

    Move(Arr, A1, SizeOf(A1));

    for I := 0 to Length(S) - 1 do
    begin
      J := I mod 5;
      K := I + 1;
      B := A1[J] xor Byte(S[K]);
      A1[J] := Byte(S[K]);
      S[K] := Char(B);
    end;

    for I := 0 to Length(S) - 1 do
    begin
      J := (I mod 5) + 5;
      K := Length(S) - I;
      B := A1[J] xor Byte(S[K]);
      A1[J] := Byte(S[K]);
      S[K] := Char(B);
    end;

    for I := 0 to Length(S) - 1 do
    begin
      J := (I mod 5) + 10;
      K := I + 1;
      B := A1[J] xor Byte(S[K]);
      A1[J] := Byte(S[K]);
      S[K] := Char(B);
    end;

    for I := 0 to Length(S) - 1 do
    begin
      J := (I mod 5) + 15;
      K := Length(S) - I;
      B := A1[J] xor Byte(S[K]);
      A1[J] := Byte(S[K]);
      S[K] := Char(B);
    end;

    FillChar(A2, SizeOf(A2), 0);

    for I := 0 to Length(S) - 1 do
      Inc(A2[I and 3], Byte(S[I + 1]));

    Code := 0;
    J := 24;

    for I := SizeOf(A2) - 1 downto 0 do
    begin
      Code := Code or (A2[I] shl J);
      Dec(J, 8);
    end;

    Result := IntToStr(Code);
  end;
end;

end.
