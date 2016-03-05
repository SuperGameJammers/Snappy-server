defmodule Oiseau.UserTest do
  use Oiseau.ModelCase

  alias Oiseau.User

  @valid_attrs %{faction: "some content", fb_id: "some content", fb_token: "some content", name: "some content", points: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
