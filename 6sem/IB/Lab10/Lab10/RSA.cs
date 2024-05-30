using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace Lab10
{
    public class RSA
    {
        public static byte[] EncryptRSA(byte[] plaintext, RSAParameters publicKey)
        {
            var stopwatch = new Stopwatch();
            stopwatch.Start();
            using var rsa = new RSACryptoServiceProvider();
            rsa.ImportParameters(publicKey);
            stopwatch.Stop();

            Console.WriteLine($"RSA время зашифрования: {stopwatch.Elapsed.TotalMilliseconds:F2} ms " +
                $"({stopwatch.Elapsed.TotalMilliseconds * 1000000:F0} ns)");
            return rsa.Encrypt(plaintext, true);
        }


        public static byte[] DecryptRSA(byte[] ciphertext, RSAParameters privateKey)
        {
            var stopwatch = new Stopwatch();
            stopwatch.Start();
            using var rsa = new RSACryptoServiceProvider();
            rsa.ImportParameters(privateKey);
            stopwatch.Stop();

            Console.WriteLine($"RSA время зашифрования: {stopwatch.Elapsed.TotalMilliseconds:F2} ms " +
                            $"({stopwatch.Elapsed.TotalMilliseconds * 1000000:F0} ns)");
            return rsa.Decrypt(ciphertext, true);
        }
    }
}
