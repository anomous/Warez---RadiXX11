using System;
using System.IO;

namespace LicGen
{
    internal static class FileSystem
    {
        internal static void EnsureAppFolder()
        {
            string appDataFolder = FileSystem.GetAppDataFolder(FileSystem.AppName);
            
            if (!Directory.Exists(appDataFolder))
            {
                Directory.CreateDirectory(appDataFolder);
            }
            
            string appDataFolder2 = FileSystem.GetAppDataFolder(FileSystem.OldAppName);
            
            if (File.Exists(Path.Combine(appDataFolder2, "logcrawler.lcc")))
            {
                File.Move(Path.Combine(appDataFolder2, "logcrawler.lcc"), Path.Combine(appDataFolder, "goldilogs.glc"));
            }
        }

        internal static string GetAppDataFolder()
        {
            return FileSystem.GetAppDataFolder(FileSystem.AppName);
        }

        private static string GetAppDataFolder(string appName)
        {
            return Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), appName);
        }

        internal static string OldAppName = "LogCrawler";
        internal static string AppName = "Goldilogs";
    }
}
