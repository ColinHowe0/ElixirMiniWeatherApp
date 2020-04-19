defmodule FetchXML do

  def fetch(acronym) do
    weather_url(acronym)
    |> HTTPoison.get()
    |> handle_response
  end

  def weather_url(acronym) do
    "https://w1.weather.gov/xml/current_obs/#{acronym}.xml"
  end

  def handle_response({ _, %{status_code: status_code, body: body}}) do
    {
      status_code |> check_for_error(),
      body        |> XmlToMap.naive_map()
    }
  end

  defp check_for_error(200), do: :ok
  defp check_for_error(_),   do: :error
end

