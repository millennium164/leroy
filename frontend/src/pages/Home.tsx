import { useEffect, useRef, useState } from 'react'
import { RotateCcw } from 'lucide-react'
import { Header } from '../components/Header'
import { SearchBar } from '../components/SearchBar'
import { SuggestionList } from '../components/SuggestionList'
import { ProductCard } from '../components/ProductCard'
import { StoreRouteModal } from '../components/StoreRouteModal'
import { Loja, Produto, Recomendacao, listarLojas, recomendarProdutos } from '../api/client'
import { useDebouncedSuggest } from '../hooks/useDebouncedSuggest'

const LOJA_PADRAO = 1001

export function Home() {
  const inputRef = useRef<HTMLTextAreaElement>(null)
  const buscaId = useRef(0)
  const [lojas, setLojas] = useState<Loja[]>([])
  const [lojaId, setLojaId] = useState(LOJA_PADRAO)
  const [query, setQuery] = useState('')
  const [loading, setLoading] = useState(false)
  const [erro, setErro] = useState<string | null>(null)
  const [resultado, setResultado] = useState<Recomendacao | null>(null)
  const [mostrarSugestoes, setMostrarSugestoes] = useState(true)
  const [produtoRota, setProdutoRota] = useState<Produto | null>(null)

  const { sugestoes, carregando: carregandoSugestoes } = useDebouncedSuggest(
    lojaId,
    query,
    mostrarSugestoes && !loading && resultado === null,
  )

  useEffect(() => {
    listarLojas()
      .then(setLojas)
      .catch(() => setLojas([]))
  }, [])

  const buscar = async (texto = query) => {
    const termo = texto.trim()
    if (!termo || loading) {
      return
    }
    setMostrarSugestoes(false)
    setLoading(true)
    setErro(null)
    const id = ++buscaId.current
    try {
      const resposta = await recomendarProdutos(lojaId, termo)
      if (id !== buscaId.current) {
        return
      }
      setResultado(resposta)
    } catch (error) {
      if (id !== buscaId.current) {
        return
      }
      setErro(error instanceof Error ? error.message : 'Falha na busca')
      setResultado(null)
    } finally {
      setLoading(false)
    }
  }

  const selecionarSugestao = (produto: Produto) => {
    buscaId.current += 1
    setQuery(produto.nome)
    setMostrarSugestoes(false)
    setLoading(false)
    setErro(null)
    setResultado({
      explicacao: 'Produto encontrado no estoque desta loja.',
      produtos: [produto],
    })
  }

  const queroOutraCoisa = () => {
    buscaId.current += 1
    setLoading(false)
    setResultado(null)
    setErro(null)
    setProdutoRota(null)
    setQuery('')
    setMostrarSugestoes(true)
    inputRef.current?.focus()
  }

  const handleChange = (value: string) => {
    setQuery(value)
    setMostrarSugestoes(true)
    if (resultado) {
      setResultado(null)
    }
  }

  const temResultados = resultado !== null

  return (
    <div className="flex min-h-screen flex-col">
      <Header
        lojas={lojas}
        lojaId={lojaId}
        onInicio={queroOutraCoisa}
        onLojaChange={(id) => {
          setLojaId(id)
          setResultado(null)
        }}
      />
      <main className={`mx-auto flex w-full max-w-5xl flex-1 flex-col px-4 pb-16 ${temResultados ? 'pt-8' : 'justify-center pt-10'}`}>
        <div className={`mx-auto w-full ${temResultados ? 'max-w-5xl' : 'max-w-2xl'}`}>
          {!temResultados && (
            <div className="mb-8 text-center">
              <h1 className="text-3xl font-semibold tracking-tight text-stone-900 sm:text-4xl">
                O que você precisa hoje?
              </h1>
              <p className="mt-3 text-stone-500">
                Digite o nome de um produto ou descreva o problema. A gente encontra o que tem em estoque nesta loja.
              </p>
            </div>
          )}

          <div className="relative">
            <SearchBar
              value={query}
              loading={loading}
              inputRef={inputRef}
              onChange={handleChange}
              onSubmit={() => void buscar()}
            />
            {mostrarSugestoes && !loading && (
              <SuggestionList
                items={sugestoes}
                loading={carregandoSugestoes}
                onSelect={selecionarSugestao}
              />
            )}
          </div>

          {loading && (
            <p className="mt-6 text-center text-sm text-stone-500">
              Consultando o estoque da loja com o assistente…
            </p>
          )}

          {erro && (
            <p className="mt-6 rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
              {erro}
            </p>
          )}

          {resultado && (
            <section className="mt-8">
              <div className="mb-5 flex flex-wrap items-start justify-between gap-3">
                <p className="max-w-2xl text-stone-700">{resultado.explicacao}</p>
                <button
                  type="button"
                  onClick={queroOutraCoisa}
                  className="inline-flex items-center gap-2 rounded-full border border-stone-200 bg-white px-4 py-2 text-sm font-medium text-stone-700 hover:border-leroy-400 hover:text-leroy-700"
                >
                  <RotateCcw size={16} />
                  Quero outra coisa
                </button>
              </div>
              {resultado.produtos.length === 0 ? (
                <p className="rounded-xl border border-amber-200 bg-amber-50 px-4 py-3 text-sm text-amber-800">
                  Nenhum produto em estoque combinou com essa busca. Reformule a descrição e tente de novo.
                </p>
              ) : (
                <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
                  {resultado.produtos.map((produto) => (
                    <ProductCard
                      key={`${produto.lojaId}-${produto.id}`}
                      produto={produto}
                      onLeveAteAqui={() => setProdutoRota(produto)}
                    />
                  ))}
                </div>
              )}
            </section>
          )}
        </div>
      </main>
      <StoreRouteModal produto={produtoRota} onClose={() => setProdutoRota(null)} />
    </div>
  )
}
