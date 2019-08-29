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
    _build_oneline_notrim(line)
    |> trim_map()
  end
  
  defp _build_oneline_notrim(line) do
    String.split(line, ",")
    |> build_map()
  end
  
  def build_twoline(line1, line2) do
    _build_twoline_notrim(line1, line2)
    |> trim_map()
  end
  
  defp _build_twoline_notrim(line1, line2) do
    map1 = String.split(line1, ",")
    |> build_map()
    map2 = String.split(line2, ",")
    |> build_map()
    merge_map_recursive(map1, map2)
  end
  
  def build_multiline([head | []]), do: _build_oneline_notrim(head)
  def build_multiline([line1 | [line2 | []]]), do: _build_twoline_notrim(line1, line2)
  def build_multiline([line1 | [line2 | tail]]) do
    map = _build_twoline_notrim(line1, line2)
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
  
  def merge_map_recursive(first, %{"" => value2}) when is_map(first) do
    [head | _] = Map.keys(first)
    %{^head => value} = first
    %{head => merge_map_recursive(value, value2)}
  end
  
  def merge_map_recursive(first, %{"" => value2}) do
    %{first => trim_map(value2)}
  end
  def merge_map_recursive(first, second) when is_list(first) and is_list(second), do: first ++ second
  def merge_map_recursive(first, second) when is_list(first), do: first ++ [second]
  def merge_map_recursive(first, second) when is_list(second), do: [first] ++ second
  def merge_map_recursive(first, second), do: [trim_map(first), trim_map(second)]
end