defmodule FuelCalculator do
  @moduledoc """
  FuelCalculator API.
  """

  alias FuelCalculator.CalculatorWorker

  @doc """
  Calculate weight of required fuel for the trip in the space.

  ## Examples

      iex> FuelCalculator.calculate(28801, [{:launch, 9.807}, {:land, 1.62}, {:launch, 1.62}, {:land, 9.807}])
      51898

  """
  @spec calculate(
          equipment_weight :: non_neg_integer(),
          actions :: list({:launch | :land, float()})
        ) :: integer()
  def calculate(equipment_weight, actions) when equipment_weight > 0 do
    actions
    |> Enum.reverse()
    |> Enum.reduce(0, fn {type, gravity}, total_fuel_weight ->
      equipment_weight
      |> Kernel.+(total_fuel_weight)
      |> CalculatorWorker.calculate(gravity, type)
      |> Kernel.+(total_fuel_weight)
    end)
  end
end
