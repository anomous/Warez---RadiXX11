using System;
using System.IO;
using System.Security.Cryptography;

namespace Activator
{
    public class Symmetric
    {
        private Symmetric()
        {
        }

        public Symmetric(Symmetric.Provider provider, bool useDefaultInitializationVector = true)
        {
            switch (provider)
            {
            case Symmetric.Provider.DES:
                this._crypto = new DESCryptoServiceProvider();
                break;
            case Symmetric.Provider.RC2:
                this._crypto = new RC2CryptoServiceProvider();
                break;
            case Symmetric.Provider.Rijndael:
                this._crypto = new RijndaelManaged();
                break;
            case Symmetric.Provider.TripleDES:
                this._crypto = new TripleDESCryptoServiceProvider();
                break;
            }
            
            this.Key = this.RandomKey();
            
            if (useDefaultInitializationVector)
                this.IntializationVector = new Data("%1Az=-@qT");
            else
                this.IntializationVector = this.RandomInitializationVector();
        }

        public int KeySizeBytes
        {
            get
            {
                return this._crypto.KeySize / 8;
            }
            set
            {
                this._crypto.KeySize = checked(value * 8);
                this._key.MaxBytes = value;
            }
        }

        public int KeySizeBits
        {
            get
            {
                return this._crypto.KeySize;
            }
            set
            {
                this._crypto.KeySize = value;
                this._key.MaxBits = value;
            }
        }

        public Data Key
        {
            get
            {
                return this._key;
            }
            set
            {
                this._key = value;
                this._key.MaxBytes = this._crypto.LegalKeySizes[0].MaxSize / 8;
                this._key.MinBytes = this._crypto.LegalKeySizes[0].MinSize / 8;
                this._key.StepBytes = this._crypto.LegalKeySizes[0].SkipSize / 8;
            }
        }

        public Data IntializationVector
        {
            get
            {
                return this._iv;
            }
            set
            {
                this._iv = value;
                this._iv.MaxBytes = this._crypto.BlockSize / 8;
                this._iv.MinBytes = this._crypto.BlockSize / 8;
            }
        }

        public Data RandomInitializationVector()
        {
            this._crypto.GenerateIV();
            return new Data(this._crypto.IV);
        }

        public Data RandomKey()
        {
            this._crypto.GenerateKey();
            return new Data(this._crypto.Key);
        }

        private void ValidateKeyAndIv(bool isEncrypting)
        {
            if (this._key.IsEmpty)
            {
                if (!isEncrypting)
                    throw new CryptographicException("No key was provided for the decryption operation!");

                this._key = this.RandomKey();
            }
            
            if (this._iv.IsEmpty)
            {
                if (!isEncrypting)
                    throw new CryptographicException("No initialization vector was provided for the decryption operation!");

                this._iv = this.RandomInitializationVector();
            }
            
            this._crypto.Key = this._key.Bytes;
            this._crypto.IV = this._iv.Bytes;
        }

        public Data Encrypt(Data d, Data key)
        {
            this.Key = key;
            return this.Encrypt(d);
        }

        public Data Encrypt(Data d)
        {
            MemoryStream memoryStream = new MemoryStream();
            this.ValidateKeyAndIv(true);
            CryptoStream cryptoStream = new CryptoStream(memoryStream, this._crypto.CreateEncryptor(), CryptoStreamMode.Write);
            cryptoStream.Write(d.Bytes, 0, d.Bytes.Length);
            cryptoStream.Close();
            memoryStream.Close();
            return new Data(memoryStream.ToArray());
        }

        public Data Encrypt(Stream s, Data key, Data iv)
        {
            this.IntializationVector = iv;
            this.Key = key;
            return this.Encrypt(s);
        }

        public Data Encrypt(Stream s, Data key)
        {
            this.Key = key;
            return this.Encrypt(s);
        }

        public Data Encrypt(Stream s)
        {
            MemoryStream memoryStream = new MemoryStream();
            byte[] buffer = new byte[2049];
            this.ValidateKeyAndIv(true);
            CryptoStream cryptoStream = new CryptoStream(memoryStream, this._crypto.CreateEncryptor(), CryptoStreamMode.Write);
            
            for (int i = s.Read(buffer, 0, 2048); i > 0; i = s.Read(buffer, 0, 2048))
                cryptoStream.Write(buffer, 0, i);

            cryptoStream.Close();
            memoryStream.Close();
            return new Data(memoryStream.ToArray());
        }

        public Data Decrypt(Data encryptedData, Data key)
        {
            this.Key = key;
            return this.Decrypt(encryptedData);
        }

        public Data Decrypt(Stream encryptedStream, Data key)
        {
            this.Key = key;
            return this.Decrypt(encryptedStream);
        }

        public Data Decrypt(Stream encryptedStream)
        {
            MemoryStream memoryStream = new MemoryStream();
            byte[] buffer = new byte[2049];
            this.ValidateKeyAndIv(false);
            CryptoStream cryptoStream = new CryptoStream(encryptedStream, this._crypto.CreateDecryptor(), CryptoStreamMode.Read);
            
            for (int i = cryptoStream.Read(buffer, 0, 2048); i > 0; i = cryptoStream.Read(buffer, 0, 2048))
                memoryStream.Write(buffer, 0, i);

            cryptoStream.Close();
            memoryStream.Close();
            return new Data(memoryStream.ToArray());
        }

        public Data Decrypt(Data encryptedData)
        {
            MemoryStream stream = new MemoryStream(encryptedData.Bytes, 0, encryptedData.Bytes.Length);
            
            checked
            {
                byte[] array = new byte[encryptedData.Bytes.Length - 1 + 1];
                this.ValidateKeyAndIv(false);
                CryptoStream cryptoStream = new CryptoStream(stream, this._crypto.CreateDecryptor(), CryptoStreamMode.Read);
                
                try
                {
                    cryptoStream.Read(array, 0, encryptedData.Bytes.Length - 1);
                }
                catch (CryptographicException inner)
                {
                    throw new CryptographicException("Unable to decrypt data. The provided key may be invalid.", inner);
                }
                finally
                {
                    cryptoStream.Close();
                }
                
                return new Data(array);
            }
        }

        public static string QuickEncrypt(string value)
        {
            if (string.IsNullOrEmpty(value))
                return "";

            Data data = new Data();
            Symmetric symmetric = new Symmetric(Symmetric.Provider.TripleDES, true);
            symmetric.Key.Text = "DKIVzF6@CD4-72$C-49b3-96*-329di949mcoB49}";
            data.Text = value;
            return symmetric.Encrypt(data).Base64;
        }

        public static string QuickDecrypt(string valueInBase64Format)
        {
            if (string.IsNullOrEmpty(valueInBase64Format))
                return "";
            
            Data data = new Data();
            data.Base64 = valueInBase64Format;
            return new Symmetric(Symmetric.Provider.TripleDES, true)
            {
                Key = 
                {
                    Text = "DKIVzF6@CD4-72$C-49b3-96*-329di949mcoB49}"
                }
            }.Decrypt(data).Text;
        }

        private const string _DefaultIntializationVector = "%1Az=-@qT";
        private const int _BufferSize = 2048;
        private Data _key;
        private Data _iv;
        private SymmetricAlgorithm _crypto;

        public enum Provider
        {
            DES,
            RC2,
            Rijndael,
            TripleDES
        }
    }
}
