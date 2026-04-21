defmodule Sumar do

  def sumar([]), do: 0
  def sumar([cabeza|cola]) do
    cabeza + sumar(cola)
  end

  def main do
    numeros = [1,2,3,4,5]
    suma = sumar(numeros)
     IO.puts("la suma es: #{suma}")
  end
end

Sumar.main()
