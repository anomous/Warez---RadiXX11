using System;
using Microsoft.Win32;

namespace Keygen
{
    public static class Registration
    {
        private static string Encrypt(string registrationID, ref string phrase)
        {
            string result;
            
            if (registrationID.Trim().Length != 0)
            {
                if (phrase.Length > 16)
                    phrase = phrase.Substring(0, 16);

                var key = new Data(phrase);
                var symmetric = new Symmetric(Symmetric.Provider.Rijndael, true);
                Data data = symmetric.Encrypt(new Data(registrationID), key);
                result = data.ToHex();
            }
            else
                result = string.Empty;
                
            return result;
        }
                
        public static string GenerateRegistrationKey(string registrationID, string phrase)
        {
            string result;
            
            if (!string.IsNullOrEmpty(phrase))
            {
                try
                {
                    if (string.IsNullOrEmpty(registrationID))
                        registrationID = GetRegistrationID();
                
                    result = Encrypt(registrationID.ToUpper(), ref phrase);
                    result = result.Remove(16, checked(result.Length - 16));
                    
                    // Add some spacers, not really neeeded but it looks better... ;)
                    result = result.Insert(4, "-").Insert(9, "-").Insert(14, "-");
                }
                catch
                {
                    result = string.Empty;
                }
            }
            else
                result = string.Empty;
            
            return result;
        }
        
        public static string GetRegistrationID()
        {
            string result;
            
            // Note: RegistryView.Registry64 is ignored on 32-Bit systems, but must be present
            // if this application will run as a 32-Bit process (otherwise it will return an empty string).
            
            try
            {
                using (var root = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, RegistryView.Registry64))
                {
                    using (var key = root.OpenSubKey(@"Software\Microsoft\Windows NT\CurrentVersion", false))
                    {
                        result = key.GetValue("ProductId").ToString();
                    };
                };
            }
            catch
            {
                result = string.Empty;                
            }

            return result;
        }
    }
}
