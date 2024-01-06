defmodule NumbersTest do
  use ExUnit.Case
  doctest Numbers

  setup do
    {:ok, pid} = Numbers.start_link()
    {:ok, pid: pid}
  end

  test "initial state is a map with a value of number: zero", context do
    assert 0 == Numbers.get_number(context[:pid])
  end

  test "add_number/2 adds number to current value of key ':number' in a map", context do
    assert :ok == Numbers.add_number(context[:pid], 10)
    assert 10 == Numbers.get_number(context[:pid])
  end

  test "subtract_number/2 subtracts number from current value of key ':number' in a map", context do
    Numbers.add_number(context[:pid], 10)
    assert :ok == Numbers.subtract_number(context[:pid], 3)
    assert 7 == Numbers.get_number(context[:pid])
  end

  test "subtract_number/2 does not allow the value of key ':number' below 0", context do
    Numbers.add_number(context[:pid], 10)
    assert :ok == Numbers.subtract_number(context[:pid], 30)
    assert 0 == Numbers.get_number(context[:pid])
  end

  test "get_number/1 gets the current value of key ':number'", context do
    Numbers.add_number(context[:pid], 10)
    assert 10 == Numbers.get_number(context[:pid])
  end
end
