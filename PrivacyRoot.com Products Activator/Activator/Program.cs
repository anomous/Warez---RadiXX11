using System;

namespace Activator
{    
    class Program
    {
        public static readonly ProductLicense[] ProductList =
        {
            new ProductLicense("Prevent Restore", "wfds"),
            new ProductLicense("Safe Startup", "stgu"),
            new ProductLicense("Secret Disk", "sede"),
            new ProductLicense("Wipe", "wipe")
        };
        
        public static void Main(string[] args)
        {
            string option = null;
            
            do
            {
                Console.WriteLine("PrivacyRoot.com Products Activator [by RadiXX11]");
                Console.WriteLine("================================================\n");            
                Console.WriteLine("Select the product to activate:\n");            
                
                int productIndex = 0;
                
                foreach (var product in ProductList)
                    Console.WriteLine("{0}. {1}", productIndex++, product.ProductName);
                
                Console.Write("\nOption [X = Exit]: ");                
                
                option = Console.ReadLine().ToUpper();
                
                Console.WriteLine();                
                
                if (int.TryParse(option, out productIndex) && (productIndex >= 0) && (productIndex < ProductList.Length))
                {
                    ProductList[productIndex].ActivatePRO();
                    
                    Console.WriteLine("--------------------------------------");
                    Console.WriteLine("{0} activated successfully", ProductList[productIndex].ProductName);
                    Console.WriteLine("--------------------------------------\n");                    
                }
                
            } while (option != "X");
        }
    }
}