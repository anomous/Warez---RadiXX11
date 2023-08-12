unit Licensing;

interface

type
  TProductVersion = record
    Language: String;
    Id: String;
  end;

const
  VersionList: array[0..9] of TProductVersion = (
    (
      Language: 'C#';
      Id: 'CLCCSProV5';
    ),
    (
      Language: 'C++';
      Id: 'CLCCPlusPro5';
    ),
    (
      Language: 'COBOL';
      Id: 'CodeLineCounterCBL';
    ),
    (
      Language: 'Delphi';
      Id: 'CLCPDelphi5';
    ),
    (
      Language: 'Java';
      Id: 'CLCProJava5';
    ),
    (
      Language: 'Lisp';
      Id: 'CLCPLisp6';
    ),
    (
      Language: 'Perl';
      Id: 'CLC4PerlVersion';
    ),
    (
      Language: 'PHP';
      Id: 'CLCProPHPVersion';
    ),
    (
      Language: 'Python';
      Id: 'CLCPPyth0n5';
    ),
    (
      Language: 'VB';
      Id: 'CodeLCProVB5';
    )
  );

function GenerateCode(const ProductVersion: TProductVersion;
  const Name: String): String;

implementation

uses
  MD5,
  SysUtils;

function GenerateCode(const ProductVersion: TProductVersion;
  const Name: String): String;
var
  S1, S2: String;
  I, J, K, Value1, Value2: Integer;
begin
  if Trim(Name) <> '' then
  begin
    S1 := MD5ToString(MD5FromString(Trim(Name)), True);

    if ProductVersion.Id = '' then
      S2 := 'bistone'
    else
      S2 := ProductVersion.Id;

    Value1 := Random(256 - Ord(S1[1]));
    Result := IntToHex(Value1, 2);
    J := 1;

    for I := 1 to Length(S1) do
    begin
      K := Ord(S1[I]) + Value1;

      if K > 255 then
        Value2 := (K - 255) xor Ord(S2[J])
      else
        Value2 := K xor Ord(S2[J]);

      Result := Result + IntToHex(Value2, 2);

      Value1 := Value2;

      if J = Length(S2) then
        J := 1
      else
        Inc(J);
    end;
  end
  else
    Result := '';
end;

end.
