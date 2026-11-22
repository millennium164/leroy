package br.com.leroymerlin.service;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public final class EnvLoader {

    private EnvLoader() {
    }

    public static String get(String key) {
        String fromEnv = System.getenv(key);
        if (fromEnv != null && !fromEnv.isBlank()) {
            return fromEnv.trim();
        }
        String fromProperty = System.getProperty(key);
        if (fromProperty != null && !fromProperty.isBlank()) {
            return fromProperty.trim();
        }
        for (Path path : candidatePaths()) {
            if (!Files.isRegularFile(path)) {
                continue;
            }
            try {
                for (String line : Files.readAllLines(path, StandardCharsets.UTF_8)) {
                    String trimmed = line.trim();
                    if (trimmed.isEmpty() || trimmed.startsWith("#") || !trimmed.contains("=")) {
                        continue;
                    }
                    int eq = trimmed.indexOf('=');
                    String name = trimmed.substring(0, eq).trim();
                    if (!key.equals(name)) {
                        continue;
                    }
                    String value = trimmed.substring(eq + 1).trim();
                    if ((value.startsWith("\"") && value.endsWith("\""))
                            || (value.startsWith("'") && value.endsWith("'"))) {
                        value = value.substring(1, value.length() - 1);
                    }
                    if (!value.isBlank()) {
                        return value;
                    }
                }
            } catch (IOException ignored) {
                // tenta o próximo arquivo
            }
        }
        return null;
    }

    private static List<Path> candidatePaths() {
        Path cwd = Path.of(System.getProperty("user.dir"));
        return List.of(
                cwd.resolve(".env"),
                cwd.resolve("backend").resolve(".env"),
                cwd.getParent() == null ? cwd.resolve(".env") : cwd.getParent().resolve(".env")
        );
    }
}
