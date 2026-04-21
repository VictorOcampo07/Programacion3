defmodule Reversible do

  # Validación: solo acepta enteros positivos
  def es_reversible?(n) when not is_integer(n), do: {:error, "Debe ser un entero"}
  def es_reversible?(n) when n <= 0, do: {:error, "Debe ser un entero positivo"}

  def es_reversible?(n) do
    invertido = invertir(n, 0)
    suma = n + invertido
    todos_impares?(suma)
  end
  
  # ── Invertir número ──────────────────────────────────────────
  # Caso base: no quedan dígitos
  defp invertir(0, acc), do: acc

  # Caso recursivo: toma el último dígito y lo agrega al acumulador
  defp invertir(n, acc) do
    ultimo = rem(n, 10)
    invertir(div(n, 10), acc * 10 + ultimo)
  end

  # ── Todos los dígitos son impares ────────────────────────────
  # Caso base: no quedan dígitos, todos eran impares
  defp todos_impares?(0), do: true

  # Caso recursivo: verifica si el último dígito es impar
  defp todos_impares?(n) do
    ultimo = rem(n, 10)
    if rem(ultimo, 2) == 0 do
      false
    else
      todos_impares?(div(n, 10))
    end
  end

end

# Pruebas
IO.inspect Reversible.es_reversible?(36)
IO.inspect Reversible.es_reversible?(409)
IO.inspect Reversible.es_reversible?(25)
