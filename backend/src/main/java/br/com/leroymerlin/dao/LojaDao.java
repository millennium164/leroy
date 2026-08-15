package br.com.leroymerlin.dao;

import br.com.leroymerlin.exception.EntidadeNaoEcontradaException;
import br.com.leroymerlin.factory.ConnectionFactory;
import br.com.leroymerlin.model.Loja;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LojaDao {

    private Connection conexao;

    public LojaDao() throws SQLException {
        conexao = ConnectionFactory.getConnection();
    }

    public Loja pesquisar(int id) throws SQLException, EntidadeNaoEcontradaException {
        PreparedStatement stm = conexao.prepareStatement(
                "SELECT id, nome, cidade, endereco, is_centro_distribuicao FROM lojas WHERE id = ?");
        stm.setInt(1, id);
        ResultSet result = stm.executeQuery();
        if (!result.next()) {
            throw new EntidadeNaoEcontradaException("Loja não encontrada");
        }
        return parseLoja(result);
    }

    public void fecharConexao() throws SQLException {
        conexao.close();
    }

    private Loja parseLoja(ResultSet result) throws SQLException {
        Integer id = result.getInt("id");
        String nome = result.getString("nome");
        String cidade = result.getString("cidade");
        String endereco = result.getString("endereco");
        Boolean isCentroDistribuicao = (Boolean) result.getObject("is_centro_distribuicao");
        return new Loja(id, nome, cidade, endereco, isCentroDistribuicao);
    }
}
