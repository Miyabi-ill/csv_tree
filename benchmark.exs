defmodule GenerateBenchData do
  def generate_oneline(current_num, max_num, rand) do
    name = if :rand.uniform(10000) <= rand do
      :crypto.strong_rand_bytes(4)
      |> Base.encode64
      |> binary_part(0, 4)
    else
      ""
    end
    if max_num > current_num do
      name <> "," <> generate_oneline(current_num + 1, max_num, rand)
    else 
      ""
    end
  end
end
list10000x100x100 = Enum.map(0..10000, fn _ -> GenerateBenchData.generate_oneline(0, 100, 10000) end)
list10000x100x33 = Enum.map(0..10000, fn _ -> GenerateBenchData.generate_oneline(0, 100, 3333) end)
list1000x1000x100 = Enum.map(0..1000, fn _ -> GenerateBenchData.generate_oneline(0, 1000, 10000) end)
list1000x1000x33 = Enum.map(0..1000, fn _ -> GenerateBenchData.generate_oneline(0, 1000, 3333) end)
list100x10000x100 = Enum.map(0..100, fn _ -> GenerateBenchData.generate_oneline(0, 10000, 10000) end)
list100x10000x33 = Enum.map(0..100, fn _ -> GenerateBenchData.generate_oneline(0, 10000, 3333) end)

Benchee.run(%{
  "build_10000x100x100" => fn -> CsvTree.build_multiline(list10000x100x100) end,
  "build_10000x100x33" => fn -> CsvTree.build_multiline(list10000x100x33) end,
  "build_1000x1000x100" => fn -> CsvTree.build_multiline(list1000x1000x100) end,
  "build_1000x1000x33" => fn -> CsvTree.build_multiline(list1000x1000x33) end,
  "build_100x10000x100" => fn -> CsvTree.build_multiline(list100x10000x100) end,
  "build_100x10000x33" => fn -> CsvTree.build_multiline(list100x10000x33) end
})