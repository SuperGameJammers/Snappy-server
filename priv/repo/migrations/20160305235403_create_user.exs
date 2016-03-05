defmodule Oiseau.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :faction, :string
      add :name, :string
      add :points, :integer
      add :fb_token, :string
      add :fb_id, :string

      timestamps
    end

  end
end
