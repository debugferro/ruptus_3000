defmodule Ruptus3000.Data.Point do
  @schema %{
    "type" => "object",
    "properties" => %{
      "localization" => Ruptus3000.Data.LocalizationSchema.schema()
    },
    "required" => ["localization"]
  }

  def schema(), do: @schema
end
