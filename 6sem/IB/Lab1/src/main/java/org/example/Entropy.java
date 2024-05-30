package org.example;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class Entropy {
    // Количество появлений символов в строке
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

    // Энтропия Шеннона
    public static double getShannonEntropy(String str) {
        Map<Character, Integer> symbolAppearances = getSymbolAppearances(str);
        double entropy = 0.0;
        for (int value : symbolAppearances.values()) {
            double P = (double) value / str.length();
            entropy -= P * (Math.log(P) / Math.log(2));
        }
        return Math.round(entropy * 1000.0) / 1000.0;
    }

    // Функция распределения частотных свойств
    public static void printSymbolFrequencies(String fileName, String alphabet) throws IOException {
        String text = readFromFile(fileName).replace(" ", "");
        Map<Character, Integer> symbolAppearances = getSymbolAppearances(text);

        int totalSymbols = 0;
        for (char c : text.toCharArray()) {
            if (alphabet.indexOf(c) != -1) {
                totalSymbols++;
            }
        }

        System.out.println("Частоты символов для документа " + fileName);
        double totalFrequency = 0.0;
        for (Map.Entry<Character, Integer> entry : symbolAppearances.entrySet()) {
            // Принадлежит ли символ алфавиту
            if (alphabet.indexOf(entry.getKey()) != -1) {
                double frequencyFraction = (double) entry.getValue() / totalSymbols;
                totalFrequency += frequencyFraction;
                System.out.printf("Символ: %c, Частота: %.4f\n", entry.getKey(), frequencyFraction);
            }
        }
        System.out.printf("Итоговая сумма вероятностей: %.4f\n", totalFrequency);
    }

    // Количество информации
    public static double getInformationAmount(String alphabet, String str) {
        if (isBinaryAlphabet(alphabet))
            return str.length();
        double informationAmount = getShannonEntropy(alphabet) * str.length();
        return Math.round(informationAmount * 1000.0) / 1000.0;
    }

    // Эффективная энтропия
    public static double getEffectiveEntropy(String alphabet, double p) {
        double q = 1 - p;
        if (isBinaryAlphabet(alphabet) && (p == 0 || q == 0))
            return 1;
        if (!isBinaryAlphabet(alphabet) && p == 1)
            return 0;
        return 1 - (-p * (Math.log(p) / Math.log(2)) - q * (Math.log(q) / Math.log(2)));
    }

    // Количество информации при наличии вероятности ошибки
    public static double getInformationAmount(String alphabet, String str, double p) {
        double informationAmount = getShannonEntropy(alphabet) * str.length() * getEffectiveEntropy(alphabet, p);
        return Math.round(informationAmount * 1000.0) / 1000.0;
    }

    // Проверка, является ли алфавит бинарным
    private static boolean isBinaryAlphabet(String alphabet) {
        return getSymbolAppearances(alphabet).size() == 2;
    }

    // Метод для чтения текста из файла
    public static String readFromFile(String fileName) throws IOException {
        String pathToFolder = "src/main/resources/";
        String filePath = pathToFolder + fileName;
        String text = "";
        BufferedReader br = new BufferedReader(new FileReader(filePath));
        String line;
        while ((line = br.readLine()) != null) {
            text += line.toLowerCase();
        }
        br.close();
        return text;
    }
}
