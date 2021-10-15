defmodule Ruptus3000.Data.Drivers do
  @schema %{
    "type" => "array",
    "items" => %{
      "type" => "object",
      "properties" => %{
        "localization" => Ruptus3000.Data.LocalizationSchema.schema()
      },
      "required" => ["localization"]
    }
  }

  def schema(), do: @schema
end
