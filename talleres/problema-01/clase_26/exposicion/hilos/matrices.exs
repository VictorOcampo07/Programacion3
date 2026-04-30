defmodule MatrizConcurrente do
  def main do
    m = [
      [60,22,41,5],
      [13,33,44,5],
      [89,10,100,99],
      [5,101,6,34]
    ]
    t1 = Task.async( fn ->
      m
      |> Enum.with_index()
      |> Enum.reduce(0,fn {fila, i}, acc ->
         fila
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {val, j}, acc2 ->
          if i > j, do: acc2 + val, else: acc2
        end)
      end)
    end)

    t2 =  Task.async( fn -> {suma, count} =
      m
      |> List.flatten()
      |> Enum.reduce({0, 0}, fn x, {s, c} -> {s + x, c + 1} end)
      suma / count
    end)
    s1 = Task.await(t1)
    s2 = Task.await(t2)
    c = s1*s2
    IO.puts("Resultado C: #{c}")
  end
end
MatrizConcurrente.main()
