using System;

namespace LicGen
{
    public class VersionInfo
    {
        public int MajorVersion { get; set; }

        public int MinorVersion { get; set; }

        public int PatchVersion { get; set; }

        public VersionInfo(string str)
        {
            string[] array = str.Split(new char[]
            {
                '.'
            });
            
            this.MajorVersion = int.Parse(array[0]);
            this.MinorVersion = int.Parse(array[1]);
            this.PatchVersion = int.Parse(array[2]);
        }

        public bool IsNewer(VersionInfo version)
        {
            return version.MajorVersion > this.MajorVersion || (version.MajorVersion == this.MajorVersion && version.MinorVersion > this.MinorVersion) || (version.MajorVersion == this.MajorVersion && version.MinorVersion == this.MinorVersion && version.PatchVersion > this.PatchVersion);
        }

        public override string ToString()
        {
            return string.Format("{0}.{1}.{2}", this.MajorVersion, this.MinorVersion, this.PatchVersion);
        }
    }
}
