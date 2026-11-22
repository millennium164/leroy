package br.com.leroymerlin.model;

import java.math.BigDecimal;

public class Produto {

    private Integer id;
    private Integer lojaId;
    private String nome;
    private String marca;
    private String vendedor;
    private Integer categoriaId;
    private BigDecimal preco;
    private Integer quantidadeEstoque;
    private Integer fileira;
    private String especificacoes;
    private String categoriaNome;

    public Produto() {
    }

    public Produto(String nome, String marca, String vendedor, Integer categoriaId,
                   BigDecimal preco, Integer quantidadeEstoque, Integer fileira, String especificacoes) {
        this.nome = nome;
        this.marca = marca;
        this.vendedor = vendedor;
        this.categoriaId = categoriaId;
        this.preco = preco;
        this.quantidadeEstoque = quantidadeEstoque;
        this.fileira = fileira;
        this.especificacoes = especificacoes;
    }

    public Produto(Integer id, Integer lojaId, String nome, String marca, String vendedor,
                   Integer categoriaId, BigDecimal preco, Integer quantidadeEstoque,
                   Integer fileira, String especificacoes) {
        this(id, lojaId, nome, marca, vendedor, categoriaId, preco, quantidadeEstoque,
                fileira, especificacoes, null);
    }

    public Produto(Integer id, Integer lojaId, String nome, String marca, String vendedor,
                   Integer categoriaId, BigDecimal preco, Integer quantidadeEstoque,
                   Integer fileira, String especificacoes, String categoriaNome) {
        this.id = id;
        this.lojaId = lojaId;
        this.nome = nome;
        this.marca = marca;
        this.vendedor = vendedor;
        this.categoriaId = categoriaId;
        this.preco = preco;
        this.quantidadeEstoque = quantidadeEstoque;
        this.fileira = fileira;
        this.especificacoes = especificacoes;
        this.categoriaNome = categoriaNome;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getLojaId() {
        return lojaId;
    }

    public void setLojaId(Integer lojaId) {
        this.lojaId = lojaId;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getVendedor() {
        return vendedor;
    }

    public void setVendedor(String vendedor) {
        this.vendedor = vendedor;
    }

    public Integer getCategoriaId() {
        return categoriaId;
    }

    public void setCategoriaId(Integer categoriaId) {
        this.categoriaId = categoriaId;
    }

    public BigDecimal getPreco() {
        return preco;
    }

    public void setPreco(BigDecimal preco) {
        this.preco = preco;
    }

    public Integer getQuantidadeEstoque() {
        return quantidadeEstoque;
    }

    public void setQuantidadeEstoque(Integer quantidadeEstoque) {
        this.quantidadeEstoque = quantidadeEstoque;
    }

    public Integer getFileira() {
        return fileira;
    }

    public void setFileira(Integer fileira) {
        this.fileira = fileira;
    }

    public String getEspecificacoes() {
        return especificacoes;
    }

    public void setEspecificacoes(String especificacoes) {
        this.especificacoes = especificacoes;
    }

    public String getCategoriaNome() {
        return categoriaNome;
    }

    public void setCategoriaNome(String categoriaNome) {
        this.categoriaNome = categoriaNome;
    }
}
