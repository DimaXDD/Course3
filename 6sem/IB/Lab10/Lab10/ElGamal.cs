using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace Lab10
{
    public class ElGamal
    {
        public static BigInteger[] Encrypt(string plaintext, int p, int g, int x)
        {
            var stopwatch = new Stopwatch();
            stopwatch.Start();
            BigInteger y = 0, a = 0;
            BigInteger[] b = { };
            string encData = "";
            char[] array;

            // Пара p,g,x - тайный ключ
            // p - простое число
            // g < p (g - первообразный корень)
            // x < p

            y = BigInteger.ModPow(g, x, p); // y = g^x mod p - компонент ключ. информации
            array = plaintext.ToCharArray();
            int k = 20;
            a = BigInteger.ModPow(g, k, p); // a = g^k mod p
            b = new BigInteger[array.Length]; // b = (y^k * m(i)) mod p
            for (int i = 0; i < array.Length; i++)
            {
                b[i] = BigInteger.Remainder(BigInteger.Multiply(BigInteger.Pow(y, k), array[i]), p);
                encData = encData + b[i].ToString();
            }
            Console.WriteLine("\nЗашифрование (El-Gamal): " + encData);
            stopwatch.Stop();
            Console.WriteLine($"El-Gamal время зашифрования: {stopwatch.Elapsed.TotalMilliseconds:F2} ms " +
                                                    $"({stopwatch.Elapsed.TotalMilliseconds * 1000000:F0} ns)"); 
            return b;
        }

        public static string Decrypt(BigInteger[] b, int p, int g, int x)
        {
            var stopwatch = new Stopwatch();
            stopwatch.Start();
            BigInteger a = 0, p0 = 0, m1 = 0;
            BigInteger[] r = { };
            string decData = "";

            r = new BigInteger[b.Length];
            int k = 20;
            a = BigInteger.ModPow(g, k, p);
            for (int i = 0; i < b.Length; i++)
            {
                // Формула 8.12
                p0 = BigInteger.Subtract(BigInteger.Subtract(p, new BigInteger(1)), x); // p - x
                m1 = BigInteger.ModPow(a, p0, p);

                r[i] = BigInteger.Remainder(BigInteger.Multiply(m1, b[i]), p);
                decData = decData + ((char)r[i]).ToString();
            }
            Console.WriteLine("\nРасшифрование (El-Gamal): " + decData);
            stopwatch.Stop();
            Console.WriteLine($"El-Gamal время расшифрования: {stopwatch.Elapsed.TotalMilliseconds:F2} ms " +
                                        $"({stopwatch.Elapsed.TotalMilliseconds * 1000000:F0} ns)");
            return decData;
        }
    }
}
