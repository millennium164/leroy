package br.com.leroymerlin.dao;

import br.com.leroymerlin.exception.EntidadeNaoEcontradaException;
import br.com.leroymerlin.factory.ConnectionFactory;
import br.com.leroymerlin.model.Produto;
import br.com.leroymerlin.util.Textos;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProdutoDao {

    private static final String COLUNAS = "p.id, p.loja_id, p.nome, p.marca, p.vendedor, p.categoria_id, "
            + "p.preco, p.quantidade_estoque, p.fileira, p.especificacoes, c.nome AS categoria_nome";
    private static final String FROM = "FROM produtos p LEFT JOIN categorias c ON c.id = p.categoria_id ";

    private Connection conexao;

    public ProdutoDao() throws SQLException {
        conexao = ConnectionFactory.getConnection();
    }

    public Produto pesquisar(int id, int lojaId) throws SQLException, EntidadeNaoEcontradaException {
        PreparedStatement stm = conexao.prepareStatement(
                "SELECT " + COLUNAS + " " + FROM + "WHERE p.id = ? AND p.loja_id = ?");
        stm.setInt(1, id);
        stm.setInt(2, lojaId);
        ResultSet result = stm.executeQuery();
        if (!result.next()) {
            throw new EntidadeNaoEcontradaException(
                    "Produto não encontrado para id " + id + " na loja " + lojaId);
        }
        return parseProduto(result);
    }

    public List<Produto> buscarPorTexto(int lojaId, String q, int limite) throws SQLException {
        if (q == null || q.isBlank()) {
            return List.of();
        }
        String termo = "%" + q.trim() + "%";
        PreparedStatement stm = conexao.prepareStatement(
                "SELECT " + COLUNAS + " " + FROM
                        + "WHERE p.loja_id = ? AND p.quantidade_estoque > 0 "
                        + "AND (p.nome ILIKE ? OR COALESCE(p.marca, '') ILIKE ? OR COALESCE(c.nome, '') ILIKE ?) "
                        + "ORDER BY p.nome LIMIT ?");
        stm.setInt(1, lojaId);
        stm.setString(2, termo);
        stm.setString(3, termo);
        stm.setString(4, termo);
        stm.setInt(5, limite);
        return parseLista(stm.executeQuery());
    }

    public List<Produto> listarEmEstoque(int lojaId, int limite) throws SQLException {
        PreparedStatement stm = conexao.prepareStatement(
                "SELECT " + COLUNAS + " " + FROM
                        + "WHERE p.loja_id = ? AND p.quantidade_estoque > 0 "
                        + "ORDER BY p.nome LIMIT ?");
        stm.setInt(1, lojaId);
        stm.setInt(2, limite);
        return parseLista(stm.executeQuery());
    }

    public void fecharConexao() throws SQLException {
        conexao.close();
    }

    private List<Produto> parseLista(ResultSet result) throws SQLException {
        List<Produto> lista = new ArrayList<>();
        while (result.next()) {
            lista.add(parseProduto(result));
        }
        return lista;
    }

    private Produto parseProduto(ResultSet result) throws SQLException {
        Integer id = result.getInt("id");
        Integer lojaId = result.getInt("loja_id");
        String nome = Textos.corrigir(result.getString("nome"));
        String marca = Textos.corrigir(result.getString("marca"));
        String vendedor = Textos.corrigir(result.getString("vendedor"));
        Integer categoriaId = result.getInt("categoria_id");
        BigDecimal preco = result.getBigDecimal("preco");
        Integer quantidadeEstoque = result.getInt("quantidade_estoque");
        Integer fileira = (Integer) result.getObject("fileira");
        String especificacoes = Textos.corrigir(result.getString("especificacoes"));
        String categoriaNome = Textos.corrigir(result.getString("categoria_nome"));
        return new Produto(id, lojaId, nome, marca, vendedor, categoriaId, preco,
                quantidadeEstoque, fileira, especificacoes, categoriaNome);
    }
}
