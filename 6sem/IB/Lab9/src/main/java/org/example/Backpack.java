package org.example;

import java.util.Random;

public class Backpack {
    // Генерация сверхвозрастающей последовательности
    public int[] generate(int z) {
        Random rnd = new Random();
        int[] k = new int[z];
        int sum = 0;
        for (int i = 0; i < z; i++) {
            k[i] = rnd.nextInt(sum + 23 - sum) + sum;
            sum += k[i];
        }
        return k;
    }

    // Вычисление нормальной последовательности
    public int[] getNorm(int[] d, int a, int n, int z) {
        int[] e = new int[z];

        for (int i = 0; i < z; i++) {
            e[i] = (d[i] * a) % n;
        }
        return e;
    }

    // Зашифрование сообщения
    public int[] getCipher(int[] e, String M, int z) {
        int j = 0;
        int[] result = new int[M.length()];
        int total = 0;

        System.out.print("Исходное сообщение M: ");

        for (char Mi : M.toCharArray()) {
            total = 0;
            String Mi2 = "0" + Integer.toBinaryString(Mi); // 110010
            System.out.print(Mi2 + " ");

            for (int i = 0; i < Mi2.length(); i++) {
                if (Mi2.charAt(i) == '1') {
                    total += e[i];
                }
            }
            result[j] = total;
            j++;
        }
        return result;
    }

    // Расшифрование сообщения
    public String decipher(int[] d, int Si, int z) {
        StringBuilder res = new StringBuilder();
        StringBuilder res2 = new StringBuilder();

        for (int i = z; i > 0; i--) {
            if (Si >= d[i - 1]) {
                res.append('1');
                Si = Si - d[i - 1];
            } else {
                res.append('0');
            }
        }
        for (int i = res.length() - 1; i >= 0; i--) {
            res2.append(res.charAt(i));
        }
        return res2.toString();
    }

    public int a_1(int a, int n) {
        int res = 0;
        for (int i = 0; i < 10000; i++) {
            if (((a * i) % n) == 1) return i;
        }
        return res;
    }

    public String str(int[] a) {
        StringBuilder res = new StringBuilder();
        for (int x : a) {
            res.append(x).append("; ");
        }
        return res.toString();
    }

    public String getBytes(String str) {
        StringBuilder strB = new StringBuilder();
        for (int i = 0; i < str.length(); i++) {
            strB.append(Integer.toBinaryString(str.charAt(i)));
        }
        return strB.toString();
    }
}
