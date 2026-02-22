defmodule Tienda do
  def main do
    valor_total = "Ingrese el valor total de la factura: "
    |> Util.ingresar_entero(:entero)

    valor_entregado = "ingrese el valor entregado: "
    |> Util.ingresar_entero(:entero)

    devuelta = calcular_devuelta(valor_entregado,valor_total)
    generar_mensaje(valor_entregado,valor_total,devuelta)
    |> Util.mostrar_mensaje()

  end

  defp calcular_devuelta(valor_entregado,valor_total) do
    valor_entregado-valor_total
  end

  defp generar_mensaje(valor_entregado,valor_total,devuelta) do
     "El valor total es $#{valor_total} y el valor entregado es $#{valor_entregado} y la devuelta es $#{devuelta}"
  end
end
Tienda.main()
