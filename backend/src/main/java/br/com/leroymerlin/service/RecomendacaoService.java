package br.com.leroymerlin.service;

import br.com.leroymerlin.api.dto.ProdutoRecomendado;
import br.com.leroymerlin.api.dto.RecomendacaoResponse;
import br.com.leroymerlin.dao.ProdutoDao;
import br.com.leroymerlin.exception.EntidadeNaoEcontradaException;
import br.com.leroymerlin.model.Produto;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.sql.SQLException;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class RecomendacaoService {

    private static final int LIMITE_CATALOGO = 80;
    private static final int LIMITE_RECOMENDACOES = 6;

    private final GeminiClient gemini = new GeminiClient();
    private final ObjectMapper mapper = new ObjectMapper();

    public RecomendacaoResponse recomendar(int lojaId, String texto) throws Exception {
        RecomendacaoResponse resposta = new RecomendacaoResponse();
        if (texto == null || texto.isBlank()) {
            resposta.setExplicacao("Descreva o produto ou o problema que você quer resolver.");
            return resposta;
        }

        ProdutoDao dao = new ProdutoDao();
        try {
            List<Produto> catalogo = dao.listarEmEstoque(lojaId, LIMITE_CATALOGO);
            if (catalogo.isEmpty()) {
                resposta.setExplicacao("Não há produtos em estoque nesta loja no momento. Tente outra unidade.");
                return resposta;
            }

            String jsonGemini = gemini.generateJson(montarPrompt(lojaId, texto.trim(), catalogo));
            JsonNode root = mapper.readTree(jsonGemini);
            resposta.setExplicacao(root.path("explicacao").asText(
                    "Encontramos algumas opções em estoque para a sua busca."));

            Set<Integer> idsCatalogo = catalogo.stream()
                    .map(Produto::getId)
                    .collect(Collectors.toCollection(LinkedHashSet::new));

            JsonNode itens = root.path("produtos");
            if (itens.isArray()) {
                for (JsonNode item : itens) {
                    if (resposta.getProdutos().size() >= LIMITE_RECOMENDACOES) {
                        break;
                    }
                    int id = item.path("id").asInt(-1);
                    if (!idsCatalogo.contains(id)) {
                        continue;
                    }
                    try {
                        Produto produto = dao.pesquisar(id, lojaId);
                        if (produto.getQuantidadeEstoque() == null || produto.getQuantidadeEstoque() <= 0) {
                            continue;
                        }
                        ProdutoRecomendado dto = toDto(produto, item.path("motivo").asText(null));
                        resposta.getProdutos().add(dto);
                    } catch (EntidadeNaoEcontradaException ignored) {
                        // id alucinado pelo modelo
                    }
                }
            }

            if (resposta.getProdutos().isEmpty()) {
                String explicacao = resposta.getExplicacao();
                if (explicacao == null || explicacao.isBlank()) {
                    explicacao = "Não encontramos um produto correspondente. Tente reformular a descrição "
                            + "(por exemplo: o ambiente, o material ou o tipo de ferramenta).";
                }
                resposta.setExplicacao(explicacao);
            }
            return resposta;
        } finally {
            dao.fecharConexao();
        }
    }

    private String montarPrompt(int lojaId, String texto, List<Produto> catalogo) {
        StringBuilder catalogoTxt = new StringBuilder();
        for (Produto p : catalogo) {
            catalogoTxt.append("- id=").append(p.getId())
                    .append(" | nome=").append(n(p.getNome()))
                    .append(" | marca=").append(n(p.getMarca()))
                    .append(" | categoria=").append(n(p.getCategoriaNome()))
                    .append(" | preco=").append(p.getPreco())
                    .append('\n');
        }

        return """
                Você é o assistente de compras da loja física Leroy Merlin (loja_id=%d).
                O cliente descreveu o seguinte (pode ser o nome de um produto ou um problema a resolver):
                \"%s\"

                Use SOMENTE produtos do catálogo em estoque abaixo. Não invente ids.
                Escolha no máximo %d produtos que melhor atendam a necessidade.
                Se nada servir, devolva a lista produtos vazia e peça para o cliente reformular.

                Catálogo em estoque:
                %s
                Responda APENAS um JSON no formato:
                {"explicacao":"texto curto em português","produtos":[{"id":123,"motivo":"por que este item ajuda"}]}
                """.formatted(lojaId, texto.replace("%", "%%"), LIMITE_RECOMENDACOES,
                catalogoTxt.toString().replace("%", "%%"));
    }

    private ProdutoRecomendado toDto(Produto produto, String motivo) {
        ProdutoRecomendado dto = new ProdutoRecomendado();
        dto.setId(produto.getId());
        dto.setLojaId(produto.getLojaId());
        dto.setNome(produto.getNome());
        dto.setMarca(produto.getMarca());
        dto.setVendedor(produto.getVendedor());
        dto.setCategoriaNome(produto.getCategoriaNome());
        dto.setPreco(produto.getPreco());
        dto.setQuantidadeEstoque(produto.getQuantidadeEstoque());
        dto.setFileira(produto.getFileira());
        dto.setMotivo(motivo);
        return dto;
    }

    private String n(String value) {
        return value == null || value.isBlank() ? "-" : value;
    }
}
