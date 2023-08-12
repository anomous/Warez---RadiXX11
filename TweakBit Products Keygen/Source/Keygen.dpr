program Keygen;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Licensing in 'Licensing.pas';

//------------------------------------------------------------------------------
  
procedure WaitForEnterKey;
begin
  WriteLn;
  Write('Press ENTER to continue...');
  ReadLn;
  WriteLn;
end;

//------------------------------------------------------------------------------

var
  Option: String;
  I: Integer;
  Done: Boolean;

begin
  Randomize;
  Done := False;

  repeat
    WriteLn('======================================');
    WriteLn('TweakBit Products Keygen [by RadiXX11]');
    WriteLn('--------------------------------------');

    for I := Low(ProductList) to High(ProductList) do
      WriteLn(I, '. ', ProductList[I].Name);

    WriteLn('--------------------------------------');
    WriteLn('6. Patch Hosts File');
    WriteLn('7. Exit');
    WriteLn('======================================');
    WriteLn;
    Write('Select a product/option: ');

    ReadLn(Option);

    if (Option = '') or (Option= '7') then
      Done := True
    else if Option = '6' then
    begin
      WriteLn;

      if not IsHostsFilePatched then
      begin
        if PatchHostsFile then
          WriteLn('Hosts file sucessfully patched.')
        else
          WriteLn('Cannot patch hosts file!');
      end
      else
        WriteLn('Hosts file already patched!');

      WaitForEnterKey;
    end
    else if TryStrToInt(Option, I) and (I >= 0) and (I < ProductCount) then
    begin
      WriteLn;
      WriteLn('--------------------------------------');
      WriteLn('Product: ', ProductList[I].Name);
      WriteLn('Key....: ', GenerateKey(ProductList[I]));
      WriteLn('--------------------------------------');

      WaitForEnterKey;
    end;
  until Done;
end.
