﻿using System;
using System.Security.Cryptography;
using System.Text;

namespace Lab7
{
    public class DESS
    {
        public static string Encrypt(string keyOne, string keyTwo, string message)
        {
            using (TripleDESCryptoServiceProvider tdes = new TripleDESCryptoServiceProvider())
            {
                tdes.Mode = CipherMode.ECB;
                tdes.Padding = PaddingMode.Zeros;
                byte[] key1 = Encoding.ASCII.GetBytes(keyOne);
                byte[] key2 = Encoding.ASCII.GetBytes(keyTwo);
                string encryptedMessage = "";
                using (ICryptoTransform encryptor1 = tdes.CreateEncryptor(key1, new byte[8]))
                using (ICryptoTransform decryptor2 = tdes.CreateDecryptor(key2, new byte[8]))
                {
                    byte[] encryptedBytes = encryptor1.TransformFinalBlock(Encoding.UTF8.GetBytes(message), 0, message.Length);
                    byte[] decryptedBytes = decryptor2.TransformFinalBlock(encryptedBytes, 0, encryptedBytes.Length);
                    byte[] reencryptedBytes = encryptor1.TransformFinalBlock(decryptedBytes, 0, decryptedBytes.Length);
                    encryptedMessage = Convert.ToBase64String(reencryptedBytes);
                    Console.WriteLine("Зашифрованное сообщение: " + encryptedMessage);

                }
                return encryptedMessage;
            }
        }

        public static string Decrypt(string keyOne, string keyTwo, string message)
        {
            string decryptedMessage = "";
            using (TripleDESCryptoServiceProvider tdes = new TripleDESCryptoServiceProvider())
            {
                tdes.Mode = CipherMode.ECB;
                tdes.Padding = PaddingMode.Zeros;
                byte[] key1 = Encoding.ASCII.GetBytes(keyOne);
                byte[] key2 = Encoding.ASCII.GetBytes(keyTwo);
                using (ICryptoTransform decryptor1 = tdes.CreateDecryptor(key1, new byte[8]))
                using (ICryptoTransform encryptor2 = tdes.CreateEncryptor(key2, new byte[8]))
                using (ICryptoTransform decryptor3 = tdes.CreateDecryptor(key1, new byte[8]))
                {
                    byte[] encryptedBytes = Convert.FromBase64String(message);
                    byte[] decryptedBytes = decryptor1.TransformFinalBlock(encryptedBytes, 0, encryptedBytes.Length);
                    byte[] reencryptedBytes = encryptor2.TransformFinalBlock(decryptedBytes, 0, decryptedBytes.Length);
                    byte[] finalDecryptedBytes = decryptor3.TransformFinalBlock(reencryptedBytes, 0, reencryptedBytes.Length);

                    decryptedMessage = Encoding.UTF8.GetString(finalDecryptedBytes);
                    Console.WriteLine("Расшифрованное сообщение: " + decryptedMessage);
                }
            }

            return decryptedMessage;
        }

    }
}