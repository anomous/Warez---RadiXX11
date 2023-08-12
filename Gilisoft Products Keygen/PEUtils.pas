unit PEUtils;

interface

uses
  Windows;

function GetImageFirstSection(NTHeader: PImageNtHeaders): PImageSectionHeader;
function GetProcOffset(const ModuleName, ProcName: String): LongWord;
function RVAToOffset(NTHeader: PImageNTHeaders; RVA: DWORD): DWORD;

implementation

//------------------------------------------------------------------------------

function FieldOffset(const Struc; const Field): DWORD;
begin
  Result := DWORD(@Field) - DWORD(@Struc);
end;

//------------------------------------------------------------------------------

function GetImageFirstSection(NTHeader: PImageNtHeaders): PImageSectionHeader;
begin 
  Result := PImageSectionHeader(DWORD(NtHeader) +
            FieldOffset(NtHeader^, NtHeader^.OptionalHeader) +
            NtHeader^.FileHeader.SizeOfOptionalHeader);
end;

//------------------------------------------------------------------------------

function GetProcOffset(const ModuleName, ProcName: String): LongWord;
var
  NTHeader: PImageNTHeaders;
  Lib: HMODULE;
  ProcAddr: Pointer;
  RVA: DWORD;
begin
  Result := 0;
  Lib := LoadLibrary(PChar(ModuleName));

  if Lib <> 0 then
  begin
    ProcAddr := GetProcAddress(Lib, PChar(ProcName));

    if ProcAddr <> nil then
    begin
      NTHeader := PImageNTHeaders(Lib + DWORD(PImageDOSHeader(Lib)^._lfanew));
      RVA := DWORD(ProcAddr) - Lib;
      Result := RVAToOffset(NTHeader, RVA);
    end;

    FreeLibrary(Lib);
  end;
end;

//------------------------------------------------------------------------------

function RVAToOffset(NTHeader: PImageNTHeaders; RVA: DWORD): DWORD;
var
  SectionHeader: PImageSectionHeader;
  I, Sections: Integer;
begin
  SectionHeader := GetImageFirstSection(NTHeader);
  Sections := NTHeader^.FileHeader.NumberOfSections;

  for i := 0 to Sections - 1 do
  begin
    if SectionHeader^.VirtualAddress <= RVA then
    begin
      if (SectionHeader^.VirtualAddress + SectionHeader^.Misc.VirtualSize) > RVA then
      begin
        Result := (RVA - SectionHeader^.VirtualAddress) + SectionHeader^.PointerToRawData;
        Exit;
      end;
    end;

    SectionHeader := PImageSectionHeader(DWORD(SectionHeader) + SizeOf(TImageSectionHeader));
  end;

  Result := 0;
end;

end.
