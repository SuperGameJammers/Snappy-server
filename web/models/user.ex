defmodule Oiseau.User do
  use Oiseau.Web, :model

  schema "users" do
    field :faction, :string
    field :name, :string
    field :points, :integer
    field :fb_token, :string
    field :fb_id, :string

    timestamps
  end

  @required_fields ~w(faction name points fb_token fb_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
