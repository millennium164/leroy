-- ============================================================
-- LEROY MERLIN - DATASET COMPLETO DO MVP
-- Reconstituído a partir dos registros criados nesta conversa.
--
-- ATENÇÃO:
-- * Use em um banco PostgreSQL vazio ou já contendo o mesmo schema.
-- * CREATE TABLE IF NOT EXISTS não apaga tabelas existentes.
-- * ON CONFLICT DO NOTHING evita duplicar IDs já inseridos.
-- * Estoques, fileiras e o CD de Osasco são dados simulados.
-- * imagem_pagina_url aponta para a página do produto, não necessariamente
--   para o arquivo de imagem direto.
-- * Os preços/atributos são um snapshot ilustrativo e podem estar desatualizados.
-- * A chave de produtos é composta: (id, loja_id).
-- ============================================================

BEGIN;
SET client_encoding = 'UTF8';

-- 1. TABELAS
CREATE TABLE IF NOT EXISTS public.lojas (
    id INTEGER NOT NULL,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    is_centro_distribuicao BOOLEAN DEFAULT FALSE,
    CONSTRAINT lojas_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.categorias (
    id INTEGER NOT NULL,
    nome VARCHAR(100) NOT NULL,
    parent_id INTEGER,
    nivel INTEGER NOT NULL,
    CONSTRAINT categorias_pkey PRIMARY KEY (id),
    CONSTRAINT categorias_parent_id_fkey FOREIGN KEY (parent_id)
        REFERENCES public.categorias(id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS public.produtos (
    id INTEGER NOT NULL,
    loja_id INTEGER NOT NULL,
    nome VARCHAR(200) NOT NULL,
    marca VARCHAR(100),
    vendedor VARCHAR(100) NOT NULL,
    categoria_id INTEGER NOT NULL,
    preco NUMERIC(10,2) NOT NULL,
    quantidade_estoque INTEGER NOT NULL DEFAULT 0,
    fileira INTEGER,
    especificacoes JSONB,
    CONSTRAINT produtos_pkey PRIMARY KEY (id, loja_id),
    CONSTRAINT produtos_categoria_id_fkey FOREIGN KEY (categoria_id)
        REFERENCES public.categorias(id),
    CONSTRAINT produtos_loja_id_fkey FOREIGN KEY (loja_id)
        REFERENCES public.lojas(id)
);

-- 2. LOJAS
INSERT INTO public.lojas (id,nome,cidade,endereco,is_centro_distribuicao) VALUES
    (1001, 'Interlagos', 'São Paulo', 'Avenida Interlagos, 2255', FALSE),
    (1002, 'São Caetano', 'São Caetano do Sul', 'Avenida do Estado, 1750', FALSE),
    (1003, 'Sorocaba', 'Sorocaba', 'Rodovia Raposo Tavares, Km 101', FALSE),
    (1004, 'Centro de Distribuição Osasco (simulado)', 'Osasco', 'Endereço fictício para simulação do MVP', TRUE)
ON CONFLICT (id) DO NOTHING;

-- 3. CATEGORIAS (inseridas com os pais antes dos filhos)
-- nível 1
INSERT INTO public.categorias (id,nome,parent_id,nivel) VALUES
    (2001, 'Ferramentas', NULL, 1),
    (2010, 'Pintura e Acessórios', NULL, 1),
    (2020, 'Iluminação', NULL, 1),
    (2030, 'Materiais Hidráulicos', NULL, 1),
    (2040, 'Materiais Elétricos', NULL, 1),
    (2050, 'Jardim e Varanda', NULL, 1),
    (2073, 'Organização da Casa', NULL, 1),
    (2075, 'Utilidades Domésticas', NULL, 1)
ON CONFLICT (id) DO NOTHING;

-- nível 2
INSERT INTO public.categorias (id,nome,parent_id,nivel) VALUES
    (2002, 'Ferramentas para Furar e Parafusar', 2001, 2),
    (2011, 'Cores de Tinta Para Parede', 2010, 2),
    (2021, 'Lâmpada', 2020, 2),
    (2031, 'Torneiras', 2030, 2),
    (2041, 'Tomadas e Interruptores', 2040, 2),
    (2051, 'Cultivo e Manutenção de Jardim', 2050, 2),
    (2060, 'Acessórios para Torneiras e Misturadores', 2030, 2),
    (2062, 'Sifão para Pia', 2030, 2),
    (2064, 'Válvulas para Pia', 2030, 2),
    (2065, 'Desentupidores', 2030, 2),
    (2066, 'Fundos, Massas de Parede e Seladoras', 2010, 2),
    (2068, 'Pincéis, Rolos e Acessórios', 2010, 2),
    (2071, 'Acessórios e Consumíveis para Ferramentas', 2001, 2),
    (2074, 'Prateleiras', 2073, 2),
    (2076, 'Frigideiras', 2075, 2),
    (2077, 'Talheres', 2075, 2)
ON CONFLICT (id) DO NOTHING;

-- nível 3
INSERT INTO public.categorias (id,nome,parent_id,nivel) VALUES
    (2003, 'Furadeiras', 2002, 3),
    (2012, 'Tintas Brancas', 2011, 3),
    (2013, 'Tintas Pretas', 2011, 3),
    (2022, 'Lâmpadas', 2021, 3),
    (2032, 'Torneiras Monocomando', 2031, 3),
    (2042, 'Tomadas', 2041, 3),
    (2052, 'Cultivo e Jardinagem', 2051, 3),
    (2061, 'Fitas Veda Rosca', 2060, 3),
    (2063, 'Sifão para Pia de Cozinha', 2062, 3),
    (2067, 'Massa Corrida', 2066, 3),
    (2069, 'Acessórios de Pintura', 2068, 3),
    (2072, 'Lixas', 2071, 3),
    (2078, 'Colheres', 2077, 3),
    (2079, 'Facas', 2077, 3)
ON CONFLICT (id) DO NOTHING;

-- nível 4
INSERT INTO public.categorias (id,nome,parent_id,nivel) VALUES
    (2033, 'Torneira Monocomando para Cozinha', 2032, 4),
    (2070, 'Rolos de Pintura', 2069, 4)
ON CONFLICT (id) DO NOTHING;

-- 4. PRODUTOS
-- O mesmo ID em lojas diferentes representa o mesmo SKU em unidades diferentes.
INSERT INTO public.produtos
(id, loja_id, nome, marca, vendedor, categoria_id, preco, quantidade_estoque, fileira, especificacoes)
VALUES
    (3001, 1001, 'Furadeira de Impacto Bosch GSB 550 RE550W 1/2" 127V (110V) com Chave de Mandril e Acessórios', 'Bosch', 'LEROY MERLIN', 2003, '319.90', 14, 4, '{"codigo":"89396846","ean":"7891009858104","modelo":"GSB 550 RE","potencia":"550 W","tensao":"127V (110V)","alimentacao":"Elétrica","impacto":true,"mandril":"1/2 polegada","capacidade_mandril":"13 mm","velocidade":"3100 rpm","peso":"1,70 Kg","uso_indicado":"Madeira, metal, concreto e plástico","referencia_produto":"06011B60D3-000","imagem_pagina_url":"https://www.leroymerlin.com.br/furadeira-de-impacto-bosch-gsb-550-re550w-1-2-127v--110v--com-chave-de-mandril-e-acessorios_89396846","imagem_url_status":"URL de página do produto; não é arquivo direto de imagem","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3002, 1002, 'Furadeira de Impacto Dexter 900ID2.5BK3 900W 220V com Brocas e Bolsa', 'Dexter', 'LEROY MERLIN', 2003, '249.90', 8, 5, '{"codigo":"92330714","potencia":"900 W","tensao":"220V","mandril":"1/2 polegada","tipo":"Furadeira de Impacto","uso_indicado":"Madeira, metal, concreto e materiais duros","imagem_pagina_url":"https://www.leroymerlin.com.br/furadeira-de-impacto-dexter-900id2-5bk3-900w-220v-com-brocas-e-bolsa_92330714","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3010, 1003, 'Tinta Acrílica Fosca Pronta para Uso Premium Interior Branca 18 L Luxens', 'Luxens', 'LEROY MERLIN', 2012, '399.90', 22, 7, '{"codigo":"91917560","ean":"3276007449754","tipo_tinta":"Acrílica","ambiente_indicado":"Interno","cor":"Branco","litragem":"18 L","superficie":"Parede","categoria_tinta":"Premium","acabamento":"Fosco","rendimento":"140 m²","quantidade_demaos":2,"imagem_pagina_url":"https://www.leroymerlin.com.br/tinta-acrilica-fosca-pronta-para-uso-premium-interior-branca-18-l-luxens_91917560","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3011, 1001, 'Tinta Acrílica Fosca Pronta para Uso Premium Interior Preto 3,6 L Luxens', 'Luxens', 'LEROY MERLIN', 2013, '139.90', 11, 7, '{"codigo":"91917672","tipo_tinta":"Acrílica","ambiente_indicado":"Interno","cor":"Preto","litragem":"3,6 L","categoria_tinta":"Premium","acabamento":"Fosco","imagem_pagina_url":"https://www.leroymerlin.com.br/tinta-acrilica-fosca-pronta-para-uso-premium-interior-preto-3%2C6-l-luxens_91917672","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3020, 1002, 'Lâmpada LED 15W 6500K Bivolt', 'Taschibra', 'LEROY MERLIN', 2022, '7.89', 58, 10, '{"codigo":"92440166","ean":"7897079068337","tipo_lampada":"LED","cor_luz":"Branco","consumo":"15 W","formato":"Bulbo","soquete":"E27","tensao":"Bivolt","dimerizavel":false,"fluxo_luminoso":"87 lm","garantia":"24 meses","imagem_pagina_url":"https://www.leroymerlin.com.br/lampada-led-15w-6500k-bivolt_92440166","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3021, 1003, 'Lâmpada Led Filamento G95 Taschibra E27 Fumê Bivolt', 'Taschibra', 'Bravalumi', 2022, '31.90', 34, 10, '{"codigo":"1571355096","ean":"7894610541953","tipo_lampada":"LED","cor_luz":"Amarelo","consumo":"3 W","formato":"Globo","soquete":"E27","tensao":"Bivolt","altura":"9,50 cm","largura":"9,50 cm","fluxo_luminoso":"320 lm","temperatura_cor":"2200 K","dimerizavel":false,"vida_util":"15000 horas","imagem_pagina_url":"https://www.leroymerlin.com.br/lampada-led-filamento-g95-taschibra-e27-fume-bivolt_1571355096","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3030, 1001, 'Torneira Monocomando para Pia de Cozinha Bica Alta Cromado 2266 C76 Lorenzetti', 'Lorenzetti', 'Corrêa Materiais Elétricos Ltda', 2033, '799.90', 5, 12, '{"codigo":"89050906","ean":"7896451861085","produto":"Torneira Monocomando","local_indicado":"Pia","comodo":"Cozinhas","temperaturas_agua":"Água Quente e Fria","bica":"Alta","tipo_jato":"Com Chuveirinho","pressao_minima":"7 mca","cor":"Cromado","material":"Metal","linha":"2266 C76","garantia":"144 meses","imagem_pagina_url":"https://www.leroymerlin.com.br/torneira-monocomando-para-pia-de-cozinha-bica-alta-cromado-2266-c76-lorenzetti_89050906","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3031, 1002, 'Monocomando para Cozinha Mesa Bica Alta Cromado Global 7001 C 55 Meber', 'Meber', 'Madeiramadeira', 2033, '760.88', 3, 12, '{"codigo":"88492383","ean":"7894066110925","produto":"Torneira Monocomando","local_indicado":"Pia","comodo":"Cozinhas","temperaturas_agua":"Água Quente e Fria","bica":"Alta","acompanha_arejador":true,"pressao_minima":"5 mca","pressao_maxima":"40 mca","cor":"Cromado","material":"Metal","linha":"Global 7001 C 55","garantia":"120 meses","imagem_pagina_url":"https://www.leroymerlin.com.br/monocomando-para-cozinha-mesa-bica-alta-cromado-global-7001-c-55-meber_88492383","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3040, 1003, 'Tomada 10a De Sobrepor E Interruptor Simples Cor Branca Blux', 'Blux', 'Sabra Ferragens', 2042, '20.90', 27, 15, '{"codigo":"1571681960","ean":"7890889212310","linha":"OVERLAP","variacao_mecanismo":"Módulo Tomada de Energia","polos":"2P + Terra","wifi":false,"cor":"Branco","tonalidade":"Preto","material":"Plástico","tensao":"127V (110V)","garantia":"3 meses","imagem_pagina_url":"https://www.leroymerlin.com.br/tomada-10a-de-sobrepor-e-interruptor-simples-cor-branca-blux_1571681960","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3041, 1001, 'Tomada de Energia 10A 250V Branco Sistema X Pial Legrand', 'Legrand', 'LEROY MERLIN', 2042, '38.90', 41, 15, '{"codigo":"87697050","ean":"7891284033555","linha":"Sistema X","quantidade_tomadas":1,"corrente":"10 A","tipo_placa":"4x2","cor":"Branco","material":"Plástico","tipo_instalacao":"Embutir","tensao":"220V","inmetro":true,"certificacao_inmetro":"OCP 0004","referencia_produto":"6750 60","imagem_pagina_url":"https://www.leroymerlin.com.br/tomada-de-energia-10a-250v-branco-sistema-x-pial-legrand_87697050","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3050, 1002, 'Tesoura para Poda 6,5" Famastil', 'Famastil', 'LEROY MERLIN', 2052, '29.90', 19, 18, '{"codigo":"91832622","ean":"7896367744229","produto":"Tesoura","tipo_ferramenta":"Cortar e Podar","recomendado_para":"Cerca Viva, Galhos e Grama","tipo":"6,5 polegadas","imagem_pagina_url":"https://www.leroymerlin.com.br/tesoura-para-poda-6%2C5-famastil_91832622","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3051, 1003, 'Tesoura Para Poda Ts-3143 - Trapp', 'Trapp', 'LEROY MERLIN', 2052, '72.31', 7, 18, '{"codigo":"1571900469","ean":"7896260216342","modelo":"TS-3143","capacidade_corte":"2 cm","altura":"28 cm","largura":"6 cm","comprimento":"30 cm","peso":"0,20 g","imagem_pagina_url":"https://www.leroymerlin.com.br/tesoura-para-poda-ts-3143-trapp_1571900469","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3060, 1001, 'Furadeira e Parafusadeira de Impacto Makita a Bateria Brushless com Maleta e Carregador 18V 13mm DHP485RF1J', 'Makita', 'LEROY MERLIN', 2003, '999.90', 0, 4, '{"codigo":"92395345","ean":"197050008640","modelo":"DHP485RF1J","potencia_bateria":"18 V","tensao":"Bivolt","alimentacao":"Bateria","possui_impacto":true,"capacidade_mandril":"13,00 mm","acompanha_bateria":true,"amperagem_bateria":"3,00 Ah","acompanha_carregador":true,"tipo_motor":"Brushless","controle_de_torque":true,"torque_maximo":"60,00 Nm","posicoes_de_torque":21,"rotacao_maxima":"1900 rpm","acompanha_maleta":true,"peso":"1,80 Kg","garantia":"12 meses","imagem_pagina_url":"https://www.leroymerlin.com.br/furadeira-e-parafusadeira-de-impacto-makita-a-bateria-brushless-com-maleta-e-carregador-18v-13mm-dhp485rf1j_92395345","origem":"Leroy Merlin","dados_de_estoque":"simulados","observacao_estoque":"estoque simulado como 0 para exercício"}'::jsonb),
    (3061, 1001, 'Furadeira e Parafusadeira de Impacto Dewalt DCD996B a Bateria 20V Brushless 1/2"', 'Dewalt', 'LEROY MERLIN', 2003, '1399.00', 0, 5, '{"codigo":"91974750","modelo":"DCD996B","alimentacao":"Bateria","tensao":"20 V","tipo_motor":"Brushless","possui_impacto":true,"mandril":"1/2 polegada","controle_de_velocidade":true,"reversivel":true,"bateria":"Não acompanha bateria e carregador","imagem_pagina_url":"https://www.leroymerlin.com.br/furadeira-e-parafusadeira-de-impacto-dewalt-dcd996b-a-bateria-20v-brushless-1-2_91974750","origem":"Leroy Merlin","dados_de_estoque":"simulados","observacao_estoque":"estoque simulado como 0 para exercício"}'::jsonb),
    (3062, 1001, 'Torneira de Banheiro Monocomando Redonda RT 50', 'Reno', 'Banho & Casa', 2032, '320.90', 6, 12, '{"codigo":"1572237197","ean":"7905376575936","produto":"Torneira","local_indicado":"Banheiro","comodo":"Banheiros","temperaturas_agua":"Água Quente e Fria","bica":"Baixa","tipo_jato":"Jato Comum","tipo_acionamento":"1/2 Volta","filtro_agua":false,"altura":"15,00 cm","largura":"3,00 cm","comprimento":"15,00 cm","cor":"Prata","material":"Aço","tipo_material":"Aço Inox 304","linha":"Banheiro Premium","garantia":"3 meses","imagem_pagina_url":"https://www.leroymerlin.com.br/torneira-de-banheiro-monocomando-redonda-rt-50_1572237197","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3063, 1001, 'Tesoura Para Poda Reta 8" Vonder', 'Vonder', 'LEROY MERLIN', 2052, '49.19', 13, 18, '{"codigo":"1571426165","ean":"7893946661915","tipo_ferramenta":"Cortar e Podar","tamanho":"8 polegadas / 203 mm","material_lamina":"Aço carbono","cabo":"Plastificado","trava_seguranca":true,"mola":true,"altura":"2,00 cm","largura":"9,00 cm","comprimento":"26,00 cm","peso":"0,30 g","garantia":"3 meses","imagem_pagina_url":"https://www.leroymerlin.com.br/tesoura-para-poda-reta-8-vonder_1571426165","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3064, 1001, 'Furadeira Elétrica Dexter 500W 127V (110V)', 'Dexter', 'LEROY MERLIN', 2003, '229.90', 9, 4, '{"codigo":"92190735","ean":"3276052197198","potencia":"500 W","tensao":"127V (110V)","tipo":"Furadeira Elétrica","alimentacao":"Elétrica","imagem_pagina_url":"https://www.leroymerlin.com.br/furadeira-eletrica-dexter-500w-127v--110v-_92190735","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3070, 1001, 'Furadeira de Impacto Bosch GSB 550 RE 550W 220V', 'Bosch', 'LEROY MERLIN', 2003, '299.90', 12, 4, '{"codigo":"1566768432","ean":"7891009828664","produto":"Furadeira de Impacto","modelo":"GSB 550 RE","potencia":"550 W","tensao":"220V","alimentacao":"Elétrica","possui_impacto":true,"mandril":"1/2 polegada","capacidade_mandril":"13 mm","velocidade":"2700 rpm","peso":"2,16 Kg","garantia":"12 meses","imagem_pagina_url":"https://www.leroymerlin.com.br/furadeira-de-impacto-gsb-550-re-550w-bosch_1566768432","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3071, 1001, 'Lâmpada LED Taschibra 2700K PAR 20 7W', 'Taschibra', 'LEROY MERLIN', 2022, '12.90', 46, 10, '{"codigo":"1568337999","ean":"7897079089622","tipo":"Lâmpada LED","formato":"PAR 20","potencia":"7 W","temperatura_cor":"2700 K","tensao":"Autovolt","garantia":"3 anos","imagem_pagina_url":"https://www.leroymerlin.com.br/lampada-led-taschibra-2700k-par-20-7w_1568337999","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3072, 1001, 'Lâmpada LED Taschibra 6500K PAR 20 7W', 'Taschibra', 'LEROY MERLIN', 2022, '12.90', 0, 10, '{"codigo":"1568551472","ean":"7897079089646","tipo":"Lâmpada LED","formato":"PAR 20","potencia":"7 W","temperatura_cor":"6500 K","tensao":"Autovolt","garantia":"3 anos","imagem_pagina_url":"https://www.leroymerlin.com.br/lampada-led-taschibra-6500k-par-20-7w_1568551472","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3073, 1002, 'Furadeira de Impacto Bosch GSB 550 RE 550W 127V', 'Bosch', 'LEROY MERLIN', 2003, '299.90', 7, 4, '{"codigo":"1566986937","ean":"7891009866031","produto":"Furadeira de Impacto","modelo":"GSB 550 RE","potencia":"550 W","tensao":"127V (110V)","alimentacao":"Elétrica","possui_impacto":true,"imagem_pagina_url":"https://www.leroymerlin.com.br/furadeira-de-impacto-gsb-550-re-550w-127v_1566986937","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3074, 1004, 'Furadeira Impacto 550W 2700rpm GSB 550 RE Bosch', 'Bosch', 'LEROY MERLIN', 2003, '299.90', 120, 22, '{"codigo":"1566768426","ean":"7891009828657","produto":"Furadeira de Impacto","modelo":"GSB 550 RE","potencia":"550 W","tensao":"220V","alimentacao":"Elétrica","possui_impacto":true,"mandril":"1/2 polegada","capacidade_mandril":"13 mm","velocidade":"2700 rpm","peso":"1,8 Kg","garantia":"12 meses","imagem_pagina_url":"https://www.leroymerlin.com.br/furadeira-impacto-550w-2700rpm-gsb-550-re-bosch_1566768426","origem":"Leroy Merlin","dados_de_estoque":"simulados","observacao":"Estoque elevado para representar estoque de centro de distribuição"}'::jsonb),
    (3075, 1004, 'Lâmpada LED Taschibra 6500K PAR 20 7W', 'Taschibra', 'LEROY MERLIN', 2022, '12.90', 350, 31, '{"codigo":"1568551472","ean":"7897079089646","tipo":"Lâmpada LED","formato":"PAR 20","potencia":"7 W","temperatura_cor":"6500 K","tensao":"Autovolt","garantia":"3 anos","imagem_pagina_url":"https://www.leroymerlin.com.br/lampada-led-taschibra-6500k-par-20-7w_1568551472","origem":"Leroy Merlin","dados_de_estoque":"simulados","observacao":"Estoque elevado para representar estoque de centro de distribuição"}'::jsonb),
    (3080, 1001, 'Desentupidor Manual Bomba 150mm Dexter', 'Dexter', 'LEROY MERLIN', 2065, '79.90', 8, 20, '{"codigo":"91801710","tipo":"Desentupidor Manual","modelo":"Bomba 150mm","ambiente_indicado":["Cozinha","Banheiro"],"aplicacao":["Pia","Ralo","Vaso sanitário"],"imagem_pagina_url":"https://www.leroymerlin.com.br/desentupidor-manual-bomba-150mm-dexter_91801710","origem":"Leroy Merlin","dados_de_estoque":"simulados","papel_no_problema":"Primeira opção para tentativa de desobstrução mecânica"}'::jsonb),
    (3081, 1001, 'Desentupidor Manual Com Mola Nove54', 'Nove54', 'LEROY MERLIN', 2065, '99.00', 5, 20, '{"codigo":"1553637426","tipo":"Desentupidor Manual com Mola","aplicacao":["Pia","Ralo","Tubulação"],"imagem_pagina_url":"https://www.leroymerlin.com.br/desentupidor-manual-com-mola-nove54_1553637426","origem":"Leroy Merlin","dados_de_estoque":"simulados","papel_no_problema":"Alternativa mecânica para obstruções mais profundas"}'::jsonb),
    (3082, 1001, 'Sifão para Pia Universal Extensível 1", 1.1/2" e 1.1/4" Tigre', 'Tigre', 'LEROY MERLIN', 2063, '46.70', 6, 21, '{"codigo":"88008872","ean":"7898482242246","tipo":"Sifão para Pia","local_indicado":"Pia","tipo_corpo":"Extensível","entrada":["1 polegada","1.1/2 polegada","1.1/4 polegada"],"saida":["1 polegada","1.1/2 polegada","1.1/4 polegada"],"comprimento_maximo":"70 cm","comprimento_minimo":"32,5 cm","material":"Plástico","cor":"Branco","imagem_pagina_url":"https://www.leroymerlin.com.br/sifao-para-pia-universal-extensivel-1-1-1-2-e-1-1-4-tigre_88008872","origem":"Leroy Merlin","dados_de_estoque":"simulados","papel_no_problema":"Substituição do sifão caso a obstrução esteja no sifão ou seja necessária manutenção"}'::jsonb),
    (3083, 1001, 'Sifão Sanfonado Copo Universal Black Extensível Até 50cm', 'Roddex', 'Toc Casa', 2063, '73.90', 4, 21, '{"codigo":"1572330249","ean":"7908544305502","tipo":"Sifão","local_indicado":"Cozinha","tipo_corpo":"Extensível","material":["Polipropileno","PVC","Elastômeros"],"cor":"Preto","comprimento_maximo":"50 cm","ligacao":["DN38","DN40","DN48","DN50"],"acompanha":["Bucha redutora","Anéis de vedação"],"imagem_pagina_url":"https://www.leroymerlin.com.br/sifao-sanfonado-copo-universal-black-extensivel-ate-50cm_1572330249","origem":"Leroy Merlin","dados_de_estoque":"simulados","papel_no_problema":"Alternativa para substituição do sifão da pia"}'::jsonb),
    (3084, 1001, 'Fita Veda Rosca 18mmx10m Tigre', 'Tigre', 'LEROY MERLIN', 2061, '12.90', 31, 21, '{"codigo":"85302812","ean":"7897613336946","produto":"Fita Veda Rosca","largura":"18 mm","comprimento":"10 m","material":"Teflon","cor":"Branco","uso_indicado":["Água fria","Água quente"],"aplicacao":["Roscas de PVC","Roscas metálicas","Conexões hidráulicas"],"imagem_pagina_url":"https://www.leroymerlin.com.br/fita-veda-rosca-18mmx10m-tigre_85302812","origem":"Leroy Merlin","dados_de_estoque":"simulados","papel_no_problema":"Material de apoio para vedação durante reinstalação do sifão/conexões"}'::jsonb),
    (3085, 1001, 'Válvula Para Pia Americana 3,1/2 Cromado Esteves', 'Esteves', 'Liven Casa', 2064, '55.57', 4, 22, '{"codigo":"1572255319","ean":"7891589114324","produto":"Válvula de Escoamento","tamanho":"3,1/2 polegadas","acabamento":"Cromado","cor":"Cromado","material":"Metal","aplicacao":["Pia de cozinha","Banheiro"],"imagem_pagina_url":"https://www.leroymerlin.com.br/valvula-para-pia-americana-3%2C1-2-cromado-esteves_1572255319","origem":"Leroy Merlin","dados_de_estoque":"simulados","papel_no_problema":"Peça de substituição caso o problema esteja na válvula/ralo da pia"}'::jsonb),
    (3086, 1001, 'Desentupidor de Pia Ralo Vaso Sanitário Pistola de Alta Pressão', 'Dona D.cor', 'Dona D.cor', 2065, '92.90', 3, 20, '{"codigo":"1572656267","ean":"7908627900501","produto":"Desentupidor","tipo":"Pistola de Alta Pressão","aplicacoes":["Pias","Ralos","Tanques","Tubulações"],"bocais":4,"material":"Plástico ABS","garantia":"6 meses","imagem_pagina_url":"https://www.leroymerlin.com.br/desentupidor-de-pia-ralo-vaso-sanitario-pistola-de-alta-pressao-para-cano-tanque-privada-banheiro_1572656267","origem":"Leroy Merlin","dados_de_estoque":"simulados","papel_no_problema":"Opção de desobstrução mecânica por pressão"}'::jsonb),
    (3090, 1001, 'Massa Corrida Complemento para Paredes Branca Balde 25kg Suvinil', 'Suvinil', 'LEROY MERLIN', 2067, '84.90', 18, 7, '{"codigo":"90658162","ean":"7891260470435","tipo":"Massa Corrida","embalagem":"Balde","quantidade":"25 kg","cor":"Branco","rendimento":"até 75 m²","demãos":2,"base":"Água","ambiente":"Áreas secas","lavavel":false,"odor":"Baixo Odor","imagem_pagina_url":"https://www.leroymerlin.com.br/massa-corrida-complemento-para-paredes-branca-balde-25kg-suvinil_90658162","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3091, 1001, 'Espátula Aço Cromado 10cm', 'Atlas', 'Rbs Materiais De Construção', 2069, '18.90', 11, 7, '{"codigo":"1567518378","ean":"7896380173167","largura_lamina":"10 cm","material_lamina":"Aço","material_cabo":"Plástico","uso_indicado":"Aplicar gesso e massa corrida","imagem_pagina_url":"https://www.leroymerlin.com.br/espatula-aco-cromado-10cm_1567518378","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3092, 1001, 'Lixa para Madeira e Massa Grão 120 225x275mm 1 Unidade Dexter', 'Dexter', 'LEROY MERLIN', 2072, '2.09', 64, 8, '{"codigo":"92151990","ean":"7894422001232","tipo":"Lixa Manual","grao":120,"material_a_lixar":["Madeira","Massa"],"tamanho":"225x275 mm","material_grao":"Óxido de Alumínio","costado":"Papel Impermeável","quantidade":"1 unidade","imagem_pagina_url":"https://www.leroymerlin.com.br/lixa-para-madeira-e-massa-grao-120-225x275cm-1-unidade-dexter_92151990","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3093, 1001, 'Rolo Lã Condor 959 Zero Gota 9mm 23cm com Suporte', 'Condor', 'LEROY MERLIN', 2070, '29.90', 15, 8, '{"codigo":"1568424985","tipo":"Rolo de Lã","largura":"23 cm","altura_lã":"9 mm","tecnologia":"Zero Gota","acompanha_suporte":true,"superficie_indicada":["Paredes","Superfícies lisas","Superfícies semirrugosas"],"imagem_pagina_url":"https://www.leroymerlin.com.br/rolo-la-condor-959-zero-gota-9mm-23cm-com-suporte_1568424985","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3094, 1001, 'Rolo de Lã Condor Sintético 8095 23cm com Suporte', 'Condor', 'LEROY MERLIN', 2070, '32.90', 9, 8, '{"codigo":"1568531562","tipo":"Rolo de Lã","largura":"23 cm","tecnologia":"Antirrespingo","acompanha_suporte":true,"tipo_manta":"Lã sintética","superficie_indicada":"Parede","observacao_variacao":"Mesmo tamanho do produto 3093, mas com especificação de aplicação diferente","imagem_pagina_url":"https://www.leroymerlin.com.br/rolo-de-la-condor-sintetico-8095-23cm-com-suporte_1568531562","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3095, 1001, 'Prateleira Eleva Branca 80 Cm', 'Completa Móveis', 'Parceiro Leroy Merlin', 2074, '169.90', 7, 17, '{"codigo":"1570686714","ean":"7899671468003","comprimento":"80 cm","profundidade":"19 cm","largura":"100 cm","material":"Madeira","cor":"Branco","suportes":"Duplos","imagem_pagina_url":"https://www.leroymerlin.com.br/prateleira-eleva-branca-80-cm_1570686714","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3096, 1001, 'Prateleira Eleva Branca 120 Cm', 'Completa Móveis', 'Parceiro Leroy Merlin', 2074, '229.90', 5, 17, '{"codigo":"1570739564","ean":"7899671468027","comprimento":"120 cm","profundidade":"19 cm","largura":"120 cm","material":"Madeira","cor":"Branco","suportes":"Duplos","comodo_indicado":"Multiuso","imagem_pagina_url":"https://www.leroymerlin.com.br/prateleira-eleva-branca-120-cm_1570739564","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3097, 1001, 'Prateleira de Madeira MDP Branca 120x25cm com Suporte Invisível Bemfixa', 'Bemfixa', 'Parceiro Leroy Merlin', 2074, '189.90', 4, 17, '{"codigo":"92374513","dimensoes":"120x25 cm","material":"MDP","cor":"Branco","tipo_suporte":"Invisível","formato":"Retangular","imagem_pagina_url":"https://www.leroymerlin.com.br/prateleira-de-madeira-mdp-branca-120x25cm-com-suporte-invisivel-bemfixa_92374513","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3098, 1001, 'Frigideira Smart Plus New 24 Cm - Brinox', 'Brinox', 'Parceiro Leroy Merlin', 2076, '129.90', 0, 24, '{"codigo":"1569315948","ean":"2050000648724","diametro":"24 cm","material":"Alumínio","antiaderente":true,"revestimento":"Cerâmico Pro Ceramic","espessura":"2,5 mm","cor":"Preto","fogoes_compativeis":["Gás","Elétrico","Vitrocerâmico"],"cabo":"Baquelite Soft Touch","modelo":"300052871","imagem_pagina_url":"https://www.leroymerlin.com.br/frigideira-smart-plus-new-24-cm-brinox_1569315948","origem":"Leroy Merlin","dados_de_estoque":"simulados","cenario":"ESTOQUE_ZERO_INTERLAGOS"}'::jsonb),
    (3098, 1002, 'Frigideira Smart Plus New 24 Cm - Brinox', 'Brinox', 'Parceiro Leroy Merlin', 2076, '129.90', 8, 24, '{"codigo":"1569315948","ean":"2050000648724","diametro":"24 cm","material":"Alumínio","antiaderente":true,"revestimento":"Cerâmico Pro Ceramic","espessura":"2,5 mm","cor":"Preto","fogoes_compativeis":["Gás","Elétrico","Vitrocerâmico"],"cabo":"Baquelite Soft Touch","modelo":"300052871","imagem_pagina_url":"https://www.leroymerlin.com.br/frigideira-smart-plus-new-24-cm-brinox_1569315948","origem":"Leroy Merlin","dados_de_estoque":"simulados","cenario":"DISPONIVEL_EM_OUTRA_LOJA"}'::jsonb),
    (3098, 1004, 'Frigideira Smart Plus New 24 Cm - Brinox', 'Brinox', 'Parceiro Leroy Merlin', 2076, '129.90', 45, 31, '{"codigo":"1569315948","ean":"2050000648724","diametro":"24 cm","material":"Alumínio","antiaderente":true,"revestimento":"Cerâmico Pro Ceramic","espessura":"2,5 mm","cor":"Preto","fogoes_compativeis":["Gás","Elétrico","Vitrocerâmico"],"cabo":"Baquelite Soft Touch","modelo":"300052871","imagem_pagina_url":"https://www.leroymerlin.com.br/frigideira-smart-plus-new-24-cm-brinox_1569315948","origem":"Leroy Merlin","dados_de_estoque":"simulados","cenario":"DISPONIVEL_NO_CENTRO_DE_DISTRIBUICAO"}'::jsonb),
    (3099, 1001, 'Frigideira Reverse Alumínio 24 Cm - Neoflam', 'Neoflam', 'Camicado', 2076, '219.90', 0, 24, '{"codigo":"1566881564","ean":"8806179686920","diametro":"24 cm","material":"Alumínio forjado","antiaderente":true,"revestimento":"Cerâmico Ecolon","cor":"Preto","modelo":"36041","fogoes_compativeis":["Indução","Gás","Elétrico"],"imagem_pagina_url":"https://www.leroymerlin.com.br/frigideira-reverse-aluminio-24-cm-neoflam_1566881564","origem":"Leroy Merlin","dados_de_estoque":"simulados","cenario":"ESTOQUE_ZERO_INTERLAGOS"}'::jsonb),
    (3099, 1003, 'Frigideira Reverse Alumínio 24 Cm - Neoflam', 'Neoflam', 'Camicado', 2076, '219.90', 6, 24, '{"codigo":"1566881564","ean":"8806179686920","diametro":"24 cm","material":"Alumínio forjado","antiaderente":true,"revestimento":"Cerâmico Ecolon","cor":"Preto","modelo":"36041","fogoes_compativeis":["Indução","Gás","Elétrico"],"imagem_pagina_url":"https://www.leroymerlin.com.br/frigideira-reverse-aluminio-24-cm-neoflam_1566881564","origem":"Leroy Merlin","dados_de_estoque":"simulados","cenario":"DISPONIVEL_EM_OUTRA_LOJA"}'::jsonb),
    (3100, 1001, 'Frigideira Francesa Antiaderente 24 Cm Grafite MTA 936', 'MTA', 'Parceiro Leroy Merlin', 2076, '79.90', 10, 24, '{"codigo":"1566876261","ean":"7897186609362","diametro":"24 cm","material":"Alumínio","antiaderente":true,"camadas_antiaderentes":5,"cor":"Grafite","modelo":"936","cabo":"Baquelite","espessura_fundo":"2,0 mm","imagem_pagina_url":"https://www.leroymerlin.com.br/frigideira-francesa-antiaderente-24-cm-grafite-mta-936_1566876261","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3101, 1001, 'Frigideira Francesa Antiaderente 24 Cm Preta', 'Dona Chefa', 'Utensílios Do Chef', 2076, '72.65', 7, 24, '{"codigo":"1568918449","ean":"7898607800412","diametro":"24 cm","material":"Alumínio","antiaderente":true,"camadas_antiaderentes":5,"cor":"Preto","capacidade":"1,6 L","espessura":"1,6 mm","cabo":"Baquelite","imagem_pagina_url":"https://www.leroymerlin.com.br/frigideira-francesa-antiaderente-24-cm-preta_1568918449","origem":"Leroy Merlin","dados_de_estoque":"simulados"}'::jsonb),
    (3102, 1001, 'Colher de Silicone Duplo Preto Oikos', 'Oikos', 'LEROY MERLIN', 2078, '24.90', 18, 25, '{"codigo":"92243032","ean":"7898673984238","material":["Metal","Silicone"],"cor":"Preto","comprimento":"27,2 cm","largura":"6 cm","temperatura_maxima":"240°C","uso":["Cozinhar","Manusear","Misturar"],"adequado_para_antiaderente":true,"imagem_pagina_url":"https://www.leroymerlin.com.br/colher-de-silicone-duplo-preto-oikos_92243032","origem":"Leroy Merlin","dados_de_estoque":"simulados","relacionamento":"Complementar para frigideiras e panelas"}'::jsonb),
    (3103, 1001, 'Jogo de Facas Cozinha 5 Peças', 'GMB Safety', 'Maravilhas Do Lar', 2079, '72.00', 9, 25, '{"codigo":"1572273392","ean":"7908343219956","quantidade_pecas":5,"material":["Aço inox","Plástico"],"tipo":"Conjunto de Facas","itens":["Faca chef","Faca pão","Faca santoku","Faca utilidades","Faca descascar"],"imagem_pagina_url":"https://www.leroymerlin.com.br/jogo-de-facas-cozinha-5-pecas_1572273392","origem":"Leroy Merlin","dados_de_estoque":"simulados","relacionamento":"Produto complementar para utensílios de cozinha"}'::jsonb),
    (3104, 1001, 'Conjunto de Facas Elegance 5 Peças com Suporte Inox', 'Hercules', 'Morgan Store 2', 2079, '510.99', 3, 25, '{"codigo":"1570537831","quantidade_pecas":5,"material_lamina":"Aço inox","acompanha_suporte":true,"tipo":"Conjunto de Facas","imagem_pagina_url":"https://www.leroymerlin.com.br/conjunto-de-facas-elegance-5-pecas-com-suporte-inox-hercules_1570537831","origem":"Leroy Merlin","dados_de_estoque":"simulados","relacionamento":"Alternativa ao produto 3103"}'::jsonb)
ON CONFLICT (id, loja_id) DO NOTHING;

-- 5. VIEW PARA REFERÊNCIA DE IDS/NOMES (inclui loja por causa da PK composta)
CREATE OR REPLACE VIEW public.referencia_produtos AS
SELECT
    p.id AS produto_id,
    p.loja_id,
    l.nome AS loja,
    p.nome AS nome_produto,
    p.marca,
    p.categoria_id,
    p.especificacoes->>'codigo' AS codigo_catalogo
FROM public.produtos p
JOIN public.lojas l ON l.id = p.loja_id;

COMMIT;

-- 6. CONSULTAS DE CONFERÊNCIA
SELECT COUNT(*) AS total_lojas FROM public.lojas;
SELECT COUNT(*) AS total_categorias FROM public.categorias;
SELECT COUNT(*) AS total_registros_produtos FROM public.produtos;

SELECT id, nome, cidade, is_centro_distribuicao
FROM public.lojas ORDER BY id;

SELECT id, nome, parent_id, nivel
FROM public.categorias ORDER BY nivel, id;

SELECT p.id, p.loja_id, l.nome AS loja, p.nome, p.marca, p.vendedor,
       p.preco, p.quantidade_estoque, c.nome AS categoria,
       p.especificacoes->>'codigo' AS codigo,
       p.especificacoes->>'imagem_pagina_url' AS imagem_pagina_url
FROM public.produtos p
JOIN public.lojas l ON l.id = p.loja_id
JOIN public.categorias c ON c.id = p.categoria_id
ORDER BY p.id, p.loja_id;

-- IDs e nomes para carregar no contexto do agente:
SELECT produto_id, loja_id, loja, nome_produto, marca, codigo_catalogo
FROM public.referencia_produtos
ORDER BY produto_id, loja_id;
