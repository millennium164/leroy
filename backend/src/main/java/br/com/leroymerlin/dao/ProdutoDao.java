package br.com.leroymerlin.dao;

import br.com.leroymerlin.exception.EntidadeNaoEcontradaException;
import br.com.leroymerlin.factory.ConnectionFactory;
import br.com.leroymerlin.model.Produto;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ProdutoDao {

    private Connection conexao;

    public ProdutoDao() throws SQLException {
        conexao = ConnectionFactory.getConnection();
    }

    public Produto pesquisar(int id, int lojaId) throws SQLException, EntidadeNaoEcontradaException {
        PreparedStatement stm = conexao.prepareStatement(
                "SELECT id, loja_id, nome, marca, vendedor, categoria_id, preco, quantidade_estoque, fileira, especificacoes "
                        + "FROM produtos WHERE id = ? AND loja_id = ?");
        stm.setInt(1, id);
        stm.setInt(2, lojaId);
        ResultSet result = stm.executeQuery();
        if (!result.next()) {
            throw new EntidadeNaoEcontradaException(
                    "Produto não encontrado para id " + id + " na loja " + lojaId);
        }
        return parseProduto(result);
    }

    public void fecharConexao() throws SQLException {
        conexao.close();
    }

    private Produto parseProduto(ResultSet result) throws SQLException {
        Integer id = result.getInt("id");
        Integer lojaId = result.getInt("loja_id");
        String nome = result.getString("nome");
        String marca = result.getString("marca");
        String vendedor = result.getString("vendedor");
        Integer categoriaId = result.getInt("categoria_id");
        BigDecimal preco = result.getBigDecimal("preco");
        Integer quantidadeEstoque = result.getInt("quantidade_estoque");
        Integer fileira = (Integer) result.getObject("fileira");
        String especificacoes = result.getString("especificacoes");
        return new Produto(id, lojaId, nome, marca, vendedor, categoriaId, preco,
                quantidadeEstoque, fileira, especificacoes);
    }
}
