defmodule CsvTree do
  @moduledoc """
  a, b, c
   , d,  , e
   
  to
  
  %{"a" =>
    [{"b" => "c"},
     {"d" => "e"}
    ]}
  """
  
  def build_oneline(line) do
    String.split(line, ",")
    |> build_map()
    |> trim_map()
  end
  
  def build_twoline(line1, line2) do
    map1 = String.split(line1, ",")
    |> build_map()
    map2 = String.split(line2, ",")
    |> build_map()
    merge_map_recursive(map1, map2)
    |> trim_map()
  end
  
  def build_twoline_notrim(line1, line2) do
    map1 = String.split(line1, ",")
    |> build_map()
    map2 = String.split(line2, ",")
    |> build_map()
    merge_map_recursive(map1, map2)
  end
  
  def build_multiline([head | []]), do: String.split(head, ",") |> build_map()
  def build_multiline([line1 | [line2 | []]]), do: build_twoline_notrim(line1, line2)
  def build_multiline([line1 | [line2 | tail]]) do
    map = build_twoline_notrim(line1, line2)
    merge_map_recursive(map, build_multiline(tail))
  end
  
  def build_map([head | []]), do: String.trim(head)
  def build_map([head | tail]), do: %{String.trim(head) => build_map(tail)}
  
  def trim_map(%{"" => value}), do: trim_map(value)
  def trim_map(map) when is_map(map) do
    [head | _] = Map.keys(map)
    %{^head => value} = map
    trim = trim_map(value)
    if trim == "" do
      head
    else
      %{head => trim}
    end
  end
  def trim_map(value), do: value
  
  def merge_map_recursive(first, %{"" => value2}) do
    [head | _] = Map.keys(first)
    %{^head => value} = first
    %{head => merge_map_recursive(value, value2)}
  end
  def merge_map_recursive(first, second) when is_list(first) or is_list(second), do: [trim_map(first) | trim_map(second)]
  def merge_map_recursive(first, second), do: [trim_map(first), trim_map(second)]
end