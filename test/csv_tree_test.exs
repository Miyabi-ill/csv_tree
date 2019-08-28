defmodule CsvTreeTest do
  use ExUnit.Case
  doctest CsvTree

  test "build map from oneline csv" do
    assert CsvTree.build_oneline("a,,b, c,d,e,,,,") == %{"a" => %{"b" => %{"c" => %{"d" => "e"}}}}
  end
  
  test "build map from twoline csv" do
    assert CsvTree.build_twoline("a,b", "c") == [%{"a" => "b"}, "c"]
    assert CsvTree.build_twoline("a,,b, c,,", ",d,,e,f,") == %{"a" => [%{"b" => "c"}, %{"d" => %{"e" => "f"}}]}
    assert CsvTree.build_twoline("a,,b, c,,", ",,d,,e,f,") == %{"a" => [%{"b" => "c"}, %{"d" => %{"e" => "f"}}]}
  end
  
  test "build map from multiline csv" do
    assert CsvTree.build_multiline(["a,,b, c,,", ",d,,e,f,"]) == %{"a" => [%{"b" => "c"}, %{"d" => %{"e" => "f"}}]}
    assert CsvTree.build_multiline(["a,,b, c,,", ",d,,e,f,", "g,,h,i"]) == [%{"a" => [%{"b" => "c"}, %{"d" => %{"e" => "f"}}]}, %{"g" => %{"h" => "i"}}]
    assert CsvTree.build_multiline(["a,,b, c,,", ",d,,e,f,", "g,,h,i", ",j,k,l"]) == [%{"a" => [%{"b" => "c"}, %{"d" => %{"e" => "f"}}]}, %{"g" => [%{"h" => "i"}, %{"j" => %{"k" => "l"}}]}]
    assert CsvTree.build_multiline(["a,,b, c,,", ",d,,e,f,", "g,,h,i", "j,,,,k,l"]) == [%{"a" => [%{"b" => "c"}, %{"d" => %{"e" => "f"}}]}, %{"g" => %{"h" => "i"}}, %{"j" => %{"k" => "l"}}]
  end
end
