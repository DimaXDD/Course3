package org.example;

public class XOR {
    public static String xor(String a, String b) {
        // Приведение строк к одинаковой длине
        if (a.length() > b.length()) {
            b = padWithZeros(b, a.length() - b.length());
        } else if (b.length() > a.length()) {
            a = padWithZeros(a, b.length() - a.length());
        }

        StringBuilder xorResult = new StringBuilder();

        for (int i = 0; i < a.length(); i++) {
            int xorValue = a.charAt(i) ^ b.charAt(i);
            xorResult.append(Integer.toBinaryString(xorValue));
        }

        return xorResult.toString();
    }

    public static String padWithZeros(String s, int paddingCount) {
        StringBuilder sb = new StringBuilder(s);

        for (int i = 0; i < paddingCount; i++) {
            sb.append("0");
        }

        return sb.toString();
    }
}
