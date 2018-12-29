defmodule Gpx.Generator do
  @moduledoc """
  Documentation for GpxGenerator.
  """

  def run(points) do
    Application.ensure_all_started(:timex)

    points
    |> transform()
    |> template()
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
end
