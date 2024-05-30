package org.example;

import java.util.List;

public class Main {
    public static void main(String[] args) {
        // 13 вариант
        long m = 379;
        long n = 411;

        // НОД двух чисел
        long gcd_two = Functions.GreatestCommonDivisor(m, n);
        System.out.println("НОД (m, n) = " + gcd_two);

        // НОД трех чисел
        long gcd_three = Functions.GreatestCommonDivisor(8, Functions.GreatestCommonDivisor(24, 72));
        System.out.println("НОД (8, 24, 72) = " + gcd_three);

        // Простые числа от 2 до n
        List<Long> primes = Functions.getPrimes(n);
        System.out.printf("Простые числа от 2 до %d (%d числа(-ел)):\n", n, primes.size());
//        for (long prime : primes) {
//            System.out.print(prime + ", ");
//        }
        int count = 0;
        for (long prime : primes) {
            if (count != 0 && count % 20 == 0) {
                System.out.println();
            }

            if (prime != primes.get(primes.size() - 1)) {
                System.out.print(prime + ", ");
            } else {
                System.out.print(prime);
            }

            count++;
        }
        System.out.println("\n");

        // Простые числа от m до n
        List<Long> primes_m_n = Functions.getPrimes(m, n);
        System.out.printf("Простые числа от %d до %d (%d числа(-ел)):\n", m, n, primes_m_n.size());
        int count_m_n = 0;
        for (long prime : primes_m_n) {
            if (count_m_n != 0 && count_m_n % 20 == 0) {
                System.out.println();
            }

            if (prime != primes_m_n.get(primes_m_n.size() - 1)) {
                System.out.print(prime + ", ");
            } else {
                System.out.print(prime);
            }

            count_m_n++;
        }
        System.out.println("\n");

        // Примерное количество простых чисел до n
        double approximatePrimesCount = Functions.getApproximatePrimesCount(n);
        System.out.printf("Примерное количество простых чисел до %d: %.1f%n", n, approximatePrimesCount);
        System.out.println("\n");

        // Каноническая форма
        String canonicalForm1 = Functions.getCanonicalForm(2312);
        String canonicalFormM = Functions.getCanonicalForm(m);
        String canonicalFormN = Functions.getCanonicalForm(n);

        System.out.printf("Число %d в канонической форме: %s%n", 2312, canonicalForm1);
        System.out.printf("Число %d в канонической форме: %s%n", m, canonicalFormM);
        System.out.printf("Число %d в канонической форме: %s%n", n, canonicalFormN);

        boolean isPrimeConcatenated = Functions.isPrimeByNumbersConcat(m, n);
        System.out.printf("Число, состоящее из конкатенации %d и %d (%d), является простым: %b%n", m, n, Functions.concatNumbers(m,n), isPrimeConcatenated);

    }
}