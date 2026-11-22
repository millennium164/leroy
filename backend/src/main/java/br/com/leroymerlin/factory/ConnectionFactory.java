package br.com.leroymerlin.factory;

import br.com.leroymerlin.service.EnvLoader;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionFactory {

    public static Connection getConnection() throws SQLException {
        String url = required("JDBC_URL");
        String usuario = required("DB_USER");
        String senha = required("DB_PASSWORD");
        return DriverManager.getConnection(url, usuario, senha);
    }

    private static String required(String key) {
        String value = EnvLoader.get(key);
        if (value == null || value.isBlank()) {
            throw new IllegalStateException(
                    key + " não configurada. Defina no arquivo .env (veja .env.example).");
        }
        return value;
    }
}
