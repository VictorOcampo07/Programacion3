Code.require_file("../util.ex", __DIR__)

defmodule Tarea do
  def imprimir([]), do: IO.puts("Termino")

  def imprimir([cabeza|cola])do
    IO.puts("ida: #{cabeza}")
    imprimir(cola)
    IO.puts("vuelta: #{cabeza}")
  end

  def sumar([]), do: 0
  def sumar([cabeza|cola]) do
    cabeza + sumar(cola)
  end

  def main do
    numeros  = Util.ingresar_texto("Ingresa numeros separados por espacios: ")
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)

    imprimir(numeros)
    suma = sumar(numeros)
    IO.puts("la suma es: #{suma}")
  end
end


    
Tarea.main()
