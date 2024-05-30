package org.example;

import static org.example.SHA256.*;

public class Main {
    public static void main(String[] args) {
        System.out.println("\nХеширование SHA256");
        long OldTicks = System.currentTimeMillis();
        //String text = generateRandomText(100000);
        String text = "Trubach Dmitry Sergeevich";
        String salt = createSalt(15);
        String hash = generateSHA256(text, salt);

        System.out.println("Message: " + text + "\nСоль: " + salt + "\nХэш:  " + hash);
        System.out.println("Время: " + (System.currentTimeMillis() - OldTicks) + " мс\n\n");
    }
}