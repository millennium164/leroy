import { useEffect, useRef, useState } from 'react'
import { UserRound, X } from 'lucide-react'

const DURACAO_AVISO_MS = 8000

export function CallSellerButton() {
  const [chamado, setChamado] = useState(false)
  const timer = useRef<number | null>(null)

  const limparTimer = () => {
    if (timer.current !== null) {
      window.clearTimeout(timer.current)
      timer.current = null
    }
  }

  useEffect(() => limparTimer, [])

  const chamarVendedor = () => {
    limparTimer()
    setChamado(true)
    timer.current = window.setTimeout(() => {
      setChamado(false)
      timer.current = null
    }, DURACAO_AVISO_MS)
  }

  const fechar = () => {
    limparTimer()
    setChamado(false)
  }

  return (
    <div className="pointer-events-none fixed bottom-5 right-5 z-40 flex flex-col items-end gap-3">
      {chamado && (
        <div
          role="status"
          aria-live="polite"
          className="pointer-events-auto flex w-72 items-start gap-3 rounded-2xl border border-stone-200 bg-white p-4 shadow-lg animate-fadeIn"
        >
          <span className="mt-0.5 flex h-8 w-8 shrink-0 items-center justify-center rounded-full bg-leroy-100 text-leroy-700">
            <UserRound size={16} />
          </span>
          <p className="flex-1 text-sm leading-snug text-stone-700">
            Aguarde alguns instantes, um vendedor está indo até você.
          </p>
          <button
            type="button"
            onClick={fechar}
            className="rounded-full p-1 text-stone-400 transition hover:bg-stone-100 hover:text-stone-700"
            aria-label="Fechar aviso"
          >
            <X size={14} />
          </button>
        </div>
      )}
      <button
        type="button"
        onClick={chamarVendedor}
        aria-label="Chamar o vendedor"
        className="pointer-events-auto flex items-center gap-2 rounded-full bg-leroy-500 px-4 py-3 text-sm font-medium text-white shadow-lg outline-none ring-leroy-500/30 transition hover:bg-leroy-600 focus-visible:ring-4"
      >
        <UserRound size={18} />
        Chamar vendedor
      </button>
    </div>
  )
}
