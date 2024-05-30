package org.example;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Base64;

public class DocumentConverter {
    public static void convertToBase64(String inputFileName, String outputFileName) {
        String basePath = "src/main/resources/";
        String inputFilePath = basePath + inputFileName;
        String outputFilePath = basePath + outputFileName;

        File outputFile = new File(outputFilePath);
        if (!outputFile.exists()) {
            try {
                outputFile.createNewFile();
            } catch (IOException e) {
                e.printStackTrace();
                return;
            }
        }

        String documentContent = readDocument(inputFilePath);
        String base64Content = encodeToBase64(documentContent);
        writeBase64Document(base64Content, outputFilePath);
        System.out.println("The document has been successfully converted to Base64 format.");
    }


    private static String readDocument(String filePath) {
        try {
            Path path = Paths.get(filePath);
            byte[] documentBytes = Files.readAllBytes(path);
            return new String(documentBytes);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String encodeToBase64(String documentContent) {
        byte[] documentBytes = documentContent.replaceAll("\\r|\\n", "").getBytes();
        byte[] encodedBytes = Base64.getEncoder().encode(documentBytes);
        return new String(encodedBytes);
    }

    private static void writeBase64Document(String base64Content, String filePath) {
        try (PrintWriter writer = new PrintWriter(filePath)) {
            writer.println(base64Content);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
    }
}