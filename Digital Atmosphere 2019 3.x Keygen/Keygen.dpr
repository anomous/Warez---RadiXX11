program Keygen;

{$APPTYPE CONSOLE}

uses
  SysUtils;

//------------------------------------------------------------------------------
  
function GenerateKeyNumber(const SerialNumber: String): String;
const
  Magic = '174735672';
var
  S: String;
  I, J: Integer;
begin
  Result := '';

  if Length(SerialNumber) = 18 then
  begin
    S := Copy(SerialNumber, 10, 9);

    for I := 1 to 9 do
    begin
      if not TryStrToInt(S[I], J) then
      begin
        Result := '';
        Exit;
      end
      else
        Result := Result + IntToStr((StrToInt(Magic[I]) * J) mod 10);
    end;

    Result := IntToStr(Abs(StrToInt(Result) - 12));
  end;
end;

//------------------------------------------------------------------------------

var
  SerialNumber, KeyNumber: String;

begin
  // http://www.weathergraphics.com/da/
  
  WriteLn('Digital Atmosphere 2019 3.x Keygen [by RadiXX11]');
  WriteLn('================================================');
  WriteLn;

  while True do
  begin
    Write('Serial Number: ');
    ReadLn(SerialNumber);

    if SerialNumber <> '' then
    begin
      KeyNumber := GenerateKeyNumber(SerialNumber);

      if KeyNumber <> '' then
      begin
        WriteLn('Key Number...: ', KeyNumber);
        Break;
      end
      else
      begin
        WriteLn('Incorrect Serial Number format!');
        WriteLn;
      end;
    end
    else
      Break;
  end;

  ReadLn;
end.
