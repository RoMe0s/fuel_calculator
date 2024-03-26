defmodule FuelCalculator.Calculator do
  def call(equipment_weight, gravity, coefficient, shift) do
    equipment_weight
    |> calculate_required_fuel_weight(gravity, coefficient, shift)
    |> add_additional_fuel_weight(gravity, coefficient, shift)
  end

  defp calculate_required_fuel_weight(weight, gravity, coefficient, shift) do
    weight
    |> Kernel.*(gravity)
    |> Kernel.*(coefficient)
    |> Kernel.+(shift)
    |> trunc()
  end

  defp add_additional_fuel_weight(fuel_weight, gravity, coefficient, shift),
    do: fuel_weight + calculate_additional_fuel_weight(fuel_weight, gravity, coefficient, shift)

  defp calculate_additional_fuel_weight(fuel_weight, gravity, coefficient, shift) do
    case calculate_required_fuel_weight(fuel_weight, gravity, coefficient, shift) do
      additional_fuel_weight when additional_fuel_weight >= 0 ->
        additional_fuel_weight +
          calculate_additional_fuel_weight(additional_fuel_weight, gravity, coefficient, shift)

      _additional_fuel_weight ->
        0
    end
  end
end
