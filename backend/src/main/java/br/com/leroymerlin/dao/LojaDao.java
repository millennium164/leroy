package br.com.leroymerlin.dao;

import br.com.leroymerlin.exception.EntidadeNaoEcontradaException;
import br.com.leroymerlin.factory.ConnectionFactory;
import br.com.leroymerlin.model.Loja;
import br.com.leroymerlin.util.Textos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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

    public List<Loja> listar() throws SQLException {
        PreparedStatement stm = conexao.prepareStatement(
                "SELECT id, nome, cidade, endereco, is_centro_distribuicao FROM lojas ORDER BY nome");
        ResultSet result = stm.executeQuery();
        List<Loja> lojas = new ArrayList<>();
        while (result.next()) {
            lojas.add(parseLoja(result));
        }
        return lojas;
    }

    public void fecharConexao() throws SQLException {
        conexao.close();
    }

    private Loja parseLoja(ResultSet result) throws SQLException {
        Integer id = result.getInt("id");
        String nome = Textos.corrigir(result.getString("nome"));
        String cidade = Textos.corrigir(result.getString("cidade"));
        String endereco = Textos.corrigir(result.getString("endereco"));
        Boolean isCentroDistribuicao = (Boolean) result.getObject("is_centro_distribuicao");
        return new Loja(id, nome, cidade, endereco, isCentroDistribuicao);
    }
}
