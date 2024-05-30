package org.example;

public class ASCIIConverter {
    public static String textToASCII(String text) {
        StringBuilder binaryAscii = new StringBuilder();

        for (char character : text.toCharArray()) {
            binaryAscii.append(Integer.toBinaryString(character));
        }

        return binaryAscii.toString();
    }
}
