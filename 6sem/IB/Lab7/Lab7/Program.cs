﻿using Lab7;
using System.Diagnostics;

public class Program
{
    public static void Main()
    {
        Stopwatch sw = new Stopwatch();

        string originalMessage = "Hello my name is Trubach Dmitry";
        Console.WriteLine($"Открытое сообщение: {originalMessage}");
        sw.Start();
        string decryptMessage = DESS.Encrypt("1010101010101010", "1110111001010101", originalMessage);
        sw.Stop();
        Console.WriteLine($"Time encryption: {sw.Elapsed.TotalMilliseconds} ms");
        sw.Restart();
        originalMessage = DESS.Decrypt("1010101010101010", "1110111001010101", decryptMessage);
        sw.Stop();
        Console.WriteLine($"Time decryption: {sw.Elapsed.TotalMilliseconds} ms");
        double sizeMessage = (originalMessage).Length * 8;
        double sizeEncrMessage = (decryptMessage).Length * 6;
        Console.WriteLine("Size messaage: " + (originalMessage).Length * 8);
        Console.WriteLine("Size encrypt message: " + (decryptMessage).Length * 6);
        //Console.WriteLine("Zip: " + sizeEncrMessage / sizeMessage);

        sw = new Stopwatch();
        originalMessage = "Hello my name is Trubach Dmitry";
        Console.WriteLine($"Открытое сообщение: {originalMessage}");
        sw.Start();
        decryptMessage = DESS.Encrypt("2010101010101010", "1110111001010101", originalMessage);
        sw.Stop();
        Console.WriteLine($"Time encryption: {sw.Elapsed.TotalMilliseconds} ms");
        sw.Restart();
        originalMessage = DESS.Decrypt("2010101010101010", "1110111001010101", decryptMessage);
        sw.Stop();
        Console.WriteLine($"Time decryption: {sw.Elapsed.TotalMilliseconds} ms");

    }
}