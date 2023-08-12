using System;

namespace Keygen
{
    class Program
    {
        public static void Main(string[] args)
        {
            Console.WriteLine("Net Uptime Monitor Keyfile Maker [by RadiXX11]");
            Console.WriteLine("==============================================\n");
            
            Console.Write("User Name.: ");
            string userName = Console.ReadLine();
            
            if (!string.IsNullOrEmpty(userName))
            {            
                Console.Write("User EMail: ");
                string userEMail = Console.ReadLine();
                
                if (!string.IsNullOrEmpty(userEMail))
                {
                    if (License.CreateLicenseDataFile(userName, userEMail))
                        Console.WriteLine("\nKey file generated successfully!");
                    else
                        Console.WriteLine("\nError while trying to create key file!");
                }
            }
            
            Console.Write("\nPress any key to continue . . . ");
            Console.ReadKey(true);
        }
    }
}