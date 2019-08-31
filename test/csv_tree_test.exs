defmodule CsvTreeTest do
  use ExUnit.Case
  doctest CsvTree

  test "build map from oneline csv" do
    assert CsvTree.oneline_to_map(",,a,,b, c,d,e,,,,") == %{"a" => %{"b" => %{"c" => %{"d" => "e"}}}}
  end
  
  test "build map from multiline csv" do
    assert CsvTree.multiline_to_map(["a,,b, c,,", ",d,,e,f,"]) == %{"a" => [%{"b" => "c"}, %{"d" => %{"e" => "f"}}]}
    assert CsvTree.multiline_to_map(["a,,b, c,,", ",d,,e,f,", "g,,h,i"]) == [%{"a" => [%{"b" => "c"}, %{"d" => %{"e" => "f"}}]}, %{"g" => %{"h" => "i"}}]
    assert CsvTree.multiline_to_map(["a,,b, c,,", ",d,,e,f,", "g,,h,i", ",j,k,l"]) == [%{"a" => [%{"b" => "c"}, %{"d" => %{"e" => "f"}}]}, %{"g" => [%{"h" => "i"}, %{"j" => %{"k" => "l"}}]}]
    assert CsvTree.multiline_to_map(["a,,b, c,,", ",d,,e,f,", "g,,h,i", "j,,,,k,l"]) == [%{"a" => [%{"b" => "c"}, %{"d" => %{"e" => "f"}}]}, %{"g" => %{"h" => "i"}}, %{"j" => %{"k" => "l"}}]
    assert CsvTree.multiline_to_map(["a,,b, c,,", ",d,,e,f,", "g,,h,i", "j,,,,k,l", "m,n"]) == [%{"a" => [%{"b" => "c"}, %{"d" => %{"e" => "f"}}]}, %{"g" => %{"h" => "i"}}, %{"j" => %{"k" => "l"}}, %{"m" => "n"}]
    assert CsvTree.multiline_to_map(["a,,b", "c", "d,e,f", ",,,g,h", ",,,i"]) == [%{"a" => "b"}, "c", %{"d" => %{"e" => %{"f" => [%{"g" => "h"}, "i"]}}}]
  end
end
