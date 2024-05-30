package org.example;

import java.util.ArrayList;
import java.util.List;

public class Functions {
    // Алгоритм Евклида для НОД
    public static long GreatestCommonDivisor(long a, long b) {
        if (a == 0) {
            return b;
        }
        if (b == 0) {
            return a;
        }
        if (a == 1 || b == 1) {
            return 1;
        }

        while (a != 0 &&  b != 0) {
            if (a > b)
                a -= b;
            else
                b -= a;
        }

        return (a > b) ? a : b;
    }

    // Получить простые числа от 2 до n
    public static List<Long> getPrimes(long n) {
        List<Long> primes = new ArrayList<>();
        for (long i = 2; i <= n; i++) {
            boolean isPrime = true;
            for (long j = 2; j * j <= i; j++) {
                if (i % j == 0) {
                    isPrime = false;
                    break;
                }
            }
            if (isPrime) {
                primes.add(i);
            }
        }
        return primes;
    }

    // Получить простые числа от m до n
    public static List<Long> getPrimes(long m, long n) {
        if (m > n) {
            long temp = m;
            m = n;
            n = temp;
        }

        boolean[] isPrime = new boolean[(int) (n - m + 1)];
        for (int i = 0; i < isPrime.length; i++) {
            isPrime[i] = true;
        }

        for (long i = 2; i * i <= n; i++) {
            for (long j = (m + i - 1) / i * i; j <= n; j += i) {
                if (j != i && j >= m) {
                    isPrime[(int) (j - m)] = false;
                }
            }
        }

        List<Long> primes = new ArrayList<>();
        for (long i = m; i <= n; i++) {
            if (i < 2) {
                continue;
            }
            if (isPrime[(int) (i - m)]) {
                primes.add(i);
            }
        }

        return primes;
    }

    // Представить число в виде канонического разложения на множители
    public static String getCanonicalForm(long number) {
        StringBuilder result = new StringBuilder();
        long divisor = 2;
        while (number > 1) {
            int power = 0;
            while (number % divisor == 0) {
                number /= divisor;
                power++;
            }
            if (power > 0) {
                result.append(divisor);
                if (power > 1) {
                    result.append("^").append(power);
                }
                if (number > 1) {
                    result.append(" * ");
                }
            }
            divisor++;
        }
        return result.toString();
    }

    // Простое ли число, состоящее из конкатенации цифр m || n
    public static boolean isPrimeByNumbersConcat(long m, long n) {
        long concatenatedNumber = concatNumbers(m, n);
        return isPrime(concatenatedNumber);
    }

    // Конкатенация чисел (вспомогательная функция к isPrimeByNumbersConcat)
    public static long concatNumbers(long m, long n) {
        String concatenatedString = String.valueOf(m) + String.valueOf(n);
        return Long.parseLong(concatenatedString);
    }

    // Простое ли число (вспомогательная функция к isPrimeByNumbersConcat)
    public static boolean isPrime(long n) {
        if (n < 2) {
            return false;
        }
        for (long i = 2; i * i <= n; i++) {
            if (n % i == 0) {
                return false;
            }
        }
        return true;
    }

    // Получить примерное количество простых чисел [n / ln(n)]
    public static double getApproximatePrimesCount(long n) {
        return Math.round(n / Math.log(n) * 10) / 10.0;
    }

}
