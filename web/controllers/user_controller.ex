defmodule Oiseau.UserController do
  use Oiseau.Web, :controller

  alias Oiseau.User

  @factions ["gatitos", "patitos"]

  plug :scrub_params, "user" when action in [:create, :update]

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def leaderboard(conn, _params) do
    users = User.leaderboard(10)
    render(conn, "index.json", users: users)
  end

  def totals_by_faction(conn, _params) do
    points_by_faction = for faction <- @factions do
      User.all_by_faction(faction)
      |> sum_faction_points
    end
    render(conn, "points_by_faction.json", points_by_faction: points_by_faction)
  end
  defp sum_faction_points(users), do: Enum.reduce(users, 0, fn(user, acc) -> user.points + acc end)

  def create(conn, user_params) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Oiseau.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Oiseau.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end
end
