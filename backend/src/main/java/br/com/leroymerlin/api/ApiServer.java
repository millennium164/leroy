package br.com.leroymerlin.api;

import br.com.leroymerlin.api.dto.RecomendacaoRequest;
import br.com.leroymerlin.dao.LojaDao;
import br.com.leroymerlin.dao.ProdutoDao;
import br.com.leroymerlin.service.EnvLoader;
import br.com.leroymerlin.service.RecomendacaoService;
import io.javalin.Javalin;
import io.javalin.http.HttpStatus;

import java.util.List;
import java.util.Map;

public class ApiServer {

    public static void main(String[] args) {
        RecomendacaoService recomendacaoService = new RecomendacaoService();

        Javalin app = Javalin.create(config -> {
            config.bundledPlugins.enableCors(cors -> cors.addRule(rule -> rule.anyHost()));
            config.http.defaultContentType = "application/json; charset=utf-8";
        });

        app.get("/api/lojas", ctx -> {
            LojaDao dao = new LojaDao();
            try {
                ctx.json(dao.listar());
            } finally {
                dao.fecharConexao();
            }
        });

        app.get("/api/produtos/sugerir", ctx -> {
            Integer lojaId = ctx.queryParamAsClass("lojaId", Integer.class).getOrDefault(1001);
            String q = ctx.queryParam("q") == null ? "" : ctx.queryParam("q");
            if (q.isBlank() || q.trim().length() < 2) {
                ctx.json(List.of());
                return;
            }
            ProdutoDao dao = new ProdutoDao();
            try {
                ctx.json(dao.buscarPorTexto(lojaId, q, 8));
            } finally {
                dao.fecharConexao();
            }
        });

        app.post("/api/produtos/recomendar", ctx -> {
            RecomendacaoRequest request = ctx.bodyAsClass(RecomendacaoRequest.class);
            int lojaId = request.getLojaId() == 0 ? 1001 : request.getLojaId();
            ctx.json(recomendacaoService.recomendar(lojaId, request.getTexto()));
        });

        app.exception(IllegalStateException.class, (e, ctx) -> {
            ctx.status(HttpStatus.SERVICE_UNAVAILABLE);
            ctx.json(Map.of("erro", e.getMessage()));
        });

        app.exception(Exception.class, (e, ctx) -> {
            ctx.status(HttpStatus.INTERNAL_SERVER_ERROR);
            ctx.json(Map.of("erro", e.getMessage() == null ? "Erro interno" : e.getMessage()));
        });

        int port = parsePort(EnvLoader.get("PORT"), parsePort(EnvLoader.get("API_PORT"), 8080));
        app.start("0.0.0.0", port);
        System.out.println("API Leroy Merlin em http://127.0.0.1:" + port);
    }

    private static int parsePort(String value, int fallback) {
        if (value == null || value.isBlank()) {
            return fallback;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return fallback;
        }
    }
}
