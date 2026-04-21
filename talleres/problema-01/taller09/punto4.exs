defmodule CadenaMasLarga do

  # Lista vacía
  def mas_larga([]), do: ""

  # Lista con un solo elemento, ese es el resultado
  def mas_larga([unico]), do: unico

  # Caso recursivo: compara la cabeza con el resultado del resto
  def mas_larga([cabeza | resto]) do
    mas_larga_aux(cabeza, mas_larga(resto))
  end

  # Retorna la cadena más larga entre dos
  defp mas_larga_aux(a, b) do
    if String.length(a) >= String.length(b), do: a, else: b
  end

end

# Pruebas
IO.puts CadenaMasLarga.mas_larga(["hola", "mundo", "elixir", "ok"])
IO.puts CadenaMasLarga.mas_larga(["gato", "perro", "hamster"])
IO.puts CadenaMasLarga.mas_larga(["uno"])
IO.puts CadenaMasLarga.mas_larga([])
