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
  def oneline_to_map(line), do: String.split(line, ",") |> list_to_map() |> trim_map()
  
  def multiline_to_map([head | tail]) do
    map = oneline_to_map(head)
    process_multiline(map, tail)
    |> trim_map()
  end
  
  defp process_multiline(prev, []), do: prev
  defp process_multiline(prev, [head | tail]) do
    map = String.split(head, ",")
    |> list_to_map()
    current = concat_map_recursive(prev, map)
    process_multiline(current, tail)
  end
  
  defp concat_map_recursive(false, map), do: map
  defp concat_map_recursive(%{"" => value1}, %{"" => value2}), do: concat_map_recursive(value1, value2)
  defp concat_map_recursive(value, %{"" => value2}) do
    trim = trim_map(value2)
    if is_map(value) do
      ([head | _] = Map.keys(value)
      %{^head => value1} = value
      %{head => concat_map_recursive(value1, value2)})
    else
      if is_list(value) do
        [head | tail] = Enum.reverse(value)
        result = concat_map_recursive(head, %{"" => value2})
        if is_list(result) do
          result ++ tail
          |> Enum.reverse()
        else
          [result] ++ tail
          |> Enum.reverse()
        end
      else
        if trim == "" do
          value
        else
          %{value => trim}
        end
      end
    end
  end
  defp concat_map_recursive(map1, map2) when is_map(map1) and is_map(map2), do: [trim_map(map1), map2]
  defp concat_map_recursive(list1, value2) when is_list(list1), do: trim_map(list1) ++ [value2]
  defp concat_map_recursive(value1, map2) when is_map(map2), do: [value1, map2]
  defp concat_map_recursive(value1, value2), do: [value1, value2]
  
  #1行のリストをマップに
  defp list_to_map([head | []]), do: String.trim(head)
  defp list_to_map([head | tail]), do: %{String.trim(head) => list_to_map(tail)}
  
  defp trim_map(%{"" => value}), do: trim_map(value)
  defp trim_map(map) when is_map(map) do
    [head | _] = Map.keys(map)
    %{^head => value} = map
    trim = trim_map(value)
    if trim == "" do
      head
    else
      %{head => trim}
    end
  end
  defp trim_map(value) when is_list(value) do
    [head | tail] = Enum.reverse(value)
    Enum.reverse([trim_map(head) | tail])
  end
  defp trim_map(value), do: value
end