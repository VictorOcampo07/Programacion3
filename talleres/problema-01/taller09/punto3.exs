defmodule NumeroPerfecto do

  def es_perfecto?(n) when n < 2, do: false

  def es_perfecto?(n) do
    suma_divisores(n, 1, 0) == n
  end

  # Caso base: el divisor actual supera la mitad de n, no hay más divisores
  defp suma_divisores(n, divisor, acc) when divisor > div(n, 2), do: acc

  # Caso recursivo: divisor es divisible, lo sumamos al acumulador
  defp suma_divisores(n, divisor, acc) when rem(n, divisor) == 0 do
    suma_divisores(n, divisor + 1, acc + divisor)
  end

  # Caso recursivo: divisor no es divisible, seguimos sin sumar
  defp suma_divisores(n, divisor, acc) do
    suma_divisores(n, divisor + 1, acc)
  end

end

IO.puts NumeroPerfecto.es_perfecto?(6)    
IO.puts NumeroPerfecto.es_perfecto?(28)
IO.puts NumeroPerfecto.es_perfecto?(12)
IO.puts NumeroPerfecto.es_perfecto?(1)
