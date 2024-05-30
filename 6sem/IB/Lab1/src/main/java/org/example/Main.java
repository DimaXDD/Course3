package org.example;

import java.io.IOException;

public class Main {
    public static void main(String[] args) throws IOException {
        String bulgarianAlphabet = "абвгдежзийклмнопрстуфхцчшщъьюя";
        String romanianAlphabet = "abcdefghijklmnopqrstuvwxyzăâîșț";
        String binaryAlphabet = "01";


        var bulgarian = Entropy.readFromFile("text_on_bulgarian.txt");
        var romanian = Entropy.readFromFile("text_on_romanian.txt");
        var binary = Entropy.readFromFile("text_on_binary.txt");
        var myName = Entropy.readFromFile("my_name.txt");
        var myNameASCII = Entropy.readFromFile("my_name_ASCII.txt");

        Entropy.printSymbolFrequencies("text_on_bulgarian.txt", bulgarianAlphabet);
        Entropy.printSymbolFrequencies("text_on_romanian.txt", romanianAlphabet);
        System.out.println("\n");

        System.out.println("Entropy of language (bulgarian): " + Entropy.getShannonEntropy(bulgarian));
        System.out.println("Entropy of language (romanian): " + Entropy.getShannonEntropy(romanian));
        System.out.println("Entropy of language (binary): " + Entropy.getShannonEntropy(binary));

        System.out.println("\n");
        System.out.println("If P = 0:");
        System.out.println("Information amount (bulgarian): " + Entropy.getInformationAmount(bulgarianAlphabet, myName));
        System.out.println("Information amount (romanian): " + Entropy.getInformationAmount(romanianAlphabet, myName));
        System.out.println("Information amount (ASCII): " + Entropy.getInformationAmount(binaryAlphabet, myNameASCII));

        System.out.println("\n");
        System.out.println("If P = 0.1:");
        System.out.println("Information amount (bulgarian): " + Entropy.getInformationAmount(bulgarianAlphabet, myName, 0.1));
        System.out.println("Information amount (romanian): " + Entropy.getInformationAmount(romanianAlphabet, myName, 0.1));
        System.out.println("Information amount (ASCII): " + Entropy.getInformationAmount(binaryAlphabet, myNameASCII, 0.1));

        System.out.println("\n");
        System.out.println("If P = 0.5:");
        System.out.println("Information Amount (bulgarian): " + Entropy.getInformationAmount(bulgarianAlphabet, myName, 0.5));
        System.out.println("Information Amount (romanian): " + Entropy.getInformationAmount(romanianAlphabet, myName, 0.5));
        System.out.println("Information Amount (ASCII): " + Entropy.getInformationAmount(binaryAlphabet, myNameASCII, 0.5));

        System.out.println("\n");
        System.out.println("If P = 1:");
        System.out.println("Information Amount (bulgarian): " + Entropy.getInformationAmount(bulgarian, myName, 1));
        System.out.println("Information Amount (romanian): " + Entropy.getInformationAmount(romanian, myName, 1));
        System.out.println("Information Amount (ASCII): " + Entropy.getInformationAmount(binaryAlphabet, myNameASCII, 1));

    }
}