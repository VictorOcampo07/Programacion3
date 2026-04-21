Code.require_file("../util.ex", __DIR__)

defmodule Matrushka do

  def abrir(0) do
    IO.puts("Última muñeca")
  end

  def abrir(n) do
    IO.puts("Abriendo muñeca #{n}")
    abrir(n - 1)
    IO.puts("Cerrando muñeca #{n}")
  end

end


n = Util.ingresar_entero("Ingrese el número de veces para este ciclo: ",:entero)
Matrushka.abrir(n)
