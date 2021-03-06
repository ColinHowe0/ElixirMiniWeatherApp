defmodule Weather do

  @terms_mapping %{
  #  "observation_time_rfc822" => "Time",
   # "temperature_string"      => "Temperature",
    #"weather"                 => "Weather",
   # "wind_dir"                => "Wind Direction",
    #"wind_mph"                => "Wind Speed (mph)",
    "Time"                    => "observation_time_rfc822",
    "Temperature"             => "temperature_string",
    "Weather"                 => "weather",
    "Wind Direction"          => "wind_dir",
    "Wind Speed (mph)"        => "wind_mph",
  }

  @reverse_terms_mapping %{
    "observation_time_rfc822" => "Time",
    "temperature_string"      => "Temperature",
    "weather"                 => "Weather",
    "wind_dir"                => "Wind Direction",
    "wind_mph"                => "Wind Speed(mph)",
    }
    
    
  @moduledoc """
  Fetches weather data about the given acronym from w1.weather.gov/xml/[Acronym]
  
  Default is DFW Airport (KDFW)
  """

  def run(argv) do
    argv
    |> parse_args
    |> process
  end
  

  @doc """
  'argv' can be -h or --help, which returns :help
  
  Otherwise it is an acronym for the appropriate nearby weather station. If the acronym is invalid, invalid data will be returned. 
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean], aliases:  [h: :help])

    case parse do
      { [help: true], _, _} -> :help
      {_, [acronym], _} -> {acronym}
       _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: weather <acronym>
    """
    System.halt(0)
  end


  def process({acronym}) do
    FetchXML.fetch(acronym)
    |> decode_response()
    |> retrieve_information(["Weather", "Wind Speed", "Wind Direction", "Temperature", "Time"])

    
  end


  def decode_response({:ok, body}), do: body["current_observation"]
  def decode_response({:error, error}) do
    IO.puts "Error fetching from the given address."
    System.halt(2)
  end
  
  def retrieve_information(data, terms) when is_list(terms) do
    Map.take(data["#content"], Map.take(@terms_mapping, terms) |> Map.values())
    |> Map.to_list()
    |> Enum.map(fn {key, val} -> {@reverse_terms_mapping[key], to_string(val)} end)
    |> Enum.each(fn {key, val} -> IO.puts("#{key}: #{String.pad_leading(String.trim(val), 30)}") end)
  end
            
end
