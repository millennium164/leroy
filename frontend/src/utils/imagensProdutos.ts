const arquivos = import.meta.glob<string>('../assets/produtos/*.{webp,jpg}', {
  eager: true,
  import: 'default',
  query: '?url',
})

const porId = new Map<number, string>()

for (const [caminho, url] of Object.entries(arquivos)) {
  const id = Number(caminho.match(/(\d+)\.\w+$/)?.[1])
  if (Number.isFinite(id)) {
    porId.set(id, url)
  }
}

export function imagemDoProduto(id: number): string | undefined {
  return porId.get(id)
}
