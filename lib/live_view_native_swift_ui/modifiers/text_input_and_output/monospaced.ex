defmodule LiveViewNativeSwiftUi.Modifiers.Monospaced do
  use LiveViewNativePlatform.Modifier

  modifier_schema "monospaced" do
    field :is_active, :boolean, default: true
  end

  def params(is_active) when is_boolean(is_active), do: [is_active: is_active]
  def params(params), do: params
end
