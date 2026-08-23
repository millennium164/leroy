import { MapPinned, Package } from 'lucide-react'
import { Produto } from '../api/client'

interface ProductCardProps {
  produto: Produto
  onLeveAteAqui: () => void
}

function formatPreco(preco: number) {
  return preco.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })
}

export function ProductCard({ produto, onLeveAteAqui }: ProductCardProps) {
  return (
    <article className="flex h-full flex-col rounded-2xl border border-stone-200 bg-white p-5 shadow-sm animate-fadeIn">
      <div className="mb-3 flex items-center justify-between gap-2">
        <span className="rounded-full bg-leroy-100 px-2.5 py-0.5 text-xs font-medium text-leroy-800">
          {produto.marca ?? 'Marca própria'}
        </span>
        <span className="flex items-center gap-1 text-xs text-stone-500">
          <Package size={14} />
          {produto.quantidadeEstoque} em estoque
        </span>
      </div>
      <h3 className="text-base font-semibold leading-snug text-stone-900">{produto.nome}</h3>
      {produto.motivo && (
        <p className="mt-2 text-sm text-stone-600">{produto.motivo}</p>
      )}
      <p className="mt-4 text-xl font-bold text-leroy-700">{formatPreco(Number(produto.preco))}</p>
      {produto.vendedor && (
        <p className="mt-1 text-xs text-stone-500">Vendido por {produto.vendedor}</p>
      )}
      <button
        type="button"
        onClick={onLeveAteAqui}
        className="mt-auto flex w-full items-center justify-center gap-2 rounded-xl bg-leroy-500 px-3 py-2.5 text-sm font-medium text-white transition hover:bg-leroy-600"
      >
        <MapPinned size={16} />
        Me leve até aqui
      </button>
    </article>
  )
}
