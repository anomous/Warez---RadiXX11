using System;

namespace Keygen
{
    class Program
    {
        public static void Main(string[] args)
        {
            Console.WriteLine("MLD - Multi Language Dictionary Keygen [by RadiXX11]");
            Console.WriteLine("====================================================");
            Console.WriteLine();
            
            string regID = Registration.GetRegistrationID();            
            
            if (string.IsNullOrEmpty(regID))
            {
                Console.Write("Registration ID..: ");
                regID = Console.ReadLine();
            }
            
            if (!string.IsNullOrEmpty(regID))
            {
                string phrase = string.Empty;                
                Console.Write("Phrase (anything): ");
                phrase = Console.ReadLine();
                
                if (!string.IsNullOrEmpty(phrase))
                {
                    string regKey = Registration.GenerateRegistrationKey(regID, phrase);                
                    Console.WriteLine("Registration Key.: {0}", regKey);
                }
            }
            
            Console.WriteLine();
            Console.Write("Press any key to continue . . . ");
            Console.ReadKey(true);
        }
    }
}