defmodule LiveViewNativeSwiftUi.Modifiers.ControlGroupStyle do
  use LiveViewNativePlatform.Modifier

  modifier_schema "control_group_style" do
    field :style, Ecto.Enum, values: ~w(automatic navigation)a
  end
end
