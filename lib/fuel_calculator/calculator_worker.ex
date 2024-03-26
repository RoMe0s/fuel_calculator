defmodule FuelCalculator.CalculatorWorker do
  @moduledoc false

  use GenServer

  @allowed_types ~w(launch land)a

  alias FuelCalculator.Calculator

  def init(_) do
    {:ok, %{config: Application.get_env(:fuel_calculator, __MODULE__)}}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  ## API

  def calculate(equipment_weight, gravity, type) when type in @allowed_types,
    do: GenServer.call(__MODULE__, {:calculate, equipment_weight, gravity, type})

  ## Callbacks

  def handle_call({:calculate, equipment_weight, gravity, type}, _from, %{config: config} = state) do
    fuel =
      Calculator.call(
        equipment_weight,
        gravity,
        get_coefficient(config, type),
        get_shift(config, type)
      )

    {:reply, fuel, state}
  end

  ## Internal functions

  defp get_coefficient(config, type),
    do: config[:"#{type}_coefficient"]

  defp get_shift(config, type),
    do: config[:"#{type}_shift"]
end
