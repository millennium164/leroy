package br.com.leroymerlin.factory;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionFactory {

    private static final String URL = "jdbc:postgresql://localhost:5432/leroy_merlin_1?characterEncoding=UTF-8";
    private static final String USUARIO = "postgres";
    private static final String SENHA = "***SENHA-REMOVIDA***";

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, SENHA);
    }

}
