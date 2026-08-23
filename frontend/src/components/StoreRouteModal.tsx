import { useEffect } from 'react'
import { Clock, MapPin, X } from 'lucide-react'
import { Produto } from '../api/client'

interface StoreRouteModalProps {
  produto: Produto | null
  onClose: () => void
}

export function StoreRouteModal({ produto, onClose }: StoreRouteModalProps) {
  useEffect(() => {
    if (!produto) {
      return
    }
    const onKey = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        onClose()
      }
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [produto, onClose])

  if (!produto) {
    return null
  }

  const fileira = produto.fileira != null ? `Fileira ${produto.fileira}` : 'Fileira do produto'

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center bg-stone-900/45 px-4 py-6"
      role="dialog"
      aria-modal="true"
      aria-labelledby="rota-titulo"
      onClick={onClose}
    >
      <div
        className="flex max-h-[92vh] w-full max-w-2xl flex-col overflow-hidden rounded-2xl border border-stone-200 bg-white"
        onClick={(event) => event.stopPropagation()}
      >
        <div className="flex items-start justify-between gap-3 border-b border-stone-200 px-5 py-4">
          <div>
            <h2 id="rota-titulo" className="text-base font-semibold text-stone-900">
              Rota até o produto
            </h2>
            <p className="mt-0.5 line-clamp-2 text-sm text-stone-500">{produto.nome}</p>
          </div>
          <button
            type="button"
            onClick={onClose}
            className="rounded-full p-1.5 text-stone-500 hover:bg-stone-100 hover:text-stone-800"
            aria-label="Fechar rota"
          >
            <X size={18} />
          </button>
        </div>

        <div className="min-h-0 flex-1 overflow-auto bg-stone-100">
          <div className="relative mx-auto w-full">
            <img
              src="/planta-loja.jpg"
              alt="Planta da loja"
              className="block w-full"
            />
            <svg
              className="pointer-events-none absolute inset-0 h-full w-full"
              viewBox="0 0 832 900"
              preserveAspectRatio="xMidYMid meet"
              aria-hidden="true"
            >
              <path
                d="M 618 742 L 568 682 L 522 612 L 490 528 L 458 428 L 352 428 L 352 268 L 352 168"
                fill="none"
                stroke="white"
                strokeWidth="16"
                strokeLinecap="round"
                strokeLinejoin="round"
              />
              <path
                className="route-path"
                d="M 618 742 L 568 682 L 522 612 L 490 528 L 458 428 L 352 428 L 352 268 L 352 168"
                fill="none"
                stroke="#78BE20"
                strokeWidth="8"
                strokeLinecap="round"
                strokeLinejoin="round"
                pathLength="100"
              />
              <g transform="translate(618 742)">
                <circle r="13" fill="#78BE20" stroke="white" strokeWidth="4" />
                <text
                  y="32"
                  textAnchor="middle"
                  fill="#57534e"
                  fontSize="18"
                  fontFamily="system-ui, sans-serif"
                  fontWeight="600"
                >
                  Você
                </text>
              </g>
              <g transform="translate(352 168)">
                <path
                  d="M0 -28 c-12 0 -22 10 -22 22 0 16 22 34 22 34 s22 -18 22 -34 c0 -12 -10 -22 -22 -22z"
                  fill="#78BE20"
                  stroke="white"
                  strokeWidth="3"
                />
                <circle cy="-8" r="6" fill="white" />
              </g>
            </svg>
          </div>
        </div>

        <div className="flex flex-wrap items-center gap-x-5 gap-y-2 border-t border-stone-200 px-5 py-3 text-sm text-stone-600">
          <span className="inline-flex items-center gap-1.5">
            <Clock size={15} className="text-leroy-600" />
            ~2 min a pé
          </span>
          <span className="inline-flex items-center gap-1.5">
            <MapPin size={15} className="text-leroy-600" />
            {fileira}
          </span>
        </div>
      </div>
    </div>
  )
}
