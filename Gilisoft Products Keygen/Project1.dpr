program Project1;

{$APPTYPE CONSOLE}

uses
  Classes,
  imagehlp,
  SysUtils,
  PEUtils in 'PEUtils.pas';

type
  TFunctionPatch = record
    Name: String;
    Original: String;
    Patch: String;
  end;

const
  FunctionList: array[0..3] of TFunctionPatch =
  (
    (
      Name: 'CheckSNOnLine_WhenRegist';
      Original: #$55#$8B#$EC#$B9;
      Patch: #$33#$C0#$C2#$04#$00#$90#$90#$90;
    ),
    (
      Name: 'CheckSNOnLine_WhenRegist2';
      Original: #$55#$8B#$EC#$6A#$00;
      Patch: #$33#$C0#$C2#$04#$00;
    ),
    (
      Name: 'CheckSNOnLine';
      Original: #$55#$8B#$EC#$B9;
      Patch: #$33#$C0#$C2#$08#$00#$90#$90#$90;
    ),
    (
      Name: 'CheckSNOnLine2';
      Original: #$55#$8B#$EC#$B9;
      Patch: #$33#$C0#$C2#$08#$00#$90#$90#$90;
    )
  );

function PatchDLL(const FileName: String): Integer;
var
  FnCode: Pointer;
  Offset: LongWord;
  I: Integer;
begin
  try
    with TMemoryStream.Create do
    try
      LoadFromFile(FileName);

      for I := Low(FunctionList) to High(FunctionList) do
      begin
        Offset := GetProcOffset(FileName, FunctionList[I].Name);
        FnCode := Pointer(LongWord(Memory) + Offset);

        if not CompareMem(FnCode, @FunctionList[I].Original[1],
          Length(FunctionList[I].Original)) then
        begin
          Result := -2;
          Exit;
        end;

        Move(FunctionList[I].Patch[1], FnCode^, Length(FunctionList[I].Patch));
      end;

      SaveToFile(FileName);

      Result := 0;

    finally
      Free;
    end;

  except
    Result := -1;
  end;
end;

begin
  writeln(PatchDLL('C:\Program Files (x86)\Gilisoft\Video Editor\Verify.dll'));
  readln;
end.
