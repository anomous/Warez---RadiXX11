using System;
using System.Text;
using System.IO;
using System.Globalization;

namespace Keygen
{
    class Program
    {
        private static string XorEncrypt(string text, string keyword)
        {
            var arr = Encoding.UTF8.GetBytes(text);
            var keyarr = Encoding.UTF8.GetBytes(keyword);
            var buf = new byte[arr.Length];

            for (int i = 0; i < arr.Length; ++i)
                buf[i] = (byte)(arr[i] ^ keyarr[i % keyarr.Length]);

            return Convert.ToBase64String(buf);
        }

        public static string GenerateRegKey(string hardwareKey)
        {
            return XorEncrypt(hardwareKey, "qwerty");
        }

        public static bool SaveRegKey(string regKey)
        {
            bool result = true;

            try
            {
                var path = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), ".StampSealMaker");

                if (!Directory.Exists(path))
                    Directory.CreateDirectory(path);

                path = Path.Combine(path, "m2.properties");
                string text = string.Empty;
                bool hasLicense = false;
                bool hasRegKey = false;

                if (File.Exists(path))
                {
                    var lines = File.ReadAllLines(path);

                    for (int i=0; i<lines.Length; i++)
                    {
                        if (!lines[i].StartsWith("#"))
                        {
                            if (lines[i].ToLower().Contains("license.osx"))
                            {
                                lines[i] = "license.OSX=true";
                                hasLicense = true;
                            }
                            else if (lines[i].ToLower().Contains("regkey"))
                            {
                                lines[i] = "regKey=" + regKey;
                                hasRegKey = true;
                            }
                        }

                        text += lines[i] + "\n";
                    }

                    if (!hasLicense)
                        text += "license.OSX=true\n";

                    if (!hasRegKey)
                        text += "regKey=" + regKey + "\n";
                }
                else
                    text = string.Format("#{0}\nlicense.OSX=true\nregKey={1}\n", DateTime.Now.ToString("ddd MMM dd HH:mm:ss ART yyyy", new CultureInfo("en-US")), regKey);

                File.WriteAllText(path, text);
            }
            catch
            {
                result = false;
            }

            return result;
        }

        static void Main(string[] args)
        {
            // Stamp Seal Maker - https://www.stampsealmaker.com

            Console.WriteLine("Stamp Seal Maker 3.x Keygen [by RadiXX11]");
            Console.WriteLine("=========================================\n");

            Console.Write("Hardware Key....: ");

            string hardwareKey = Console.ReadLine();

            if (!string.IsNullOrEmpty(hardwareKey))
            {
                string regKey = GenerateRegKey(hardwareKey);

                Console.WriteLine("Registration Key: {0}\n", regKey);

                if (SaveRegKey(regKey))
                    Console.WriteLine("Key was saved successfully.\n");
                else
                    Console.WriteLine("Cannot save reg key! Try to run this program as Admin.\n");
            }

            Console.Write("Press any key to continue...");
            Console.ReadKey();
        }
    }
}
