// Vazio em desenvolvimento, onde o proxy do Vite resolve /api. Em producao
// recebe a URL absoluta do backend, que responde com CORS liberado.
const baseUrl = (import.meta.env.VITE_API_URL ?? '').replace(/\/+$/, '')

function rota(caminho: string) {
  return `${baseUrl}${caminho}`
}

export interface Loja {
  id: number
  nome: string
  cidade: string
  endereco: string
  isCentroDistribuicao: boolean | null
}

export interface Produto {
  id: number
  lojaId: number
  nome: string
  marca: string | null
  vendedor: string
  categoriaNome?: string | null
  preco: number
  quantidadeEstoque: number
  fileira: number | null
  motivo?: string | null
}

export interface Recomendacao {
  explicacao: string
  produtos: Produto[]
}

export async function listarLojas(): Promise<Loja[]> {
  const response = await fetch(rota('/api/lojas'))
  if (!response.ok) {
    throw new Error('Não foi possível carregar as lojas')
  }
  return response.json()
}

export async function sugerirProdutos(lojaId: number, q: string): Promise<Produto[]> {
  const params = new URLSearchParams({
    lojaId: String(lojaId),
    q,
  })
  const response = await fetch(rota(`/api/produtos/sugerir?${params}`))
  if (!response.ok) {
    throw new Error('Não foi possível buscar sugestões')
  }
  return response.json()
}

export async function recomendarProdutos(lojaId: number, texto: string): Promise<Recomendacao> {
  const response = await fetch(rota('/api/produtos/recomendar'), {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ lojaId, texto }),
  })
  if (!response.ok) {
    const payload = await response.json().catch(() => null) as { erro?: string } | null
    throw new Error(payload?.erro ?? 'Não foi possível obter recomendações')
  }
  return response.json()
}
