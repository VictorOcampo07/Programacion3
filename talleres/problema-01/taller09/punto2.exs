defmodule Potencia do

  # Caso base: cuando se divida n hasta agotar y llegue a 1 si es potencia
  def es_potencia?(1, _b), do: true
  
  # Caso base: si n es negativo no es potencia
  def es_potencia?(n, _b) when n < 1, do: false

  # Caso base: cualquier potencia de 1 siempre da 1
  def es_potencia?(_n, 1), do: false

  # Caso recursivo: si n es divisible por b, seguimos dividiendo
  def es_potencia?(n, b) when rem(n, b) == 0 do
    es_potencia?(div(n, b), b)
  end

   # Caso base: n no es divisible por b, no es potencia
  def es_potencia?(_n, _b), do: false

end


IO.puts Potencia.es_potencia?(16, 2)
IO.puts Potencia.es_potencia?(64, 4)
IO.puts Potencia.es_potencia?(50, 10)
IO.puts Potencia.es_potencia?(50, 1)
