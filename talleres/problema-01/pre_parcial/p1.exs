Code.require_file("../util.ex", __DIR__)
defmodule Hotel do
  def main do

  numero_noches = Util.ingresar_entero("Ingrese el numero de noches a hospedar: ",:entero)


  tipo = Util.ingresar_texto("Tipo de cliente (frecuente, corporativo, ocasional): ")
  tipo_cliente =  case tipo  do
    "frecuente" -> :frecuente
    "corporativo" -> :corporativo
    "ocasional" -> :ocasional
    _ ->{:error, "Tipo de cliente no valido"}
  end

  temporada = Util.ingresar_entero("Ingrese un numero (1:temporada alta, 2:temporada baja): ",:entero)

  {:ok, valor_noche} = calcular_valor_noche(numero_noches)#guardian

  subtotal = valor_noche * numero_noches

  {:ok, porcentaje_recargo} = calcular_recargo(temporada)#cond

  recargo = subtotal * porcentaje_recargo |>round()

  descuento = calcular_descuento_cliente(subtotal,tipo_cliente) |> round()#pattern matching

  total = (subtotal - descuento)+recargo  |>round()

     IO.puts("\n=== RESUMEN DE RESERVA ===")
    IO.puts("Tarifa por noche  : $#{valor_noche}")
    IO.puts("Subtotal          : $#{subtotal}")
    IO.puts("Descuento         : -$#{descuento}")
    IO.puts("Recargo temporada : +$#{recargo}")
    IO.puts("TOTAL A PAGAR     : $#{total}")

  end

  defp calcular_valor_noche(numero_noches)
      when numero_noches > 1 and numero_noches <= 2,
      do: {:ok, 120000}

  defp calcular_valor_noche(numero_noches)
      when numero_noches > 2 and numero_noches <= 5,
      do: {:ok, 100000}

  defp calcular_valor_noche(numero_noches)
      when numero_noches > 5, do: {:ok, 85000}

  defp calcular_valor_noche(_), do: {:error, "Número de noches invalido. Debe ser un número mayor a 0."}

  defp calcular_recargo(temporada) do
    cond do
      temporada == 1 -> {:ok,0.25}
      temporada == 2 -> {:ok,0.0}
      true -> {:error,"Temporada invalida. Use 1 (alta) o  2 (baja)."}
    end
  end

  defp calcular_descuento_cliente(subtotal,:frecuente), do: round(subtotal * 0.20)
  defp calcular_descuento_cliente(subtotal,:corporativo), do: round(subtotal * 0.15)
  defp calcular_descuento_cliente(subtotal,:ocasional), do: round(subtotal * 0.0)



end

Hotel.main()
