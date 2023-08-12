unit Utils;

interface

type
  TOutputCallback = function(const Buffer: String): Boolean;

function ExtractResource(Instance: THandle; const ResName: String;
  ResType: PChar; const FileName: String): Boolean;
function GetConsoleOutput(const CommandLine: String; Callback: TOutputCallback;
  var Output: String): Boolean;
function GetFolderPath(CSIDL: Integer): String;
function GetTempDirectory: String;
function OpenURL(const URL: String): Boolean;
function GetUserName: String;

implementation

uses
  Windows,
  Classes,
  Forms,
  SysUtils,
  ShellAPI;

//------------------------------------------------------------------------------

function SHGetFolderPath(hwnd: HWND; csidl: Integer; hToken: THandle;
  dwFlags: DWORD; pszPath: LPSTR): HResult; stdcall;
  external 'shell32.dll' name 'SHGetFolderPathA';

//------------------------------------------------------------------------------

function ExtractResource(Instance: THandle; const ResName: String;
  ResType: PChar; const FileName: String): Boolean;
var
  ResStream: TResourceStream;
begin
  try
    ResStream := TResourceStream.Create(Instance, ResName, ResType);
    try
      ResStream.SaveToFile(FileName);
      Result := True;
    finally
      ResStream.Free;
    end;
  except
    Result := False;
  end;
end;

//------------------------------------------------------------------------------

function GetConsoleOutput(const CommandLine: String; Callback: TOutputCallback;
  var Output: String): Boolean;
const
  ReadBufferSize = 2400;
var
  InBuffer, OutBuffer: array[0..ReadBufferSize] of Char;
  SecurityAttr: TSecurityAttributes;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  ReadHandle, WriteHandle: THandle;
  BytesRead, Running, Available: DWORD;
begin
  try
    Result := False;
    SecurityAttr.nLength := SizeOf(TSecurityAttributes);
    SecurityAttr.bInheritHandle := True;
    SecurityAttr.lpSecurityDescriptor := nil;

    if CreatePipe(ReadHandle, WriteHandle, @SecurityAttr, 0) then
      try
        FillChar(StartupInfo, SizeOf(TStartupInfo), #0);

        StartupInfo.cb := SizeOf(TStartupInfo);
        StartupInfo.hStdInput := ReadHandle;
        StartupInfo.hStdOutput := WriteHandle;
        StartupInfo.hStdError := WriteHandle;
        StartupInfo.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
        StartupInfo.wShowWindow := SW_HIDE;

        if CreateProcess(nil, PChar(CommandLine), @SecurityAttr, @SecurityAttr,
          True, NORMAL_PRIORITY_CLASS, nil, nil, StartupInfo, ProcessInfo) then
          try
            repeat
              Running := WaitForSingleObject(ProcessInfo.hProcess, 100);
              PeekNamedPipe(ReadHandle, nil, 0, nil, @Available, nil);

              if (Available > 0) then
                repeat
                  BytesRead := 0;

                  ReadFile(ReadHandle, InBuffer[0], ReadBufferSize, BytesRead, nil);

                  InBuffer[BytesRead] := #0;

                  OemToCharA(InBuffer, OutBuffer);

                  Output := Output + OutBuffer;

                  if Assigned(Callback) then
                    if not Callback(OutBuffer) then Break;

                until (BytesRead < ReadBufferSize);

              Application.ProcessMessages;

            until (Running <> WAIT_TIMEOUT);

            Result := True;

          finally
            CloseHandle(ProcessInfo.hProcess);
            CloseHandle(ProcessInfo.hThread);
          end;
      finally
        CloseHandle(ReadHandle);
        CloseHandle(WriteHandle);
      end;
  except
    Result := False;
  end;
end;

//------------------------------------------------------------------------------

function GetFolderPath(CSIDL: Integer): String;
const
  SHGFP_TYPE_CURRENT = 0;
var
  Path: array[0..MAX_PATH] of Char;
begin
  if SHGetFolderPath(0, CSIDL, 0, SHGFP_TYPE_CURRENT, Path) = S_OK then
    Result := Path
  else
    Result := '';
end;

//------------------------------------------------------------------------------

function GetTempDirectory: String;
var
  Buffer: array[0..MAX_PATH] of Char;
begin
  if GetTempPath(MAX_PATH, Buffer) > 0 then
    Result := ExcludeTrailingPathDelimiter(Buffer)
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

end.
