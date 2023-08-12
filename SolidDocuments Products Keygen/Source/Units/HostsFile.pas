unit HostsFile;

interface

//------------------------------------------------------------------------------
// Function prototypes
//------------------------------------------------------------------------------

function IsHostsFilePatched(const HostEntries: array of String): Boolean;
function PatchHostsFile(const HostEntries: array of String): Boolean;
function RestoreHostsFile(const HostEntries: array of String): Boolean;

//------------------------------------------------------------------------------

implementation

uses
  Windows,
  Classes,
  SysUtils;

//------------------------------------------------------------------------------

function GetHostsFileName: String;
var
  Path: array[0..MAX_PATH - 1] of Char;
begin
  GetSystemDirectory(Path, MAX_PATH);
  Result := IncludeTrailingPathDelimiter(Path) + 'drivers\etc\hosts';
end;
  
//------------------------------------------------------------------------------

function IsHostsFilePatched(const HostEntries: array of String): Boolean;
var
  HostFound: array of Boolean;
  F: TextFile;
  S: String;
  I, Count: Integer;
begin
  try
    AssignFile(F, GetHostsFileName);
    FileMode := fmOpenRead;
    Reset(F);

    try
      // Read all text lines one at a time. Loop ends when EOF is reached or
      // all hosts entries were found.
      SetLength(HostFound, Length(HostEntries));
      Count := 0;
      Result := False;

      while (not Eof(F)) and (not Result) do
      begin
        ReadLn(F, S);
        S := Trim(S);

        // Skip blank lines.
        if S <> '' then
        begin
          // Skip comment lines.
          if S[1] <> '#' then
          begin
            S := LowerCase(S);

            // Check for the presence of any host entry in this line.
            for I := Low(HostEntries) to High(HostEntries) do
            begin
              // If a host entry is present also make sure that it was not found
              // already.
              if (Pos(HostEntries[I], S) > 0) and (not HostFound[I]) then
              begin
                HostFound[I] := True;
                Inc(Count);
              end;
            end;

            // Check if all host entries were found.
            Result := Count = Length(HostEntries);
          end;
        end;
      end;

    finally
      CloseFile(F);
    end;

  except
    Result := False;
  end;
end;

//------------------------------------------------------------------------------

{$WARN SYMBOL_PLATFORM OFF}
function PatchHostsFile(const HostEntries: array of String): Boolean;
var
  F: TextFile;
  FileName: String;
  Attr, I: Integer;
begin
  try
    FileName := GetHostsFileName;

    // Save original file attributes and remove read-only, system and hidden
    // attributes (to avoid any access error).
    Attr := FileGetAttr(FileName);
    FileSetAttr(FileName, Attr and (not faReadOnly) and (not faSysFile) and
      (not faHidden));

    AssignFile(F, FileName);

    try
      FileMode := fmOpenReadWrite;
      Append(F);

      try
        // Write all host entries.
        for I := Low(HostEntries) to High(HostEntries) do
          WriteLn(F, '127.0.0.1 ' + HostEntries[I]);

        Flush(F);
        Result := True;

      finally
        CloseFile(F);
      end;

    finally
      // Always restore original file attributes.
      FileSetAttr(FileName, Attr);
    end;

  except
    Result := False;
  end;
end;

//------------------------------------------------------------------------------

function RestoreHostsFile(const HostEntries: array of String): Boolean;
var
  FileName, S: String;
  I, J, Attr: Integer;
  RemoveLine: Boolean;
begin
  try
    FileName := GetHostsFileName;

    with TStringList.Create do
    try
      // Load hosts file and process each line.
      LoadFromFile(FileName);

      for I := Count - 1 downto 0 do
      begin
        // Remove any leading and trailing spaces.
        S := Trim(Strings[I]);

        // This flag indicates if the current line matches with one of the host
        // entries specified and must be removed.
        RemoveLine := False;

        // Skip blank lines.
        if S <> '' then
        begin
          // Skip comments.
          if S[1] <> '#' then
          begin
            S := LowerCase(S);

            // Check if this entry is defined in the host entries to remove.
            for J := Low(HostEntries) to High(HostEntries) do
            begin
              // A matching entry means this line must be removed.
              if Pos(HostEntries[J], S) > 0 then
              begin
                RemoveLine := True;
                Break;
              end;
            end;
          end;
        end;

        // Remove this line.
        if RemoveLine then
          Delete(I);
      end;

      // Save original file attributes and remove read-only, system and hidden
      // attributes (to avoid any access error).
      Attr := FileGetAttr(FileName);
      FileSetAttr(FileName, Attr and (not faReadOnly) and (not faSysFile) and
        (not faHidden));

      try
        // Overwrite original hosts file.
        SaveToFile(FileName);
        Result := True;

      finally
        // Always restore original file attributes.
        FileSetAttr(FileName, Attr);
      end;

    finally
      Free;
    end;

  except
    Result := False;
  end;
end;
{$WARN SYMBOL_PLATFORM ON}

end.
 