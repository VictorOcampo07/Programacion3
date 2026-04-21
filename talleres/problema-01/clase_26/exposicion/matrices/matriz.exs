defmodule Matriz do

  def diagonal(matriz) do
    n = length(matriz)
    do_diagonal(matriz, 0, n, 0)
  end

  defp do_diagonal(_matriz, i, n,acc) when i == n, do: acc

  defp do_diagonal(matriz, i, n, acc) do
    elem =
      matriz
      |> Enum.at(i)
      |> Enum.at(i)

      [elem | do_diagonal(matriz, i + 1, n, acc + elem)]
    end

  def suma(matriz) do
      do_suma(matriz,0)
  end

  defp do_suma([],acc), do: acc

  defp do_suma([fila | resto ], acc) do
    suma_fila = do_suma_fila(fila,0)
    do_suma(resto,acc + suma_fila)
  end

  defp do_suma_fila([],acc), do: acc

  defp do_suma_fila([elem | resto ], acc ) do
    do_suma_fila(resto, acc +  elem)
  end

end

matriz = [
  [1,  2,  3,  4],
  [5,  6,  7,  8],
  [9,  10, 11, 12],
  [13, 14, 15, 16]
]

result = Matriz.diagonal(matriz)
resultado = Matriz.suma(matriz)
IO.inspect(result, label: "Diagonal")
IO.inspect(resultado, label: "Suma")
