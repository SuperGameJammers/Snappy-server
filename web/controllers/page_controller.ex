defmodule Oiseau.PageController do
  use Oiseau.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
