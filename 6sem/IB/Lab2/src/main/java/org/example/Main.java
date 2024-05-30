package org.example;

import java.io.IOException;

public class Main {
    public static void main(String[] args) throws IOException {
        String romanianAlphabet = "abcdefghijklmnopqrstuvwxyzăâîșț";
        String base64Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

        String inputFilePath = "document.txt";
        String outputFilePath = "document_base64.txt";
        DocumentConverter.convertToBase64(inputFilePath, outputFilePath);

        var text1 = Entropy.readFromFile("document.txt");
        var text2 = Entropy.readFromFile("document_base64.txt");

        Entropy.printSymbolFrequencies("document.txt", romanianAlphabet);
        Entropy.printSymbolFrequencies("document_base64.txt", base64Alphabet);

        System.out.println("Shannon entropy of language (romanian): " + Entropy.getShannonEntropy(text1));
        System.out.println("Shannon entropy of language (base64): " + Entropy.getShannonEntropy(text2));
        System.out.println("Hartley entropy of language (romanian): " + Entropy.getHartleyEntropy(romanianAlphabet));
        System.out.println("Hartley entropy of language (base64): " + Entropy.getHartleyEntropy(base64Alphabet));
        System.out.println("Redundancy of language (romanian): " + Entropy.getRedundancy(romanianAlphabet,text1));
        System.out.println("Redundancy of language (base64): " + Entropy.getRedundancy(base64Alphabet, text2));

        System.out.println("\n");

        String buffer1 = "HelloWorld";
        String buffer2 = "JavaRocks";
        String surname = "TRUBACH";
        String lastname = "DMITRY";

        String asciiBuffer1 = ASCIIConverter.textToASCII(buffer1);
        String asciiBuffer2 = ASCIIConverter.textToASCII(buffer2);
        String asciiSurname = ASCIIConverter.textToASCII(surname);
        String asciiLastname = ASCIIConverter.textToASCII(lastname);

        String base64Buffer1 = DocumentConverter.encodeToBase64(buffer1);
        String base64Buffer2 = DocumentConverter.encodeToBase64(buffer2);
        String base64Surname = DocumentConverter.encodeToBase64(surname);
        String base64Lastname = DocumentConverter.encodeToBase64(lastname);

        System.out.println("Surname: " + surname);
        System.out.println("Lastname: " + lastname);
        System.out.println("Buffer 1 in ASCII: " + asciiBuffer1);
        System.out.println("Buffer 2 in ASCII: " + asciiBuffer2);
        System.out.println("Buffer 1 in Base64: " + base64Buffer1);
        System.out.println("Buffer 2 in Base64: " + base64Buffer2);
        System.out.println("Surname in ASCII: " + asciiSurname);
        System.out.println("Lastname in ASCII: " + asciiLastname);
        System.out.println("Surname in Base64: " + base64Surname);
        System.out.println("Lastname in Base64: " + base64Lastname);


        String xorAsciiResult1 = XOR.xor(asciiBuffer1, asciiSurname);
        String xorAsciiResult2 = XOR.xor(asciiBuffer2, asciiLastname);
        System.out.println("XOR Result for ASCII Buffer 1 and Surname: " + xorAsciiResult1);
        System.out.println("XOR Result for ASCII Buffer 2 and Lastname: " + xorAsciiResult2);

        String xorBase64Result1 = XOR.xor(base64Buffer1, base64Surname);
        String xorBase64Result2 = XOR.xor(base64Buffer2, base64Lastname);
        System.out.println("XOR Result for Base64 Buffer 1 and Surname: " + xorBase64Result1);
        System.out.println("XOR Result for Base64 Buffer 2 and Lastname: " + xorBase64Result2);


    }
}