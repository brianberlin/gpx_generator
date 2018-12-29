defmodule GpxWeb.PageController do
  use GpxWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
