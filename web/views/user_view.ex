defmodule Oiseau.UserView do
  use Oiseau.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Oiseau.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Oiseau.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      faction: user.faction,
      name: user.name,
      points: user.points,
      fb_token: user.fb_token,
      fb_id: user.fb_id}
  end

  def render("points_by_faction.json", %{points_by_faction: points_by_faction}) do
    %{points_by_faction: points_by_faction}
  end
end
