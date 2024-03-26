defmodule FuelCalculatorTest do
  use ExUnit.Case

  doctest FuelCalculator

  describe "calculate/2" do
    test "Apollo 11" do
      assert :ok =
               FuelCalculator.calculate(28801, [
                 {:launch, 9.807},
                 {:land, 1.62},
                 {:launch, 1.62},
                 {:land, 9.807}
               ])

      assert 51898 = FuelCalculator.get_result()
    end

    test "Mission on Mars" do
      assert :ok =
               FuelCalculator.calculate(14606, [
                 {:launch, 9.807},
                 {:land, 3.711},
                 {:launch, 3.711},
                 {:land, 9.807}
               ])

      assert 33388 = FuelCalculator.get_result()
    end

    test "Passenger ship" do
      assert :ok =
               FuelCalculator.calculate(75432, [
                 {:launch, 9.807},
                 {:land, 1.62},
                 {:launch, 1.62},
                 {:land, 3.711},
                 {:launch, 3.711},
                 {:land, 9.807}
               ])

      assert 212_161 = FuelCalculator.get_result()
    end
  end
end
