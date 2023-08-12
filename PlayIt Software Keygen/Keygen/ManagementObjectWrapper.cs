using System;
using System.Collections.Generic;
using System.Linq;
using System.Management;

namespace Keygen
{
    internal class ManagementObjectWrapper
    {
        public ManagementObjectWrapper(ManagementObject oManagementObject)
        {
            this.m_oManagementObject = oManagementObject;
            this.m_hsNames = new HashSet<string>(from o in this.m_oManagementObject.Properties.OfType<PropertyData>() select o.Name);
        }

        public void Print()
        {
            Console.WriteLine(this.m_oManagementObject.Path);
            
            foreach (PropertyData propertyData in this.m_oManagementObject.Properties)
                Console.WriteLine(propertyData.Name + " = " + propertyData.Value);

            Console.WriteLine();
        }

        public string this[string sKey]
        {
            get
            {
                return this.m_hsNames.Contains(sKey) ? Convert.ToString(this.m_oManagementObject[sKey]) : string.Empty;
            }
        }

        private readonly ManagementObject m_oManagementObject;
        private readonly HashSet<string> m_hsNames;
    }
    
    internal static class WrapperExtensions
    {
        internal static IEnumerable<ManagementObjectWrapper> Wrap(this IEnumerable<ManagementObject> en)
        {
            if (en == null)
                throw new ArgumentNullException("en");

            return from o in en select new ManagementObjectWrapper(o);
        }
    }
}
