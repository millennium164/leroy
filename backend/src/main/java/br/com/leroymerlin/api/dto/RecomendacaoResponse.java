package br.com.leroymerlin.api.dto;

import java.util.ArrayList;
import java.util.List;

public class RecomendacaoResponse {

    private String explicacao;
    private List<ProdutoRecomendado> produtos = new ArrayList<>();

    public String getExplicacao() {
        return explicacao;
    }

    public void setExplicacao(String explicacao) {
        this.explicacao = explicacao;
    }

    public List<ProdutoRecomendado> getProdutos() {
        return produtos;
    }

    public void setProdutos(List<ProdutoRecomendado> produtos) {
        this.produtos = produtos;
    }
}
