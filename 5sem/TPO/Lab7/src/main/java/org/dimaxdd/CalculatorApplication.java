package org.dimaxdd;

import java.util.Optional;
import java.util.Scanner;

public class CalculatorApplication {

    public static void main(String[] args) {
        Calculator calculator = new Calculator();
        System.out.println("Введите строку запроса для расчета:");
        System.out.println("(Чтобы выйти напишите q)");
        Scanner scanner = new Scanner(System.in);
        while (true) {
            String line = scanner.nextLine();
            if (line.contains("=") && !line.endsWith("=")) {
                System.out.println("Это похоже на уравнение, попробуйте снова");
            } else if (line.equalsIgnoreCase("Q"))
                break;
            else {
                line = line.replaceAll("=", "");
                Optional<Double> result = calculator.solve(line);
                if (result.isPresent())
                    System.out.println(result.get());
                else System.out.println("Неверный ввод");
            }
        }
    }
}
