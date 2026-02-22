IO.puts("Bienvenidos a la empresa Once ltda")

defmodule Mensaje do
    def main do
      "Bienvenido a la empresa Once ltda"
      |> IO.puts()
    end

    defp mostrar_mensaje(mensaje) do
      mensaje
      |> IO.puts()
    end
end

 Mensaje.main()
