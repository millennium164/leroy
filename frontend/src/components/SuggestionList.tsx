import { Produto } from '../api/client'

interface SuggestionListProps {
  items: Produto[]
  loading: boolean
  onSelect: (produto: Produto) => void
}

function formatPreco(preco: number) {
  return preco.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })
}

export function SuggestionList({ items, loading, onSelect }: SuggestionListProps) {
  if (!loading && items.length === 0) {
    return null
  }

  return (
    <div className="absolute left-0 right-0 top-full z-10 mt-2 overflow-hidden rounded-2xl border border-stone-200 bg-white shadow-xl">
      {loading && items.length === 0 && (
        <p className="px-4 py-3 text-sm text-stone-500">Buscando produtos relacionados…</p>
      )}
      <ul>
        {items.map((produto) => (
          <li key={`${produto.lojaId}-${produto.id}`}>
            <button
              type="button"
              onClick={() => onSelect(produto)}
              className="flex w-full items-start justify-between gap-3 px-4 py-3 text-left hover:bg-leroy-50"
            >
              <span>
                <span className="block text-sm font-medium text-stone-900">{produto.nome}</span>
                <span className="block text-xs text-stone-500">
                  {produto.marca ?? 'Sem marca'}
                  {produto.categoriaNome ? ` · ${produto.categoriaNome}` : ''}
                </span>
              </span>
              <span className="shrink-0 text-sm font-semibold text-leroy-700">
                {formatPreco(Number(produto.preco))}
              </span>
            </button>
          </li>
        ))}
      </ul>
    </div>
  )
}
