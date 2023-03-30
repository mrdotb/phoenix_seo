defprotocol SEO.JSONLD.Build do
  @fallback_to_any true

  def build(list_of_items, conn)
end

defimpl SEO.JSONLD.Build, for: Any do
  def build(item, _conn), do: SEO.JSONLD.build(item)
end
