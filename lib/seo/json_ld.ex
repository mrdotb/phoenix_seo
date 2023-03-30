defmodule SEO.JSONLD do
  use Phoenix.Component

  def build(attrs, default \\ nil)

  def build([], _default), do: []

  def build(attrs, _default) when is_struct(attrs), do: []

  def build(attrs, _default) when is_list(attrs) do
    Enum.map(attrs, &to_map/1)
  end

  def build(attrs, _default) when is_map(attrs) do
    [to_map(attrs)]
  end

  def build(_attrs, _default), do: []

  defp to_map(attrs) when is_struct(attrs), do: nil

  defp to_map(attrs) when is_map(attrs) and map_size(attrs) > 0 do
    attrs
  end

  defp to_map(_attrs), do: nil

  attr(:item, :any)
  attr(:json_library, :atom, required: true)
  attr(:config, :any, default: nil)

  def meta(assigns) do
    assigns = assign(assigns, :item, build(assigns[:item], assigns[:config]))

    ~H"""
    <script :for={entry <- @item} :if={entry} type="application/ld+json">
      <%= Phoenix.HTML.raw(@json_library.encode!(entry)) %>
    </script>
    """
  end
end
