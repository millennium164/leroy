import { useEffect, useState } from 'react'
import { Produto, sugerirProdutos } from '../api/client'

export function useDebouncedSuggest(lojaId: number, query: string, enabled: boolean) {
  const [sugestoes, setSugestoes] = useState<Produto[]>([])
  const [carregando, setCarregando] = useState(false)

  useEffect(() => {
    const termo = query.trim()
    if (!enabled || termo.length < 2) {
      setSugestoes([])
      setCarregando(false)
      return
    }

    const handle = window.setTimeout(async () => {
      setCarregando(true)
      try {
        const lista = await sugerirProdutos(lojaId, termo)
        setSugestoes(lista)
      } catch {
        setSugestoes([])
      } finally {
        setCarregando(false)
      }
    }, 250)

    return () => window.clearTimeout(handle)
  }, [lojaId, query, enabled])

  return { sugestoes, carregando }
}
