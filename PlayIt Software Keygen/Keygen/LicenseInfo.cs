using System;
using System.Collections.Generic;

namespace Keygen
{    
    public class ModuleLicense
    {
        public string Name { get; set; }
        public DateTime Valid { get; set; }
        public DateTime Expires { get; set; }
        public DateTime? AllowBuildsBefore { get; set; }
        public int NumberOfSeats { get; set; }
    }
    
    public class LicenseInfo
    {
        public Guid ApplicationGuid { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string ClientId { get; set; }
        public DateTime? AllowBuildsBefore { get; set; }
        public DateTime Valid { get; set; }
        public DateTime Expires { get; set; }
        public List<ModuleLicense> Modules { get; set; }
        public string Hash { get; set; }
        public string MachineName { get; set; }
        public string MachineCode { get; set; }
        public string Notes { get; set; }
    }
}
