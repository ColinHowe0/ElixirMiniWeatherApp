defmodule WeatherTest do
  use ExUnit.Case
  doctest Weather

  import Weather, only: [ parse_args: 1]
  
  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h",   "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end
  
  test "acronym returned if argument given" do
    assert parse_args(["KDFW"]) == {"KDFW"}
  end
  
  
end
