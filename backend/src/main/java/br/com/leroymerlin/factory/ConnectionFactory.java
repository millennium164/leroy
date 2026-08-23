package br.com.leroymerlin.factory;

import br.com.leroymerlin.service.EnvLoader;

import java.net.URI;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionFactory {

    private static final String URL;
    private static final String USUARIO;
    private static final String SENHA;

    static {
        String databaseUrl = EnvLoader.get("DATABASE_URL");
        if (databaseUrl == null) {
            URL = "jdbc:postgresql://localhost:5432/leroy_merlin_1?characterEncoding=UTF-8";
            USUARIO = valorOuPadrao(EnvLoader.get("DB_USER"), "postgres");
            SENHA = EnvLoader.get("DB_PASSWORD");
        } else {
            // Provedores como o Render entregam postgresql://usuario:senha@host/banco,
            // formato que o driver JDBC nao aceita.
            URI uri = URI.create(databaseUrl);
            int porta = uri.getPort() == -1 ? 5432 : uri.getPort();
            String sslmode = valorOuPadrao(EnvLoader.get("DB_SSLMODE"), "require");
            URL = "jdbc:postgresql://%s:%d%s?characterEncoding=UTF-8&sslmode=%s"
                    .formatted(uri.getHost(), porta, uri.getPath(), sslmode);

            String[] credenciais = uri.getUserInfo() == null
                    ? new String[0]
                    : uri.getUserInfo().split(":", 2);
            USUARIO = credenciais.length > 0 ? credenciais[0] : null;
            SENHA = credenciais.length > 1 ? credenciais[1] : null;
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, SENHA);
    }

    private static String valorOuPadrao(String valor, String padrao) {
        return valor == null || valor.isBlank() ? padrao : valor;
    }

}
