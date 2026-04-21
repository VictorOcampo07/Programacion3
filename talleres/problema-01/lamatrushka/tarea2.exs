defmodule Tarea do

  def main do
    numeros = [1,2,3,4]
    Enum.each(numeros, fn i -> IO.puts("#{i}") end)
  end
end

Tarea.main()
