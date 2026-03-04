Code.require_file("../util.ex", __DIR__)
cupon  = Util.ingresar_texto("Ingrese el cupon a validar: ")
defmodule MiCupon do

  def validar_cupon(cupon) do
    cupon
    |> validar_longitud([])
    |> validar_mayusculas(cupon)
    |> validar_numero(cupon)
    |> validar_espacios(cupon)
    |> resultado()
  end

  defp validar_longitud(cupon,errores) do
    if String.length(cupon) < 10 do
      errores ++ ["El cupón debe tener al menos 10 caracteres"]
  else
    errores
  end
  end

  defp validar_mayusculas(errores,cupon) do
    if String.downcase(cupon) == cupon do
      errores ++ ["El cupón debe contener al menos una masyúscula"]
    else
      errores
    end
  end

  defp validar_numero(errores,cupon) do
    sin_numeros = String.replace(cupon, ~r/[0-9]/,"")
    if String.length(sin_numeros) == String.length(cupon) do
      errores ++ ["El cupón debe contener al menos un número"]
    else
      errores
    end
  end

  defp validar_espacios(errores,cupon) do
    if String.contains?(cupon, " ") do
      errores ++ ["El cupón no puede contener espacios"]
    else
      errores
    end
  end

  defp resultado([]), do: {:ok, "Cupón Válido"}
  defp resultado(errores) do
    mensaje = Enum.join(errores, " , ")
    {:error, mensaje}
  end
end

case MiCupon.validar_cupon(cupon) do
  {:ok, mensaje} -> IO.puts(mensaje)
  {:error, mensaje} -> IO.puts("Error: #{mensaje}")
end
