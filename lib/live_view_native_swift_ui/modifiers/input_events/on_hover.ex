defmodule LiveViewNativeSwiftUi.Modifiers.OnHover do
  use LiveViewNativePlatform.Modifier

  alias LiveViewNativePlatform.Types.Event

  modifier_schema "on_hover" do
    field :perform, Event
  end
end
