import { MapPin } from 'lucide-react'
import { Loja } from '../api/client'

interface HeaderProps {
  lojas: Loja[]
  lojaId: number
  onLojaChange: (id: number) => void
  onInicio: () => void
}

export function Header({ lojas, lojaId, onLojaChange, onInicio }: HeaderProps) {
  return (
    <header className="sticky top-0 z-20 border-b border-stone-200 bg-white/90 backdrop-blur">
      <div className="mx-auto flex h-16 max-w-5xl items-center justify-between gap-4 px-4">
        <button
          type="button"
          onClick={onInicio}
          className="flex items-center gap-3 rounded-lg text-left outline-none ring-leroy-500/30 hover:opacity-90 focus-visible:ring-4"
          aria-label="Voltar à página inicial"
        >
          <span className="flex h-9 w-9 items-center justify-center rounded-lg bg-leroy-500 text-lg font-bold text-white">
            L
          </span>
          <div>
            <p className="text-sm font-semibold leading-tight text-stone-900">Leroy Merlin</p>
            <p className="text-xs text-stone-500">Assistente da loja</p>
          </div>
        </button>
        <label className="flex min-w-0 items-center gap-2 rounded-full border border-stone-200 bg-stone-50 px-3 py-1.5 text-sm">
          <MapPin size={16} className="shrink-0 text-leroy-600" />
          <select
            className="max-w-[14rem] bg-transparent text-stone-800 outline-none sm:max-w-xs"
            value={lojaId}
            onChange={(event) => onLojaChange(Number(event.target.value))}
            aria-label="Loja atual"
          >
            {lojas.length === 0 && <option value={lojaId}>Interlagos</option>}
            {lojas.map((loja) => (
              <option key={loja.id} value={loja.id}>
                {loja.nome} — {loja.cidade}
              </option>
            ))}
          </select>
        </label>
      </div>
    </header>
  )
}
