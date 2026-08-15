package br.com.leroymerlin.view;

import br.com.leroymerlin.dao.ProdutoDao;
import br.com.leroymerlin.exception.EntidadeNaoEcontradaException;
import br.com.leroymerlin.model.Produto;

import java.sql.SQLException;
import java.util.Scanner;

public class ProdutoView {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.println("Busca de produto por loja");
        try {
            ProdutoDao dao = new ProdutoDao();
            int escolha;
            do {
                pesquisarProduto(scanner, dao);
                System.out.println("1-Nova busca");
                System.out.println("0-Sair");
                escolha = scanner.nextInt();
            } while (escolha != 0);
            System.out.println("Saindo...");
            dao.fecharConexao();
        } catch (SQLException e) {
            System.err.println("Erro ao conectar ao banco de dados: " + e.getMessage());
        }
    }

    private static void pesquisarProduto(Scanner scanner, ProdutoDao dao) {
        System.out.println("Digite o id da loja:");
        int lojaId = scanner.nextInt();
        System.out.println("Digite o id do produto:");
        int produtoId = scanner.nextInt();

        try {
            Produto produto = dao.pesquisar(produtoId, lojaId);
            System.out.println("Produto encontrado:");
            System.out.println("nome: " + produto.getNome());
            System.out.println("marca: " + produto.getMarca());
            System.out.println("vendedor: " + produto.getVendedor());
            System.out.println("preco: " + produto.getPreco());
            System.out.println("quantidade_estoque: " + produto.getQuantidadeEstoque());
        } catch (SQLException | EntidadeNaoEcontradaException e) {
            System.err.println("Erro ao pesquisar produto: " + e.getMessage());
        }
    }
}
