import { FormEvent, KeyboardEvent, RefObject } from 'react'
import { ArrowUp, LoaderCircle } from 'lucide-react'

interface SearchBarProps {
  value: string
  loading: boolean
  inputRef: RefObject<HTMLTextAreaElement | null>
  onChange: (value: string) => void
  onSubmit: () => void
}

export function SearchBar({ value, loading, inputRef, onChange, onSubmit }: SearchBarProps) {
  const handleSubmit = (event: FormEvent) => {
    event.preventDefault()
    onSubmit()
  }

  const handleKeyDown = (event: KeyboardEvent<HTMLTextAreaElement>) => {
    if (event.key === 'Enter' && !event.shiftKey) {
      event.preventDefault()
      onSubmit()
    }
  }

  return (
    <form onSubmit={handleSubmit} className="relative">
      <label htmlFor="busca" className="sr-only">
        Buscar produto ou descrever um problema
      </label>
      <textarea
        id="busca"
        ref={inputRef}
        rows={2}
        value={value}
        disabled={loading}
        onChange={(event) => onChange(event.target.value)}
        onKeyDown={handleKeyDown}
        placeholder="Furadeira Bosch ou “pia entupida”…"
        className="w-full resize-none rounded-3xl border border-stone-200 bg-white px-5 py-4 pr-14 text-base text-stone-900 shadow-lg shadow-stone-200/70 outline-none ring-leroy-500/30 placeholder:text-stone-400 focus:border-leroy-500 focus:ring-4 disabled:opacity-70"
      />
      <button
        type="submit"
        disabled={loading || value.trim().length === 0}
        className="absolute bottom-3 right-3 flex h-10 w-10 items-center justify-center rounded-full bg-leroy-500 text-white transition hover:bg-leroy-600 disabled:cursor-not-allowed disabled:bg-stone-300"
        aria-label="Buscar"
      >
        {loading ? <LoaderCircle size={18} className="animate-spin" /> : <ArrowUp size={18} />}
      </button>
    </form>
  )
}
