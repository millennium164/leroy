package br.com.leroymerlin.model;

public class Loja {

    private Integer id;
    private String nome;
    private String cidade;
    private String endereco;
    private Boolean isCentroDistribuicao;

    public Loja() {
    }

    public Loja(String nome, String cidade, String endereco, Boolean isCentroDistribuicao) {
        this.nome = nome;
        this.cidade = cidade;
        this.endereco = endereco;
        this.isCentroDistribuicao = isCentroDistribuicao;
    }

    public Loja(Integer id, String nome, String cidade, String endereco, Boolean isCentroDistribuicao) {
        this.id = id;
        this.nome = nome;
        this.cidade = cidade;
        this.endereco = endereco;
        this.isCentroDistribuicao = isCentroDistribuicao;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCidade() {
        return cidade;
    }

    public void setCidade(String cidade) {
        this.cidade = cidade;
    }

    public String getEndereco() {
        return endereco;
    }

    public void setEndereco(String endereco) {
        this.endereco = endereco;
    }

    public Boolean getIsCentroDistribuicao() {
        return isCentroDistribuicao;
    }

    public void setIsCentroDistribuicao(Boolean isCentroDistribuicao) {
        this.isCentroDistribuicao = isCentroDistribuicao;
    }
}
