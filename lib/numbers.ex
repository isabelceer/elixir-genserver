defmodule Numbers do
  @moduledoc """
  Module Numbers, which implements GenServer to manage number.
  """

  use GenServer

  # Client

  @doc """
  Starts a linked GenServer process, passing in the current module
  (`__MODULE__` == `Numbers`) as both the callback module
  and the alias/name of the server process for future reference.

  Also passes in a map (`%{number: 0}`) as the initial state (handled in the `init/1` callback below).
  """
  @spec start_link(map()) :: {:ok, pid} | {:error, any()}
  def start_link(state \\ %{number: 0}) do
    GenServer.start_link(__MODULE__, state)
  end

  @doc """
  Sends an ':add_number' message asynchronously to the current module's GenServer process, which adds the provided number to the internal state's value of key ':numbers'.
  """
  @spec add_number(pid(), integer()) :: :ok
  def add_number(pid, number) do
    GenServer.cast(pid, {:add_number, number})
  end

  @doc """
  Sends an ':asubtract_number' message asynchronously to the current module's GenServer process, which subtracts the provided number from the internal state's value of key ':numbers'.
  """
  @spec subtract_number(pid(), integer()) :: :ok
  def subtract_number(pid, number) do
    GenServer.cast(pid, {:subtract_number, number})
  end

  @doc """
  Sends a (synchronous) `:get_number` message to the current module's GenServer
  process, which gets current value of the internal state's value of key ':numbers'.
  """
  @spec get_number(pid) :: integer()
  def get_number(pid) do
    GenServer.call(pid, :get_number)
  end

  # Server

  @doc """
  Invokes increment_number/0 function and sets up the initial state of the GenServer.
  """
  @impl true
  def init(state) do
    Process.send_after(self(), :increment_number, 5000)
    {:ok, state}
  end

  @impl true
  def handle_cast({:add_number, number}, state) do
    new_state = Map.update(state, :number, 0, fn current_value -> current_value + number end)
    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:subtract_number, number}, state) do
    new_state =
      Map.update(state, :number, 0, fn current_value ->
        if current_value - number < 0 do
          0
        else
          current_value - number
        end
      end)

    {:noreply, new_state}
  end

  @impl true
  def handle_call(:get_number, _from, state) do
    {:reply, Map.get(state, :number), state}
  end

  @impl true
  def handle_info(:increment_number, state) do
    new_state = Map.update(state, :number, 0, fn current_value -> current_value + 1 end)
    {:noreply, new_state}
  end

  @impl true
  def handle_info(:msg, state) do
    {:noreply, state}
  end
end
