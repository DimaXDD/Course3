package org.example;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class Cypher {
    public static final String pathToFolder = "src/main/texts";
    public static final String fileNameOpen = "text.txt";
    public static final String fileNameEncryptRoute = "encrypt_route.txt";
    public static final String fileNameDecryptRoute = "decrypt_route.txt";
    public static final String fileNameEncryptMultiple = "encrypt_multiple.txt";
    public static final String fileNameDecryptMultiple = "decrypt_multiple.txt";
    public static final String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    // Зашифровать маршрутным перестановочным шифром
    public static char[] encryptRouteSwap(int rows, int cols, String fileName) throws IOException {
        char[] openText = readFile(fileName).toCharArray();
        char[][] data = convertToTwoDimensionalArray(openText, rows, cols);
        char[] result = new char[rows * cols];
        int index = 0;

        boolean direction = true; // true = down, false = up

        for (int i = 0; i < cols; ++i) {
            if (direction) {
                for (int j = 0; j < rows; ++j)
                    result[index++] = data[j][i];
            } else {
                for (int j = rows - 1; j >= 0; --j)
                    result[index++] = data[j][i];
            }
            direction = !direction;
        }
        return result;
    }

    // Расшифровать маршрутным перестановочным шифром
    public static char[][] decryptRouteSwap(int rows, int cols, String fileName) throws IOException {
        char[] encryptedData = readFile(fileName).toCharArray();
        char[][] result = new char[rows][cols];
        int index = 0;

        boolean direction = true; // true = down, false = up

        for (int i = 0; i < cols; ++i) {
            if (direction) {
                for (int j = 0; j < rows; ++j)
                    result[j][i] = encryptedData[index++];
            } else {
                for (int j = rows - 1; j >= 0; --j)
                    result[j][i] = encryptedData[index++];
            }
            direction = !direction;
        }
        return result;
    }

    // Зашифровать шифром множественной перестановки
    public static String encodeMultiple(String text, String columnKey, String rowKey) {
        int columnLength = columnKey.length();
        int rowLength = rowKey.length();
        int index = 0;
        int size = (int) Math.ceil((double) text.length() / (rowLength * columnLength));
        char[][] matrix = new char[rowLength][columnLength];
        StringBuilder encryptedText = new StringBuilder();

        for (int k = 0; k < size; k++) {
            for (int i = 0; i < rowLength; i++) {
                for (int j = 0; j < columnLength; j++) {
                    if (index < text.length()) {
                        matrix[i][j] = text.charAt(index++);
                    } else {
                        matrix[i][j] = '\0';
                    }
                }
            }

            char[][] buff1 = new char[rowLength][columnLength];
            int pr1 = 0;
            HashSet<Integer> processedIndexes1 = new HashSet<>();
            for (char column : columnKey.toCharArray()) {
                for (int columnIndex = 0; columnIndex < columnKey.length(); columnIndex++) {
                    if (column == columnKey.charAt(columnIndex) && !processedIndexes1.contains(columnIndex)) {
                        processedIndexes1.add(columnIndex);
                        for (int i = 0; i < rowLength; i++) {
                            buff1[i][pr1] = matrix[i][columnIndex];
                        }
                        pr1++;
                    }
                }
            }

            char[][] buff2 = new char[rowLength][columnLength];
            int pr2 = 0;
            HashSet<Integer> processedIndexes2 = new HashSet<>();
            for (char row : rowKey.toCharArray()) {
                for (int rowIndex = 0; rowIndex < rowKey.length(); rowIndex++) {
                    if (row == rowKey.charAt(rowIndex) && !processedIndexes2.contains(rowIndex)) {
                        processedIndexes2.add(rowIndex);
                        for (int i = 0; i < columnLength; i++) {
                            buff2[pr2][i] = buff1[rowIndex][i];
                        }
                        pr2++;
                    }
                }
            }

            for (int i = 0; i < columnLength; i++) {
                for (int j = 0; j < rowLength; j++) {
                    encryptedText.append(buff2[j][i]);
                }
            }
        }
        return encryptedText.toString();
    }

    // Расшифровать шифром множественной перестановки
    public static String decodeMultiple(String text, String columnKey, String rowKey) {
        int columnLength = columnKey.length();
        int rowLength = rowKey.length();
        int index = 0;
        int size = (int) Math.ceil((double) text.length() / (rowLength * columnLength));
        char[][] matrix = new char[rowLength][columnLength];
        StringBuilder decodeText = new StringBuilder();

        for (int k = 0; k < size; k++) {
            for (int i = 0; i < rowLength; i++) {
                for (int j = 0; j < columnLength; j++) {
                    if (index < text.length()) {
                        matrix[i][j] = text.charAt(index++);
                    } else {
                        matrix[i][j] = '\0';
                    }
                }
            }

            char[][] buff1 = new char[rowLength][columnLength];
            int pr1 = 0;
            HashSet<Integer> processedIndexes1 = new HashSet<>();
            for (char row : rowKey.toCharArray()) {
                for (int rowIndex = 0; rowIndex < rowKey.length(); rowIndex++) {
                    if (row == rowKey.charAt(rowIndex) && !processedIndexes1.contains(rowIndex)) {
                        processedIndexes1.add(rowIndex);
                        for (int i = 0; i < columnLength; i++) {
                            buff1[rowIndex][i] = matrix[pr1][i];
                        }
                        pr1++;
                    }
                }
            }

            char[][] buff2 = new char[rowLength][columnLength];
            int pr2 = 0;
            HashSet<Integer> processedIndexes2 = new HashSet<>();
            for (char column : columnKey.toCharArray()) {
                for (int columnIndex = 0; columnIndex < columnKey.length(); columnIndex++) {
                    if (column == columnKey.charAt(columnIndex) && !processedIndexes2.contains(columnIndex)) {
                        processedIndexes2.add(columnIndex);
                        for (int i = 0; i < rowLength; i++) {
                            buff2[i][columnIndex] = buff1[i][pr2];
                        }
                        pr2++;
                    }
                }
            }

            for (int i = 0; i < columnLength; i++) {
                for (int j = 0; j < rowLength; j++) {
                    decodeText.append(buff2[j][i]);
                }
            }
        }
        return decodeText.toString().replaceAll("\0", "");
    }

    // Функция для визуализации двумерного массива
    public static void printTable(char[][] table) {
        for (char[] row : table) {
            for (char c : row) {
                System.out.print(c + " ");
            }
            System.out.println();
        }
    }

    // Функция для считывания файла
    public static String readFile(String fileName) throws IOException {
        return new String(Files.readAllBytes(Paths.get(pathToFolder, fileName)));
    }

    // Функция для записи шифрованного файла
    public static void writeFile(String fileName, String content) throws IOException {
        Files.write(Paths.get(pathToFolder, fileName), content.getBytes());
    }

    // Конвертировать одномерный массив char[] в двумерный массив char[][]
    public static char[][] convertToTwoDimensionalArray(char[] array, int rows, int cols) {
        char[][] result = new char[rows][cols];

        for (int i = 0; i < rows; ++i)
            for (int j = 0; j < cols; ++j) {
                if (i * cols + j < array.length) {
                    result[i][j] = array[i * cols + j];
                } else {
                    result[i][j] = '_'; // Заполнитель
                }
            }

        return result;
    }

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

    // Функция распределения частотных свойств
    public static void printSymbolFrequencies(String fileName, String alphabet) throws IOException {
        String text = readFile(fileName).toUpperCase().replace(" ", "");
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
