defmodule Ruptus3000.Data.Payload do
  use Ruptus3000Web, :validate

  @schema %{
    "type" => "object",
    "properties" => %{
      "drivers" => Ruptus3000.Data.Drivers.schema(),
      "collect_point" => Ruptus3000.Data.Point.schema(),
      "delivery_point" => Ruptus3000.Data.Point.schema(),
      "max_delivery_time" => %{
        "type" => "number"
      }
    },
    "required" => ["drivers", "collect_point", "delivery_point", "max_delivery_time"]
  }

  def schema(), do: @schema
  def validate_schema(_schema, %{params: %{"force" => true}}), do: :ok
  def validate_schema(schema, conn), do: ExJsonSchema.Validator.validate(schema, conn.params)

  def build_errors(changeset) do
    Enum.map(changeset, fn {msg, target} ->
      %{
        message: msg,
        target: target
      }
    end)
  end
end
