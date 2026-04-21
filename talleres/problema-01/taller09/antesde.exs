defmodule SumarPares do

  def invertir(lista), do: invertir(lista, [])
def invertir([], acc), do: acc
def invertir([h | t], acc), do: invertir(t, [h | acc])
end

lis = [3,2,4,5]
IO.puts(SumarPares.invertir(lis))
