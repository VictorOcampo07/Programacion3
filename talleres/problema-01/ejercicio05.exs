defmodule MiPrograma do
  def main do
    registrar_usuario(1)
  end

  defp registrar_usuario(intentos) do
    nombre_usuario =
      "Ingrese el nombre del usuario: "
      |> Util.ingresar_texto()

    edad_usuario =
      "Ingrese la edad del usuario: "
      |> Util.ingresar_entero(:entero)

    credencial =
      "Ingrese si tiene credencial (true/false): "
      |> Util.ingresar_booleano(:booleano)

    IO.puts("Intentos realizados: #{intentos}")

    cond do
      edad_usuario < 18 ->
        IO.puts("Error: no se pueden ingresar menores de edad")
        registrar_usuario(intentos + 1)

      credencial == false ->
        IO.puts("Error: credencial inválida, acceso denegado")
        registrar_usuario(intentos + 1) 

      true ->
        IO.puts("Ok, acceso concedido. Bienvenido #{nombre_usuario}!")
    end
  end
end

MiPrograma.main()
