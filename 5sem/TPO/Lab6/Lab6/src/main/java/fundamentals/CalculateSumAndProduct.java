package fundamentals;

public class CalculateSumAndProduct {
    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("Введите как минимум два целых числа.");
            return;
        }

        int sum = 0;
        int product = 1;

        for (String arg : args) {
            int num = Integer.parseInt(arg);
            sum += num;
            product *= num;
        }

        System.out.println("Сумма: " + sum);
        System.out.println("Произведение: " + product);
    }
}