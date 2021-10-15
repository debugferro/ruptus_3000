defmodule Ruptus3000.Data.LocalizationSchema do
  @schema %{
    "type" => "object",
    "properties" => %{
      "latitude" => %{"type" => "number"},
      "longitude" => %{"type" => "number"}
    },
    "required" => ["latitude", "longitude"]
  }

  def schema(), do: @schema
end
