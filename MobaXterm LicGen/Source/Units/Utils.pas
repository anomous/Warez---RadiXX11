unit Utils;

interface

type
  TVersionNumber = record
    Major: Word;
    Minor: Word;
    Release: Word;
    Build: Word;
  end;

function GetFileVersion(const FileName: String; var Version: TVersionNumber): Boolean;
function GetUserName: String;
function OpenURL(const URL: String): Boolean;

implementation

uses
  Windows,
  Forms,
  ShellAPI,
  SysUtils;

//------------------------------------------------------------------------------

function GetFileVersion(const FileName: String; var Version: TVersionNumber): Boolean;
var
  BufferSize, Dummy: DWORD;
  Buffer, FileInfo: Pointer;
begin
  Result := False;

  if FileExists(FileName) then
  begin
    try
      FillChar(Version, SizeOf(Version), 0);

      // get size of version info (0 if no version info exists)
      BufferSize := GetFileVersionInfoSize(PChar(FileName), Dummy);

      if BufferSize > 0 then
      begin
        GetMem(Buffer, BufferSize);

        try
          // get fixed file info
          GetFileVersionInfo(PChar(filename), 0, BufferSize, Buffer);
          VerQueryValue(Buffer, '\', FileInfo, Dummy);

          // read version blocks
          Version.Major := HiWord(PVSFixedFileInfo(FileInfo)^.dwFileVersionMS);
          Version.Minor := LoWord(PVSFixedFileInfo(FileInfo)^.dwFileVersionMS);
          Version.Release := HiWord(PVSFixedFileInfo(FileInfo)^.dwFileVersionLS);
          Version.Build := LoWord(PVSFixedFileInfo(FileInfo)^.dwFileVersionLS);
          Result := True;

        finally
          FreeMem(Buffer);
        end;
      end;
    except
      Result := False;
    end;
  end;
end;

//------------------------------------------------------------------------------

function GetUserName: String;
const
  UNLEN = 256;
var
  Buffer: array[0..UNLEN] of Char;
  Len: DWORD;
begin
  Len := UNLEN + 1;

  if Windows.GetUserName(Buffer, Len) then
    Result := Buffer
  else
    Result := '';
end;

//------------------------------------------------------------------------------

function OpenURL(const URL: String): Boolean;
begin
  try
    Result := ShellExecute(Application.Handle, 'open', PChar(URL), nil, nil,
      SW_SHOWNORMAL) > 32;
  except
    Result := False;
  end;
end;

end.
