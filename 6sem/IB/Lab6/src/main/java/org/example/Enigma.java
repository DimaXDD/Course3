package org.example;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

public class Enigma {
    public static final String pathToFolder = "src/main/texts";
    public static final String fileNameOpen = "text.txt";
    public static final String fileNameEncryptEnigma = "encrypt_enigma.txt";
    public static final String fileNameDecryptEnigma = "decrypt_enigma.txt";
    public static final String alphabet = "abcdefghijklmnopqrstuvwxyz";

    // Алфавиты роторов
    public static final String alphabetRightRotor  =  "ajdksiruxblhwtmcqgznpyfvoe";
    public static final String alphabetMiddleRotor =  "esovpzjayquirhxlnftgkdcmwb";
    public static final String alphabetLeftRotor   =  "jpgvoumfyqbenhzrdkasxlictw";

    Map<Character, Character> alphabetReflector = new HashMap<>();
    int length = alphabet.length();

    private int rotorRightCurrentPosition =  0;
    private int rotorMiddleCurrentPosition = 0;
    private int rotorLeftCurrentPosition  =  0;

    private int rotorRightTotalOffsets =  0;
    private int rotorMiddleTotalOffsets = 0;
    private int rotorLeftTotalOffsets  =  0;

    private int rotorRightFullRotations =  0;
    private int rotorMiddleFullRotations = 0;
    private int rotorLeftFullRotations  =  0;

    private int rotorRightStep =  2;
    private int rotorMiddleStep = 2;
    private int rotorLeftStep  =  1;

    public Enigma(int rightRotorPosition, int middleRotorPosition, int leftRotorPosition) {
        if (rightRotorPosition >= 0 && rightRotorPosition < length &&
                middleRotorPosition >= 0 && middleRotorPosition < length &&
                leftRotorPosition  >= 0 && leftRotorPosition  <  length) {
            rotorRightCurrentPosition = rightRotorPosition;
            rotorMiddleCurrentPosition = middleRotorPosition;
            rotorLeftCurrentPosition  = leftRotorPosition;
        } else {
            throw new IllegalArgumentException("Позиции роторов должны быть от 0 до " + (length - 1));
        }

        alphabetReflector = fillTheRelector();
    }

    public char[] Encrypt(char[] openText) {
        rotorRightTotalOffsets = rotorRightCurrentPosition;
        rotorMiddleTotalOffsets = rotorMiddleCurrentPosition;
        rotorLeftTotalOffsets = rotorLeftCurrentPosition;
        StringBuilder sb = new StringBuilder();

        for (char letter : openText) {
            if (alphabet.indexOf(letter) != -1) {
                char letterAfterRightRotor = encryptWithRotor(letter, alphabet, alphabetRightRotor, rotorRightCurrentPosition);
                char letterAfterMiddleRotor = encryptWithRotor(letterAfterRightRotor, alphabet, alphabetMiddleRotor, rotorMiddleCurrentPosition);
                char letterAfterLeftRotor = encryptWithRotor(letterAfterMiddleRotor, alphabet, alphabetLeftRotor, rotorLeftCurrentPosition);
                char letterAfterReflector = encryptWithReflector(letterAfterLeftRotor);
                char letterAfterLeftRotorBackwards = encryptWithRotor(letterAfterReflector, alphabetLeftRotor, alphabet, rotorLeftCurrentPosition);
                char letterAfterMiddleRotorBackwards = encryptWithRotor(letterAfterLeftRotorBackwards, alphabetMiddleRotor, alphabet, rotorMiddleCurrentPosition);
                char letterAfterRightRotorBackwards = encryptWithRotor(letterAfterMiddleRotorBackwards, alphabetRightRotor, alphabet, rotorRightCurrentPosition);

                rotorRightTotalOffsets += rotorRightStep;
                rotorRightCurrentPosition = rotorRightTotalOffsets % length;

                if (rotorRightTotalOffsets / length > 0) {
                    rotorRightFullRotations = rotorRightTotalOffsets / length;
                    rotorMiddleTotalOffsets = rotorRightFullRotations * rotorMiddleStep;
                    rotorMiddleCurrentPosition = rotorMiddleTotalOffsets % length;
                } if (rotorMiddleTotalOffsets / length > 0) {
                    rotorMiddleFullRotations = rotorMiddleTotalOffsets / length;
                    rotorLeftTotalOffsets = rotorMiddleFullRotations * rotorLeftStep;
                    rotorLeftCurrentPosition = rotorLeftTotalOffsets % length;
                } if (rotorLeftTotalOffsets / length > 0) {
                    rotorLeftFullRotations = rotorLeftTotalOffsets / length;
                }
                sb.append(letterAfterRightRotorBackwards);
            } else {
                sb.append(letter);
            }
        }
        return sb.toString().toCharArray();
    }

    public char[] Decrypt(char[] openText) {
        rotorRightTotalOffsets = rotorRightCurrentPosition;
        rotorMiddleTotalOffsets = rotorMiddleCurrentPosition;
        rotorLeftTotalOffsets = rotorLeftCurrentPosition;
        StringBuilder sb = new StringBuilder();

        for (char letter : openText) {
            if (alphabet.indexOf(letter) != -1) {
                char letterAfterRightRotor = decryptWithRotor(letter, alphabet, alphabetRightRotor, rotorRightCurrentPosition);
                char letterAfterMiddleRotor = decryptWithRotor(letterAfterRightRotor, alphabet, alphabetMiddleRotor, rotorMiddleCurrentPosition);
                char letterAfterLeftRotor = decryptWithRotor(letterAfterMiddleRotor, alphabet, alphabetLeftRotor, rotorLeftCurrentPosition);
                char letterAfterReflector = encryptWithReflector(letterAfterLeftRotor);
                char letterAfterLeftRotorBackwards = decryptWithRotor(letterAfterReflector, alphabetLeftRotor, alphabet, rotorLeftCurrentPosition);
                char letterAfterMiddleRotorBackwards = decryptWithRotor(letterAfterLeftRotorBackwards, alphabetMiddleRotor, alphabet, rotorMiddleCurrentPosition);
                char letterAfterRightRotorBackwards = decryptWithRotor(letterAfterMiddleRotorBackwards, alphabetRightRotor, alphabet, rotorRightCurrentPosition);

                rotorRightTotalOffsets += rotorRightStep;
                rotorRightCurrentPosition = rotorRightTotalOffsets % length;

                if (rotorRightTotalOffsets / length > 0) {
                    rotorRightFullRotations = rotorRightTotalOffsets / length;
                    rotorMiddleTotalOffsets = rotorRightFullRotations * rotorMiddleStep;
                    rotorMiddleCurrentPosition = rotorMiddleTotalOffsets % length;
                }
                if (rotorMiddleTotalOffsets / length > 0) {
                    rotorMiddleFullRotations = rotorMiddleTotalOffsets / length;
                    rotorLeftTotalOffsets = rotorMiddleFullRotations * rotorLeftStep;
                    rotorLeftCurrentPosition = rotorLeftTotalOffsets % length;
                }
                if (rotorLeftTotalOffsets / length > 0) {
                    rotorLeftFullRotations = rotorLeftTotalOffsets / length;
                }

                sb.append(letterAfterRightRotorBackwards);
            } else {
                sb.append(letter);
            }
        }
        return sb.toString().toCharArray();
    }

    private char encryptWithRotor(char letter, String alphabet, String alphabetEncryption, int offset) {
        int index = alphabet.indexOf(letter);
        int indexEncrypted = (index + offset) % length;
        return alphabetEncryption.charAt(indexEncrypted);
    }

    private char decryptWithRotor(char letter, String alphabet, String alphabetEncryption, int offset) {
        int index = alphabet.indexOf(letter);
        int indexEncrypted = (index - offset + length) % length;
        return alphabetEncryption.charAt(indexEncrypted);
    }

    private char encryptWithReflector(char letter) {
        if (alphabetReflector.containsKey(letter))
            return alphabetReflector.get(letter);
        else if (alphabetReflector.containsValue(letter))
            return alphabetReflector.entrySet()
                    .stream()
                    .filter(entry -> entry.getValue() == letter)
                    .map(Map.Entry::getKey)
                    .findFirst()
                    .orElse(letter);
        else
            return letter;
    }

    private static Map<Character, Character> fillTheRelector() {
        Map<Character, Character> reflector = new HashMap<>();
        reflector.put('a', 'y');
        reflector.put('b', 'r');
        reflector.put('c', 'u');
        reflector.put('d', 'h');
        reflector.put('e', 'q');
        reflector.put('f', 's');
        reflector.put('g', 'l');
        reflector.put('i', 'p');
        reflector.put('j', 'x');
        reflector.put('k', 'n');
        reflector.put('m', 'o');
        reflector.put('t', 'z');
        reflector.put('v', 'w');

        return reflector;
    }

    public static String readFile(String fileName) throws IOException {
        return new String(Files.readAllBytes(Paths.get(pathToFolder, fileName)));
    }

    public static void writeFile(String fileName, String content) throws IOException {
        Files.write(Paths.get(pathToFolder, fileName), content.getBytes());
    }

    public static Map<Character, Integer> getSymbolAppearances(String str) {
        Map<Character, Integer> symbolAppearances = new HashMap<>();
        for (char c : str.toCharArray()) {
            if (!symbolAppearances.containsKey(c))
                symbolAppearances.put(c, 1);
            else
                symbolAppearances.put(c, symbolAppearances.get(c) + 1);
        }
        return symbolAppearances;
    }

    public static void printSymbolFrequencies(String fileName, String alphabet) throws IOException {
        String text = readFile(fileName).toLowerCase().replaceAll("[^a-z]", "");
        Map<Character, Integer> symbolAppearances = getSymbolAppearances(text);

        int totalSymbols = 0;
        for (char c : text.toCharArray()) {
            if (alphabet.indexOf(c) != -1) {
                totalSymbols++;
            }
        }

        System.out.println("Частоты символов для документа " + fileName);
        double totalFrequency = 0.0;
        for (char c : alphabet.toCharArray()) {
            int count = symbolAppearances.getOrDefault(c, 0);
            double frequencyFraction = (double) count / totalSymbols;
            totalFrequency += frequencyFraction;
            System.out.printf("Символ: %c, Частота: %.4f\n", c, frequencyFraction);
        }
        System.out.printf("Итоговая сумма вероятностей: %.4f\n", totalFrequency);
    }
}