package br.com.leroymerlin.model;

public class Categoria {

    private Integer id;
    private String nome;
    private Integer parentId;
    private Integer nivel;

    public Categoria() {
    }

    public Categoria(String nome, Integer parentId, Integer nivel) {
        this.nome = nome;
        this.parentId = parentId;
        this.nivel = nivel;
    }

    public Categoria(Integer id, String nome, Integer parentId, Integer nivel) {
        this.id = id;
        this.nome = nome;
        this.parentId = parentId;
        this.nivel = nivel;
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

    public Integer getParentId() {
        return parentId;
    }

    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }

    public Integer getNivel() {
        return nivel;
    }

    public void setNivel(Integer nivel) {
        this.nivel = nivel;
    }
}
