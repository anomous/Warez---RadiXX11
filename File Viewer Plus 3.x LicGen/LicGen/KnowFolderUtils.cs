using System;
using System.Runtime.InteropServices;

namespace LicGen
{
    internal static class KnownFolderUtils
    {
        [DllImport("shell32.dll")]
        private static extern int SHGetKnownFolderPath([MarshalAs(UnmanagedType.LPStruct)] Guid rfid, uint dwFlags, IntPtr hToken, out IntPtr pszPath);

        public static string GetFolderFromKnownFolderGUID(Guid guid)
        {
            return KnownFolderUtils.pinvokePath(guid, KnownFolderUtils.KnownFolderFlag.DEFAULT_PATH);
        }

        private static string pinvokePath(Guid guid, KnownFolderUtils.KnownFolderFlag flags)
        {
            IntPtr ptr;
            KnownFolderUtils.SHGetKnownFolderPath(guid, (uint)flags, IntPtr.Zero, out ptr);
            string result = Marshal.PtrToStringUni(ptr);
            Marshal.FreeCoTaskMem(ptr);
            return result;
        }

        public static readonly Guid Public = Guid.Parse("DFDF76A2-C82A-4D63-906A-5644AC457385");

        [Flags]
        public enum KnownFolderFlag : uint
        {
            None = 0u,
            CREATE = 32768u,
            DONT_VERFIY = 16384u,
            DONT_UNEXPAND = 8192u,
            NO_ALIAS = 4096u,
            INIT = 2048u,
            DEFAULT_PATH = 1024u,
            NOT_PARENT_RELATIVE = 512u,
            SIMPLE_IDLIST = 256u,
            ALIAS_ONLY = 2147483648u
        }
    }
}
