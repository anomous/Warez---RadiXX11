using System;
using System.Collections.Generic;
using System.IO;

namespace LicGen
{  
    public static class HostsFile
    {      
        private static string GetHostsFileName()
        {
            return Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.System), @"drivers\etc\hosts");
        }

        public static bool IsHostsFilePatched(string hostEntry)
        {
            return IsHostsFilePatched(new [] {hostEntry});
        }
        
        public static bool IsHostsFilePatched(string[] hostEntries)
        {
            try
            {
                var fileName = GetHostsFileName();
                
                // Check if the file exists before do anything.
                if (File.Exists(fileName))
                {
                    var entryFound = new bool[hostEntries.Length];
                    string line;
                    int j, count = 0;
                    
                    // Read all the lines in the file and process each entry.
                    var lines = File.ReadAllLines(fileName);
                    
                    for (int i = 0; i < lines.Length; i++)
                    {
                        // Remove any trailing spaces and/or control characters.
                        line = lines[i].Trim();
                        
                        // Process non-empty lines only.
                        if (line != string.Empty)
                        {
                            // Skip commentary lines.
                            if (!line.StartsWith("#", StringComparison.InvariantCultureIgnoreCase))
                            {
                                // Search for first space character.
                                j = line.IndexOfAny(new char[] {'\t', ' '});
                                
                                // Split line and add a new entry to the list.
                                if (j >= 0)
                                {
                                    // Check if any host entry matches with this entry.
                                    var entry = line.Substring(j).Trim();
                                    
                                    for (int k = 0; k < hostEntries.Length; k++)
                                    {
                                        // If a host entry is present also make sure that it was not found already.                                    
                                        if (hostEntries[k].Equals(entry, StringComparison.InvariantCultureIgnoreCase) && !entryFound[k])
                                        {
                                            entryFound[k] = true;
                                            count++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Check if all host entries were found.
                    return count == hostEntries.Length;
                }
                
                return false;
            }
            catch
            {
                return false;
            }
        }
        
        public static bool PatchHostsFile(string hostEntry)
        {
            return PatchHostsFile(new [] {hostEntry});
        }
        
        public static bool PatchHostsFile(string[] hostEntries)
        {
            try
            {                
                var fileName = GetHostsFileName();
                       
                // Check if the file exists before do anything.             
                if (File.Exists(fileName))
                {                    
                    // Save original file attributes and remove read-only, system and hidden attributes (to avoid any access error).
                    var attrs = File.GetAttributes(fileName);
                    
                    try
                    {
                        File.SetAttributes(fileName, FileAttributes.Normal);
                        
                        var lines = new List<string>(File.ReadAllLines(fileName));
                        
                        // Add all host entries.                        
                        foreach (var entry in hostEntries)                        
                            lines.Add("127.0.0.1 " + entry);
                        
                        File.WriteAllLines(fileName, lines);
                        
                        return true;
                    }
                    finally
                    {
                        // Always restore original file attributes.
                        File.SetAttributes(fileName, attrs);
                    }
                }
                
                return false;
            }
            catch
            {
                return false;
            }
        }
        
        public static bool RestoreHostsFile(string hostEntry)
        {
            return RestoreHostsFile(new [] {hostEntry});
        }
        
        public static bool RestoreHostsFile(string[] hostEntries)
        {
            try
            {
                var fileName = GetHostsFileName();
                
                // Check if the file exists before do anything.
                if (File.Exists(fileName))
                {
                    // Read all the lines in the file and process each entry.                    
                    var lines = new List<string>(File.ReadAllLines(fileName));                    
                    
                    for (int i = lines.Count - 1; i >= 0; i--)
                    {
                        bool removeLine = false;
                        
                        // Remove any trailing spaces and/or control characters.
                        var line = lines[i].Trim();
                        
                        // Process non-empty lines only.
                        if (line != string.Empty)
                        {
                            // Skip commentary lines.
                            if (!line.StartsWith("#", StringComparison.InvariantCultureIgnoreCase))
                            {
                                // Search for first space character.
                                var j = line.IndexOfAny(new char[] {'\t', ' '});
                                
                                // Split line and add a new entry to the list.
                                if (j >= 0)
                                {
                                    // Check if this entry is defined in the host entries to remove.
                                    var entry = line.Substring(j).Trim();
                                    
                                    for (int k = 0; k < hostEntries.Length; k++)
                                    {
                                        // A matching entry means this line must be removed.
                                        if (hostEntries[k].Equals(entry, StringComparison.InvariantCultureIgnoreCase))
                                        {
                                            removeLine = true;
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                        
                        if (removeLine)
                            lines.RemoveAt(i);
                    }
                    
                    // Save original file attributes and remove read-only, system and hidden attributes (to avoid any access error).
                    var attrs = File.GetAttributes(fileName);
                    File.SetAttributes(fileName, FileAttributes.Normal);
                    
                    try
                    {
                        // Overwrite original hosts file.
                        File.WriteAllLines(fileName, lines.ToArray());
                        return true;
                    }
                    finally
                    {
                        // Always restore original file attributes.
                        File.SetAttributes(fileName, attrs);
                    }
                }
                
                return false;
            }
            catch
            {
                return false;
            }
        }                
    }
}