Code.require_file("../util.ex", __DIR__)

defmodule AlquilerVehiculos do

  defp tarifa_base(:economia), do: 80000
  defp tarifa_base(:estandar), do: 120000
  defp tarifa_base(:suv), do: 180000
  defp tarifa_base(:premium), do: 250000

  defp cargo_gps(true), do: 10000
  defp cargo_gps(false), do: 0

  defp cargo_silla_bebe(true), do: 15000
  defp cargo_silla_bebe(false), do: 0

  defp cargo_conductor_adicional(true), do: 25000
  defp cargo_conductor_adicional(false), do: 0

  defp gps_obsequio?(tipo) when tipo == :premium, do: true
  defp gps_obsequio?(_tipo), do: false

  defp aplicar_descuento(total,dias) when dias >= 7, do: trunc(total*0.15)
  defp aplicar_descuento(total,_dias), do: 0

  def calcular(tipo,dias,gps,silla_bebe,conductor) do
    gps_automatico = gps_obsequio?(tipo)
    gps_final = gps or gps_automatico

    base = tarifa_base(tipo)
    c_gps = cargo_gps(gps_final)
    c_silla = cargo_silla_bebe(silla_bebe)
    c_conductor = cargo_conductor_adicional(conductor)

    subtotal = (base*dias) + c_gps + c_silla + c_conductor
    descuento = aplicar_descuento(subtotal, dias)
    total = subtotal-descuento

    aviso_gps = if gps_automatico and not gps do
      "\n GPS agregado automatica porque tipo es premium"
    else
      ""
    end

    aviso_descuento = if dias >= 7 do
      "\n🎉 Descuento del 15% aplicado por #{dias} días de alquiler."
    else
      ""
    end

    IO.puts( """
       ======= Resumen del ticket =======
        Tipo de coche  : #{tipo}
        Dias           : #{dias}
        Tarifa base/dia: $#{base}
        GPS            : $#{c_gps}
        Silla bebe     : $#{c_silla}
        Conductor extra: $#{c_conductor}
        __________________________________
        Subtotal       : $#{subtotal}
        Descuento 15%  : -$#{descuento}
        __________________________________
      TOTAL        : $#{total}#{aviso_gps}#{aviso_descuento}
      """)
  end
end

tipo = case Util.ingresar_texto("Ingrese el tipo de coche a elegir (/Economico/Estandar/SUV/Premium): ") do
  "Economico"  -> :economia
  "Estandar"   -> :estandar
  "SUV"        -> :suv
  "Premium"    -> :premium
  otro         -> IO.puts("Destino '#{otro}' no valido")
end

dias = Util.ingresar_entero("¿Cuantos dias?: ",:entero)
gps  = Util.ingresar_texto("¿Selección de GPS? (s/n): ")  == "s"
silla_bebe = Util.ingresar_texto("¿Silla de bebe?   (s/n): ")  == "s"
conductor = Util.ingresar_texto("¿Conductor adicional?    (s/n): ")  == "s"

AlquilerVehiculos.calcular(tipo,dias,gps,silla_bebe,conductor)
