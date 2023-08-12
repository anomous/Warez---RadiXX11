unit KeyFile;

interface

const
  KeyFileName = 'key.dat';

function CreateKeyFile(const FileName, Name, Company: String): Boolean;

implementation

uses
  SysUtils;

function CreateKeyFile(const FileName, Name, Company: String): Boolean;
const
  Table: array[0..249] of Byte = (
    33,9,9,12,2,1,13,6,14,4,2,1,17,8,10,3,12,15,5,1,8,14,7,3,8,10,10,7,18,9,12,
    9,6,19,3,11,15,17,2,5,19,5,13,17,7,11,17,17,0,2,2,16,3,5,19,4,14,16,17,13,
    14,11,11,9,7,9,18,9,14,11,9,3,3,18,17,7,13,5,6,8,0,12,18,0,18,18,0,5,15,16,
    8,3,2,13,8,3,2,18,10,11,16,6,5,14,3,5,14,7,4,14,15,8,10,10,15,10,13,3,9,14,
    0,6,17,4,10,8,3,8,9,11,0,5,17,8,11,13,19,11,8,8,6,13,2,5,15,1,18,16,4,10,3,
    10,18,7,19,12,18,6,6,7,18,16,2,17,9,13,7,12,0,1,8,19,2,1,11,18,13,11,12,17,
    15,16,15,15,18,17,14,3,18,6,4,4,10,16,9,19,18,16,1,6,6,2,1,11,8,19,15,0,4,9,
    6,16,18,9,6,8,7,17,18,12,14,15,11,16,12,3,13,4,8,2,12,0,15,3,8,13,16,1,1,14,
    12,13,3,1,16,18,3,7,7,14
  );
var
  F: TextFile;
  S1, S2: String;
  I, J, K: Integer;
begin
  Result := False;

  if (Length(Name) <= 100) and (Length(Company) <= 100) then
  begin
    S1 := Format('%s~%s~Unused~10=', [Name, Company]);
    S2 := StringOfChar(' ', 4000);
    J := 0;
    K := 0;

    for I := 1 to Length(S1) do
    begin
      Inc(K, Table[J] + 1);
      Inc(J);
      S2[K] := S1[I];
    end;

    J := 0;

    for I := 1 to Length(S2) do
      Inc(J, Byte(S2[I]));

    S1 := IntToStr(J);
    S2 := S2 + S1;
    S2 := S2 + StringOfChar(' ', 4920 - Length(S2));

    try
      AssignFile(F, FileName);
      ReWrite(F);
      Write(F, S2);
      CloseFile(F);

      Result := True;

    except
      Result := False;
    end;
  end;
end;

end.
