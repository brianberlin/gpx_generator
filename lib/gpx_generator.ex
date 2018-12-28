defmodule Mix.Tasks.GpxGenerator do
  @moduledoc """
  Documentation for GpxGenerator.
  """
  use Mix.Task

  def run([path]) do
    Application.ensure_all_started(:timex)

    path
    |> get_json()
    |> transform()
    |> template()
    |> write_gpx(path)
  end

  def transform(json) do
    json
    |> Enum.with_index(1)
    |> Enum.map(&item/1)
    |> Enum.join("\n")
  end

  def item({[lat, lon], index}) do
    """
    <wpt lat="#{lat}" lon="#{lon}">
      <time>#{Timex.shift(Timex.now(), seconds: index * 1)}</time>
    </wpt>
    """
  end

  def template(content) do
    """
    <?xml version="1.0"?>
    <gpx version="1.1" creator="gpxgenerator.com">
    #{content}
    </gpx>
    """
  end

  def get_json(filename) do
    with {:ok, body} <- File.read(filename), {:ok, json} <- Poison.decode(body), do: json
  end

  def write_gpx(content, filename), do: File.write(filename, content, [:write])
end
