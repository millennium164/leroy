package br.com.leroymerlin.api.dto;

public class RecomendacaoRequest {

    private int lojaId;
    private String texto;

    public int getLojaId() {
        return lojaId;
    }

    public void setLojaId(int lojaId) {
        this.lojaId = lojaId;
    }

    public String getTexto() {
        return texto;
    }

    public void setTexto(String texto) {
        this.texto = texto;
    }
}
