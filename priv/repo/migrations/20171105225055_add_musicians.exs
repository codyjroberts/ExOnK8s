defmodule ExOnK8s.Repo.Migrations.AddMusicians do
  use Ecto.Migration

  def change do
    create table("musicians") do
      add :name, :string
      add :instrument, :string

      timestamps()
    end
  end
end
