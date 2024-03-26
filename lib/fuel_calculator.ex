defmodule FuelCalculator do
  @moduledoc """
  FuelCalculator API.
  """

  alias FuelCalculator.CalculatorWorker

  @doc """
  Calculate weight of required fuel for the trip in the space.

  ## Examples

      iex> FuelCalculator.calculate(28801, [{:launch, 9.807}, {:land, 1.62}, {:launch, 1.62}, {:land, 9.807}])
      :ok
  """
  @spec calculate(
          equipment_weight :: non_neg_integer(),
          actions :: list({:launch | :land, float()})
        ) :: :ok
  def calculate(equipment_weight, actions) when equipment_weight > 0,
    do: CalculatorWorker.calculate(equipment_weight, actions)

  @doc """
  Resets the latest calculation result.

  ## Examples

    iex> FuelCalculator.reset()
    :ok
  """
  @spec reset() :: :ok
  def reset,
    do: CalculatorWorker.reset()

  @doc """
  Returns the latest calculation result.

  ## Examples

    iex> FuelCalculator.get_result()
    0
  """
  @spec get_result() :: non_neg_integer()
  def get_result,
    do: CalculatorWorker.get_result()
end
