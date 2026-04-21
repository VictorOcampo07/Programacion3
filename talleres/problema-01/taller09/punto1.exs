defmodule VocalesGraphemes do

  def contar(cadena) do
    contar(String.graphemes(cadena), 0)
  end

  defp contar([], acc), do: acc

  defp contar([h | t], acc) when h in ["a","e","i","o","u",
                                      "A","E","I","O","U"] do

    contar(t, acc + 1)
end

  defp contar([_h| t], acc) do
    contar(t,acc)
  end
end

IO.puts VocalesGraphemes.contar("hola mundo")
