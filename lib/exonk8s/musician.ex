defmodule ExOnK8s.Musician do
  use Ecto.Schema

  @derive {Poison.Encoder, only: [:name, :instrument]}
  schema "musicians" do
    field :name, :string
    field :instrument, :string
    timestamps()
  end
end

defimpl Poison.Encoder, for: Musician do
  def encode(musician, options) do
    IO.inspect options
    musician
    |> Map.take([:name, :instrument])
    |> Poison.Encoder.encode(options)
  end
end
