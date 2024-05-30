using Lab10;
using System.Collections;
using System.Diagnostics;
using System.IO;
using System.Numerics;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Text;

public class Program
{
    private static void Main(string[] args)
    {
        string text;

        using (var streamReader = new StreamReader("E:\\3course\\6sem\\IB\\Lab10\\Lab10\\file.txt"))
        {
            Console.WriteLine("Исходный текст: " + streamReader.ReadToEnd());
            streamReader.BaseStream.Position = 0; // Чтобы переменную text было видно в El-Gamal
            text = streamReader.ReadToEnd().ToLower();
        }
        var openText = File.ReadAllBytes("E:\\3course\\6sem\\IB\\Lab10\\Lab10\\file.txt");

        RSAParameters publicKey;
        RSAParameters privateKey;

        using (var rsa = new RSACryptoServiceProvider(4096))
        {
            publicKey = rsa.ExportParameters(false);
            privateKey = rsa.ExportParameters(true);
        }

        var encryptedTextRSA = Lab10.RSA.EncryptRSA(openText, publicKey);
        var decryptedTextRSA = Lab10.RSA.DecryptRSA(encryptedTextRSA, privateKey);

        Encoding encoding = Encoding.UTF8;
        string textDecodeEncrypt = encoding.GetString(encryptedTextRSA);
        string textDecodeDecrypt = encoding.GetString(decryptedTextRSA);

        Console.WriteLine("Кол-во символов в RSA (зашифрование): " + textDecodeEncrypt.Length);
        Console.WriteLine("Расшифрование RSA: " + textDecodeDecrypt);

        int p = 137, g = 50, x = 15;
        var encryptedTextGamal = ElGamal.Encrypt(text, p, g, x);
        var decryptedTextGamal = ElGamal.Decrypt(encryptedTextGamal, p, g, x);
    }


}
