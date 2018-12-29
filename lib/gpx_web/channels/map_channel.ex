defmodule GpxWeb.MapChannel do
  use Phoenix.Channel

  def join("map", _params, socket), do: {:ok, socket}

  def handle_in("points", data, socket) do
    {:reply, {:ok, %{data: Gpx.Generator.run(data)}}, socket}
  end

  def handle_in("points", _, socket), do: {:noreply, socket}
end
