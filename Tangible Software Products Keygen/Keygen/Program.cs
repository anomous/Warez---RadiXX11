using System;

namespace Keygen
{
    class Program
    {
        public static void Main(string[] args)
        {
            string regCode, orderNum;
            
            Console.WriteLine("Tangible Software Products Keygen [by RadiXX11]");
            Console.WriteLine("===============================================");
            Console.WriteLine();
            
            Licensing.GenerateRegCode(out regCode, out orderNum);
            
            Console.WriteLine("Registration Code: {0}", regCode);
            Console.WriteLine("Order Number.....: {0}", orderNum);
            Console.WriteLine();
            
            Console.Write("Press any key to continue . . . ");
            Console.ReadKey(true);
        }
    }
}