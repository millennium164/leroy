--
-- PostgreSQL database dump
--

\restrict kzkmCBxG0wKRlyNqZ5BGEIjIj8y1BdgdEPErzJNbjS24B2eVAeXHApjwtSUSLxe

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categorias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categorias (
    id integer NOT NULL,
    nome character varying(100) NOT NULL,
    parent_id integer,
    nivel integer NOT NULL
);


ALTER TABLE public.categorias OWNER TO postgres;

--
-- Name: lojas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lojas (
    id integer NOT NULL,
    nome character varying(100) NOT NULL,
    cidade character varying(100) NOT NULL,
    endereco character varying(255) NOT NULL,
    is_centro_distribuicao boolean DEFAULT false
);


ALTER TABLE public.lojas OWNER TO postgres;

--
-- Name: produtos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produtos (
    id integer NOT NULL,
    loja_id integer NOT NULL,
    nome character varying(200) NOT NULL,
    marca character varying(100),
    vendedor character varying(100) NOT NULL,
    categoria_id integer NOT NULL,
    preco numeric(10,2) NOT NULL,
    quantidade_estoque integer DEFAULT 0 NOT NULL,
    fileira integer,
    especificacoes jsonb
);


ALTER TABLE public.produtos OWNER TO postgres;

--
-- Data for Name: categorias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categorias (id, nome, parent_id, nivel) FROM stdin;
2001	Ferramentas	\N	1
2002	Ferramentas para Furar e Parafusar	2001	2
2003	Furadeiras	2002	3
2010	Pintura e Acess¢rios	\N	1
2011	Cores de Tinta Para Parede	2010	2
2012	Tintas Brancas	2011	3
2013	Tintas Pretas	2011	3
2020	Ilumina‡ao	\N	1
2021	Lƒmpada	2020	2
2022	Lƒmpadas	2021	3
2030	Materiais Hidr ulicos	\N	1
2031	Torneiras	2030	2
2032	Torneiras Monocomando	2031	3
2033	Torneira Monocomando para Cozinha	2032	4
2040	Materiais El‚tricos	\N	1
2041	Tomadas e Interruptores	2040	2
2042	Tomadas	2041	3
2050	Jardim e Varanda	\N	1
2051	Cultivo e Manuten‡ao de Jardim	2050	2
2052	Cultivo e Jardinagem	2051	3
2060	Acess¢rios para Torneiras e Misturadores	2030	2
2061	Fitas Veda Rosca	2060	3
2062	Sifao para Pia	2030	2
2063	Sifao para Pia de Cozinha	2062	3
2064	V lvulas para Pia	2030	2
2065	Desentupidores	2030	2
\.


--
-- Data for Name: lojas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lojas (id, nome, cidade, endereco, is_centro_distribuicao) FROM stdin;
1001	Interlagos	Sao Paulo	Avenida Interlagos, 2255	f
1002	Sao Caetano	Sao Caetano do Sul	Avenida do Estado, 1750	f
1003	Sorocaba	Sorocaba	Rodovia Raposo Tavares, Km 101	f
1004	Centro de Distribui‡ao Osasco	Osasco	Avenida dos Autonomistas, 5000	t
\.


--
-- Data for Name: produtos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produtos (id, loja_id, nome, marca, vendedor, categoria_id, preco, quantidade_estoque, fileira, especificacoes) FROM stdin;
3001	1001	Furadeira de Impacto Bosch GSB 550 RE550W 1/2" 127V (110V) com Chave de Mandril e Acess¢rios	Bosch	LEROY MERLIN	2003	319.90	14	4	{"ean": "7891009858104", "peso": "1,70 Kg", "codigo": "89396846", "modelo": "GSB 550 RE", "origem": "Leroy Merlin", "tensao": "127V (110V)", "impacto": true, "mandril": "1/2 polegada", "potencia": "550 W", "velocidade": "3100 rpm", "alimentacao": "El‚trica", "uso_indicado": "Madeira, metal, concreto e pl stico", "dados_de_estoque": "simulados", "imagem_pagina_url": "https://www.leroymerlin.com.br/furadeira-de-impacto-bosch-gsb-550-re550w-1-2-127v--110v--com-chave-de-mandril-e-acessorios_89396846", "imagem_url_status": "url_da_imagem_direta_nao_exposta_pela_ferramenta_de_navegacao", "capacidade_mandril": "13 mm", "referencia_produto": "06011B60D3-000"}
3002	1002	Furadeira de Impacto Dexter 900ID2.5BK3 900W 220V com Brocas e Bolsa	Dexter	LEROY MERLIN	2003	249.90	8	5	{"tipo": "Furadeira de Impacto", "codigo": "92330714", "origem": "Leroy Merlin", "tensao": "220V", "mandril": "1/2 polegada", "potencia": "900 W", "uso_indicado": "Madeira, metal, concreto e materiais duros", "dados_de_estoque": "simulados", "imagem_pagina_url": "https://www.leroymerlin.com.br/furadeira-de-impacto-dexter-900id2-5bk3-900w-220v-com-brocas-e-bolsa_92330714", "imagem_url_status": "url_da_imagem_direta_nao_exposta_pela_ferramenta_de_navegacao"}
3010	1003	Tinta Acr¡lica Fosca Pronta para Uso Premium Interior Branca 18 L Luxens	Luxens	LEROY MERLIN	2012	399.90	22	7	{"cor": "Branco", "ean": "3276007449754", "codigo": "91917560", "origem": "Leroy Merlin", "litragem": "18 L", "acabamento": "Fosco", "rendimento": "140 mý", "superficie": "Parede", "tipo_tinta": "Acr¡lica", "categoria_tinta": "Premium", "dados_de_estoque": "simulados", "ambiente_indicado": "Interno", "imagem_pagina_url": "https://www.leroymerlin.com.br/tinta-acrilica-fosca-pronta-para-uso-premium-interior-branca-18-l-luxens_91917560", "imagem_url_status": "url_da_imagem_direta_nao_exposta_pela_ferramenta_de_navegacao", "quantidade_demaos": 2}
3011	1001	Tinta Acr¡lica Fosca Pronta para Uso Premium Interior Preto 3,6 L Luxens	Luxens	LEROY MERLIN	2013	139.90	11	7	{"cor": "Preto", "codigo": "91917672", "origem": "Leroy Merlin", "litragem": "3,6 L", "acabamento": "Fosco", "tipo_tinta": "Acr¡lica", "categoria_tinta": "Premium", "dados_de_estoque": "simulados", "ambiente_indicado": "Interno", "imagem_pagina_url": "https://www.leroymerlin.com.br/tinta-acrilica-fosca-pronta-para-uso-premium-interior-preto-3%2C6-l-luxens_91917672", "imagem_url_status": "url_da_imagem_direta_nao_exposta_pela_ferramenta_de_navegacao"}
3020	1002	Lƒmpada LED 15W 6500K Bivolt	Taschibra	LEROY MERLIN	2022	7.89	58	10	{"ean": "7897079068337", "codigo": "92440166", "origem": "Leroy Merlin", "tensao": "Bivolt", "consumo": "15 W", "cor_luz": "Branco", "formato": "Bulbo", "soquete": "E27", "garantia": "24 meses", "dimerizavel": false, "tipo_lampada": "LED", "fluxo_luminoso": "87 lm", "dados_de_estoque": "simulados", "imagem_pagina_url": "https://www.leroymerlin.com.br/lampada-led-15w-6500k-bivolt_92440166", "imagem_url_status": "url_da_imagem_direta_nao_exposta_pela_ferramenta_de_navegacao"}
3021	1003	Lƒmpada Led Filamento G95 Taschibra E27 Fumˆ Bivolt	Taschibra	Bravalumi	2022	31.90	34	10	{"ean": "7894610541953", "altura": "9,50 cm", "codigo": "1571355096", "origem": "Leroy Merlin", "tensao": "Bivolt", "consumo": "3 W", "cor_luz": "Amarelo", "formato": "Globo", "largura": "9,50 cm", "soquete": "E27", "vida_util": "15000 horas", "dimerizavel": false, "tipo_lampada": "LED", "fluxo_luminoso": "320 lm", "temperatura_cor": "2200 K", "dados_de_estoque": "simulados", "imagem_pagina_url": "https://www.leroymerlin.com.br/lampada-led-filamento-g95-taschibra-e27-fume-bivolt_1571355096", "imagem_url_status": "url_da_imagem_direta_nao_exposta_pela_ferramenta_de_navegacao"}
3030	1001	Torneira Monocomando para Pia de Cozinha Bica Alta Cromado 2266 C76 Lorenzetti	Lorenzetti	Corrˆa Materiais El‚tricos Ltda	2033	799.90	5	12	{"cor": "Cromado", "ean": "7896451861085", "bica": "Alta", "linha": "2266 C76", "codigo": "89050906", "comodo": "Cozinhas", "origem": "Leroy Merlin", "produto": "Torneira Monocomando", "garantia": "144 meses", "material": "Metal", "tipo_jato": "Com Chuveirinho", "local_indicado": "Pia", "pressao_minima": "7 mca", "dados_de_estoque": "simulados", "imagem_pagina_url": "https://www.leroymerlin.com.br/torneira-monocomando-para-pia-de-cozinha-bica-alta-cromado-2266-c76-lorenzetti_89050906", "imagem_url_status": "url_da_imagem_direta_nao_exposta_pela_ferramenta_de_navegacao", "temperaturas_agua": "Agua Quente e Fria"}
3031	1002	Monocomando para Cozinha Mesa Bica Alta Cromado Global 7001 C 55 Meber	Meber	Madeiramadeira	2033	760.88	3	12	{"cor": "Cromado", "ean": "7894066110925", "bica": "Alta", "linha": "Global 7001 C 55", "codigo": "88492383", "comodo": "Cozinhas", "origem": "Leroy Merlin", "produto": "Torneira Monocomando", "garantia": "120 meses", "material": "Metal", "local_indicado": "Pia", "pressao_maxima": "40 mca", "pressao_minima": "5 mca", "dados_de_estoque": "simulados", "imagem_pagina_url": "https://www.leroymerlin.com.br/monocomando-para-cozinha-mesa-bica-alta-cromado-global-7001-c-55-meber_88492383", "imagem_url_status": "url_da_imagem_direta_nao_exposta_pela_ferramenta_de_navegacao", "temperaturas_agua": "Agua Quente e Fria", "acompanha_arejador": true}
3040	1003	Tomada 10a De Sobrepor E Interruptor Simples Cor Branca Blux	Blux	Sabra Ferragens	2042	20.90	27	15	{"cor": "Branco", "ean": "7890889212310", "wifi": false, "linha": "OVERLAP", "polos": "2P + Terra", "codigo": "1571681960", "origem": "Leroy Merlin", "tensao": "127V (110V)", "garantia": "3 meses", "material": "Pl stico", "tonalidade": "Preto", "dados_de_estoque": "simulados", "imagem_pagina_url": "https://www.leroymerlin.com.br/tomada-10a-de-sobrepor-e-interruptor-simples-cor-branca-blux_1571681960", "imagem_url_status": "url_da_imagem_direta_nao_exposta_pela_ferramenta_de_navegacao", "variacao_mecanismo": "M¢dulo Tomada de Energia"}
3041	1001	Tomada de Energia 10A 250V Branco Sistema X Pial Legrand	Legrand	LEROY MERLIN	2042	38.90	41	15	{"cor": "Branco", "ean": "7891284033555", "linha": "Sistema X", "codigo": "87697050", "origem": "Leroy Merlin", "tensao": "220V", "inmetro": true, "corrente": "10 A", "material": "Pl stico", "tipo_placa": "4x2", "tipo_instalacao": "Embutir", "dados_de_estoque": "simulados", "imagem_pagina_url": "https://www.leroymerlin.com.br/tomada-de-energia-10a-250v-branco-sistema-x-pial-legrand_87697050", "imagem_url_status": "url_da_imagem_direta_nao_exposta_pela_ferramenta_de_navegacao", "quantidade_tomadas": 1, "referencia_produto": "6750 60", "certificacao_inmetro": "OCP 0004"}
3050	1002	Tesoura para Poda 6,5" Famastil	Famastil	LEROY MERLIN	2052	29.90	19	18	{"ean": "7896367744229", "tipo": "6,5 polegadas", "codigo": "91832622", "origem": "Leroy Merlin", "produto": "Tesoura", "tipo_ferramenta": "Cortar e Podar", "dados_de_estoque": "simulados", "recomendado_para": "Cerca Viva, Galhos e Grama", "imagem_pagina_url": "https://www.leroymerlin.com.br/tesoura-para-poda-6%2C5-famastil_91832622", "imagem_url_status": "url_da_imagem_direta_nao_exposta_pela_ferramenta_de_navegacao"}
3051	1003	Tesoura Para Poda Ts-3143 - Trapp	Trapp	Volaron Shop	2052	72.31	7	18	{"ean": "7896260216342", "peso": "0,20 g", "altura": "28 cm", "codigo": "1571900469", "modelo": "TS-3143", "origem": "Leroy Merlin", "largura": "6 cm", "comprimento": "30 cm", "capacidade_corte": "2 cm", "dados_de_estoque": "simulados", "imagem_pagina_url": "https://www.leroymerlin.com.br/tesoura-para-poda-ts-3143-trapp_1571900469", "imagem_url_status": "url_da_imagem_direta_nao_exposta_pela_ferramenta_de_navegacao"}
3060	1001	Furadeira e Parafusadeira de Impacto Makita a Bateria Brushless com Maleta e Carregador 18V 13mm DHP485RF1J	Makita	LEROY MERLIN	2003	999.90	0	4	{"ean": "197050008640", "peso": "1,80 Kg", "codigo": "92395345", "modelo": "DHP485RF1J", "origem": "Leroy Merlin", "tensao": "Bivolt", "garantia": "12 meses", "tipo_motor": "Brushless", "alimentacao": "Bateria", "torque_maximo": "60,00 Nm", "possui_impacto": true, "rotacao_maxima": "1900 rpm", "acompanha_maleta": true, "dados_de_estoque": "simulados", "potencia_bateria": "18 V", "acompanha_bateria": true, "amperagem_bateria": "3,00 Ah", "imagem_pagina_url": "https://www.leroymerlin.com.br/furadeira-e-parafusadeira-de-impacto-makita-a-bateria-brushless-com-maleta-e-carregador-18v-13mm-dhp485rf1j_92395345", "capacidade_mandril": "13,00 mm", "controle_de_torque": true, "observacao_estoque": "estoque simulado como 0 para exerc¡cio", "posicoes_de_torque": 21, "acompanha_carregador": true}
3061	1001	Furadeira e Parafusadeira de Impacto Dewalt DCD996B a Bateria 20V Brushless 1/2"	Dewalt	LEROY MERLIN	2003	1399.00	0	5	{"codigo": "91974750", "modelo": "DCD996B", "origem": "Leroy Merlin", "tensao": "20 V", "bateria": "Nao acompanha bateria e carregador", "mandril": "1/2 polegada", "reversivel": true, "tipo_motor": "Brushless", "alimentacao": "Bateria", "possui_impacto": true, "dados_de_estoque": "simulados", "imagem_pagina_url": "https://www.leroymerlin.com.br/furadeira-e-parafusadeira-de-impacto-dewalt-dcd996b-a-bateria-20v-brushless-1-2_91974750", "observacao_estoque": "estoque simulado como 0 para exerc¡cio", "controle_de_velocidade": true}
3062	1001	Torneira de Banheiro Monocomando Redonda RT 50	Reno	Banho & Casa	2032	320.90	6	12	{"cor": "Prata", "ean": "7905376575936", "bica": "Baixa", "linha": "Banheiro Premium", "altura": "15,00 cm", "codigo": "1572237197", "comodo": "Banheiros", "origem": "Leroy Merlin", "largura": "3,00 cm", "produto": "Torneira", "garantia": "3 meses", "material": "A‡o", "tipo_jato": "Jato Comum", "comprimento": "15,00 cm", "filtro_agua": false, "tipo_material": "A‡o Inox 304", "local_indicado": "Banheiro", "dados_de_estoque": "simulados", "tipo_acionamento": "1/2 Volta", "imagem_pagina_url": "https://www.leroymerlin.com.br/torneira-de-banheiro-monocomando-redonda-rt-50_1572237197", "temperaturas_agua": "Agua Quente e Fria"}
3063	1001	Tesoura Para Poda Reta 8" Vonder	Vonder	LEROY MERLIN	2052	49.19	13	18	{"ean": "7893946661915", "cabo": "Plastificado", "mola": true, "peso": "0,30 g", "altura": "2,00 cm", "codigo": "1571426165", "origem": "Leroy Merlin", "largura": "9,00 cm", "tamanho": "8 polegadas / 203 mm", "garantia": "3 meses", "comprimento": "26,00 cm", "material_lamina": "A‡o carbono", "tipo_ferramenta": "Cortar e Podar", "trava_seguranca": true, "dados_de_estoque": "simulados", "imagem_pagina_url": "https://www.leroymerlin.com.br/tesoura-para-poda-reta-8-vonder_1571426165"}
3064	1001	Furadeira El‚trica Dexter 500W 127V (110V)	Dexter	LEROY MERLIN	2003	229.90	9	4	{"ean": "3276052197198", "tipo": "Furadeira El‚trica", "codigo": "92190735", "origem": "Leroy Merlin", "tensao": "127V (110V)", "potencia": "500 W", "alimentacao": "El‚trica", "dados_de_estoque": "simulados", "imagem_pagina_url": "https://www.leroymerlin.com.br/furadeira-eletrica-dexter-500w-127v--110v-_92190735"}
3070	1001	Furadeira de Impacto Bosch GSB 550 RE 550W 220V	Bosch	LEROY MERLIN	2003	299.90	12	4	{"ean": "7891009828664", "peso": "2,16 Kg", "codigo": "1566768432", "modelo": "GSB 550 RE", "origem": "Leroy Merlin", "tensao": "220V", "mandril": "1/2 polegada", "produto": "Furadeira de Impacto", "garantia": "12 meses", "potencia": "550 W", "velocidade": "2700 rpm", "alimentacao": "El‚trica", "possui_impacto": true, "dados_de_estoque": "simulados", "imagem_pagina_url": "https://www.leroymerlin.com.br/furadeira-de-impacto-gsb-550-re-550w-bosch_1566768432", "capacidade_mandril": "13 mm"}
3071	1001	Lƒmpada LED Taschibra 2700K PAR 20 7W	Taschibra	LEROY MERLIN	2022	12.90	46	10	{"ean": "7897079089622", "tipo": "Lƒmpada LED", "marca": "Taschibra", "codigo": "1568337999", "origem": "Leroy Merlin", "tensao": "Autovolt", "formato": "PAR 20", "garantia": "3 anos", "potencia": "7 W", "temperatura_cor": "2700 K", "dados_de_estoque": "simulados", "imagem_pagina_url": "https://www.leroymerlin.com.br/lampada-led-taschibra-2700k-par-20-7w_1568337999"}
3072	1001	Lƒmpada LED Taschibra 6500K PAR 20 7W	Taschibra	LEROY MERLIN	2022	12.90	0	10	{"ean": "7897079089646", "tipo": "Lƒmpada LED", "marca": "Taschibra", "codigo": "1568551472", "origem": "Leroy Merlin", "tensao": "Autovolt", "formato": "PAR 20", "garantia": "3 anos", "potencia": "7 W", "temperatura_cor": "6500 K", "dados_de_estoque": "simulados", "imagem_pagina_url": "https://www.leroymerlin.com.br/lampada-led-taschibra-6500k-par-20-7w_1568551472"}
3073	1002	Furadeira de Impacto Bosch GSB 550 RE 550W 127V	Bosch	LEROY MERLIN	2003	299.90	7	4	{"ean": "7891009866031", "codigo": "1566986937", "modelo": "GSB 550 RE", "origem": "Leroy Merlin", "tensao": "127V (110V)", "produto": "Furadeira de Impacto", "potencia": "550 W", "alimentacao": "El‚trica", "possui_impacto": true, "dados_de_estoque": "simulados", "imagem_pagina_url": "https://www.leroymerlin.com.br/furadeira-de-impacto-gsb-550-re-550w-127v_1566986937"}
3074	1004	Furadeira Impacto 550W 2700rpm GSB 550 RE Bosch	Bosch	LEROY MERLIN	2003	299.90	120	22	{"ean": "7891009828657", "peso": "1,8 Kg", "codigo": "1566768426", "modelo": "GSB 550 RE", "origem": "Leroy Merlin", "tensao": "220V", "mandril": "1/2 polegada", "produto": "Furadeira de Impacto", "garantia": "12 meses", "potencia": "550 W", "observacao": "Estoque elevado para representar estoque de centro de distribui‡ao", "velocidade": "2700 rpm", "alimentacao": "El‚trica", "possui_impacto": true, "dados_de_estoque": "simulados", "imagem_pagina_url": "https://www.leroymerlin.com.br/furadeira-impacto-550w-2700rpm-gsb-550-re-bosch_1566768426", "capacidade_mandril": "13 mm"}
3075	1004	Lƒmpada LED Taschibra 6500K PAR 20 7W	Taschibra	LEROY MERLIN	2022	12.90	350	31	{"ean": "7897079089646", "tipo": "Lƒmpada LED", "marca": "Taschibra", "codigo": "1568551472", "origem": "Leroy Merlin", "tensao": "Autovolt", "formato": "PAR 20", "garantia": "3 anos", "potencia": "7 W", "observacao": "Estoque elevado para representar estoque de centro de distribui‡ao", "temperatura_cor": "6500 K", "dados_de_estoque": "simulados", "imagem_pagina_url": "https://www.leroymerlin.com.br/lampada-led-taschibra-6500k-par-20-7w_1568551472"}
3080	1001	Desentupidor Manual Bomba 150mm Dexter	Dexter	LEROY MERLIN	2065	79.90	8	20	{"tipo": "Desentupidor Manual", "marca": "Dexter", "codigo": "91801710", "modelo": "Bomba 150mm", "origem": "Leroy Merlin", "aplicacao": ["Pia", "Ralo", "Vaso sanit rio"], "dados_de_estoque": "simulados", "preco_consultado": "R$ 79,90", "ambiente_indicado": ["Cozinha", "Banheiro"], "imagem_pagina_url": "https://www.leroymerlin.com.br/desentupidor-manual-bomba-150mm-dexter_91801710", "papel_no_problema": "Primeira op‡ao para tentativa de desobstru‡ao mecƒnica"}
3081	1001	Desentupidor Manual Com Mola Nove54	Nove54	LEROY MERLIN	2065	99.00	5	20	{"tipo": "Desentupidor Manual com Mola", "marca": "Nove54", "codigo": "1553637426", "origem": "Leroy Merlin", "aplicacao": ["Pia", "Ralo", "Tubula‡ao"], "dados_de_estoque": "simulados", "preco_consultado": "R$ 99,00", "imagem_pagina_url": "https://www.leroymerlin.com.br/desentupidor-manual-com-mola-nove54_1553637426", "papel_no_problema": "Alternativa mecƒnica para obstru‡oes mais profundas"}
3082	1001	Sifao para Pia Universal Extens¡vel 1", 1.1/2" e 1.1/4" Tigre	Tigre	LEROY MERLIN	2063	46.70	6	21	{"cor": "Branco", "ean": "7898482242246", "tipo": "Sifao para Pia", "saida": ["1 polegada", "1.1/2 polegada", "1.1/4 polegada"], "codigo": "88008872", "origem": "Leroy Merlin", "entrada": ["1 polegada", "1.1/2 polegada", "1.1/4 polegada"], "material": "Pl stico", "tipo_corpo": "Extens¡vel", "local_indicado": "Pia", "dados_de_estoque": "simulados", "preco_consultado": "R$ 46,70", "imagem_pagina_url": "https://www.leroymerlin.com.br/sifao-para-pia-universal-extensivel-1-1-1-2-e-1-1-4-tigre_88008872", "papel_no_problema": "Substitui‡ao do sifao caso a obstru‡ao esteja no sifao ou seja necess ria manuten‡ao", "comprimento_maximo": "70 cm", "comprimento_minimo": "32,5 cm"}
3083	1001	Sifao Sanfonado Copo Universal Black Extens¡vel At‚ 50cm	Roddex	Toc Casa	2063	73.90	4	21	{"cor": "Preto", "ean": "7908544305502", "tipo": "Sifao", "codigo": "1572330249", "origem": "Leroy Merlin", "ligacao": ["DN38", "DN40", "DN48", "DN50"], "material": ["Polipropileno", "PVC", "Elast“meros"], "acompanha": ["Bucha redutora", "An‚is de veda‡ao"], "tipo_corpo": "Extens¡vel", "local_indicado": "Cozinha", "dados_de_estoque": "simulados", "preco_consultado": "R$ 73,90", "imagem_pagina_url": "https://www.leroymerlin.com.br/sifao-sanfonado-copo-universal-black-extensivel-ate-50cm_1572330249", "papel_no_problema": "Alternativa para substitui‡ao do sifao da pia", "comprimento_maximo": "50 cm"}
3084	1001	Fita Veda Rosca 18mmx10m Tigre	Tigre	LEROY MERLIN	2061	12.90	31	21	{"cor": "Branco", "ean": "7897613336946", "codigo": "85302812", "origem": "Leroy Merlin", "largura": "18 mm", "produto": "Fita Veda Rosca", "material": "Teflon", "aplicacao": ["Roscas de PVC", "Roscas met licas", "Conexoes hidr ulicas"], "comprimento": "10 m", "uso_indicado": ["Agua fria", "Agua quente"], "dados_de_estoque": "simulados", "preco_consultado": "R$ 12,90", "imagem_pagina_url": "https://www.leroymerlin.com.br/fita-veda-rosca-18mmx10m-tigre_85302812", "papel_no_problema": "Material de apoio para veda‡ao durante reinstala‡ao do sifao/conexoes"}
3085	1001	V lvula Para Pia Americana 3,1/2 Cromado Esteves	Esteves	Liven Casa	2064	55.57	4	22	{"cor": "Cromado", "ean": "7891589114324", "codigo": "1572255319", "origem": "Leroy Merlin", "produto": "V lvula de Escoamento", "tamanho": "3,1/2 polegadas", "material": "Metal", "aplicacao": ["Pia de cozinha", "Banheiro"], "acabamento": "Cromado", "dados_de_estoque": "simulados", "preco_consultado": "R$ 55,57", "imagem_pagina_url": "https://www.leroymerlin.com.br/valvula-para-pia-americana-3%2C1-2-cromado-esteves_1572255319", "papel_no_problema": "Pe‡a de substitui‡ao caso o problema esteja na v lvula/ralo da pia"}
3086	1001	Desentupidor de Pia Ralo Vaso Sanit rio Pistola de Alta Pressao	Dona D.cor	Dona D.cor	2065	92.90	3	20	{"ean": "7908627900501", "tipo": "Pistola de Alta Pressao", "bocais": 4, "codigo": "1572656267", "origem": "Leroy Merlin", "produto": "Desentupidor", "garantia": "6 meses", "material": "Pl stico ABS", "aplicacoes": ["Pias", "Ralos", "Tanques", "Tubula‡oes"], "dados_de_estoque": "simulados", "preco_consultado": "R$ 92,90", "imagem_pagina_url": "https://www.leroymerlin.com.br/desentupidor-de-pia-ralo-vaso-sanitario-pistola-de-alta-pressao-para-cano-tanque-privada-banheiro_1572656267", "papel_no_problema": "Op‡ao de desobstru‡ao mecƒnica por pressao"}
\.


--
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id);


--
-- Name: lojas lojas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lojas
    ADD CONSTRAINT lojas_pkey PRIMARY KEY (id);


--
-- Name: produtos produtos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_pkey PRIMARY KEY (id, loja_id);


--
-- Name: categorias categorias_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.categorias(id) ON DELETE RESTRICT;


--
-- Name: produtos produtos_categoria_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_categoria_id_fkey FOREIGN KEY (categoria_id) REFERENCES public.categorias(id);


--
-- Name: produtos produtos_loja_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_loja_id_fkey FOREIGN KEY (loja_id) REFERENCES public.lojas(id);


--
-- PostgreSQL database dump complete
--

\unrestrict kzkmCBxG0wKRlyNqZ5BGEIjIj8y1BdgdEPErzJNbjS24B2eVAeXHApjwtSUSLxe

