package br.com.leroymerlin.dao;

import br.com.leroymerlin.exception.EntidadeNaoEcontradaException;
import br.com.leroymerlin.factory.ConnectionFactory;
import br.com.leroymerlin.model.Categoria;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CategoriaDao {

    private Connection conexao;

    public CategoriaDao() throws SQLException {
        conexao = ConnectionFactory.getConnection();
    }

    public Categoria pesquisar(int id) throws SQLException, EntidadeNaoEcontradaException {
        PreparedStatement stm = conexao.prepareStatement(
                "SELECT id, nome, parent_id, nivel FROM categorias WHERE id = ?");
        stm.setInt(1, id);
        ResultSet result = stm.executeQuery();
        if (!result.next()) {
            throw new EntidadeNaoEcontradaException("Categoria não encontrada");
        }
        return parseCategoria(result);
    }

    public void fecharConexao() throws SQLException {
        conexao.close();
    }

    private Categoria parseCategoria(ResultSet result) throws SQLException {
        Integer id = result.getInt("id");
        String nome = result.getString("nome");
        Integer parentId = (Integer) result.getObject("parent_id");
        Integer nivel = result.getInt("nivel");
        return new Categoria(id, nome, parentId, nivel);
    }
}
