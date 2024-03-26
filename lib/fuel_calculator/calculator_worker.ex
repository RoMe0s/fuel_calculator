defmodule FuelCalculator.CalculatorWorker do
  @moduledoc false

  use GenServer

  @allowed_types ~w(launch land)a

  alias FuelCalculator.Calculator

  def init(_),
    do: {:ok, %{config: Application.get_env(:fuel_calculator, __MODULE__), fuel_weight: 0}}

  def start_link(_),
    do: GenServer.start_link(__MODULE__, %{}, name: __MODULE__)

  ## API

  def calculate(equipment_weight, actions) do
    with :ok <- reset() do
      actions
      |> Enum.reverse()
      |> do_calculate(equipment_weight)
    end
  end

  def reset,
    do: GenServer.call(__MODULE__, :reset)

  def get_result,
    do: GenServer.call(__MODULE__, :result)

  ## Callbacks

  def handle_call({:calculate, equipment_weight, gravity, type}, _from, state) do
    fuel_weight =
      Calculator.call(
        equipment_weight + state.fuel_weight,
        gravity,
        get_coefficient(state.config, type),
        get_shift(state.config, type)
      )

    {:reply, :ok, %{state | fuel_weight: state.fuel_weight + fuel_weight}}
  end

  def handle_call(:reset, _from, state),
    do: {:reply, :ok, %{state | fuel_weight: 0}}

  def handle_call(:result, _from, state),
    do: {:reply, state.fuel_weight, %{state | fuel_weight: 0}}

  ## Internal functions

  defp do_calculate([], _equipment_weight),
    do: :ok

  defp do_calculate([{type, gravity} | tail], equipment_weight) do
    with :ok <- GenServer.call(__MODULE__, {:calculate, equipment_weight, gravity, type}) do
      do_calculate(tail, equipment_weight)
    end
  end

  defp get_coefficient(config, type) when type in @allowed_types,
    do: config[:"#{type}_coefficient"]

  defp get_shift(config, type) when type in @allowed_types,
    do: config[:"#{type}_shift"]
end
