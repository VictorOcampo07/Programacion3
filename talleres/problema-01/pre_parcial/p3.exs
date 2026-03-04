Code.require_file("../util.ex", __DIR__)

defmodule Aerolinea do

  defp tarifa_base(:bogota), do: 150000
  defp tarifa_base(:medellin), do: 180000
  defp tarifa_base(:cartagena), do: 280000
  defp tarifa_base(:san_andres), do: 350000

  defp cargo_silla(true), do: 15000
  defp cargo_silla(false), do: 0

  defp cargo_matela(true), do: 45000
  defp cargo_matela(false), do: 0

  defp cargo_seguro(true), do: 12000
  defp cargo_seguro(false), do:  0

  defp maleta_obligatoria?(destino) when destino == :san_andres, do: true
  defp maleta_obligatoria?(_destino), do: false

  def calcular(destino,silla,maleta,seguro) do
    maleta_auto = maleta_obligatoria?(destino)
    maleta_final = maleta or maleta_auto

    base = tarifa_base(destino)
    c_silla = cargo_silla(silla)
    c_maleta = cargo_matela(maleta_final)
    c_seguro = cargo_seguro(seguro)
    total = base + c_silla + c_maleta + c_seguro

    aviso = if maleta_auto and not maleta do
      "\n  Maleta de bodega agregada automáticamente por viajar a San Andrés."
    else
      ""
    end

    IO.puts( """
    \n ======= Resumen del ticket =======
        Destino    : #{destino}
        Tarifa base: #{base}
        Silla      : #{c_silla}
        Maleta     : #{c_maleta}
        Seguro     : #{c_seguro}
      ---------------------------------
      TOTAL        : $#{total}#{aviso}
      """)
  end
end

destino = case Util.ingresar_texto("Destino (bogota/medellin/cartagena/san_andres): ") do
  "bogota"     -> :bogota
  "medellin"   -> :medellin
  "cartagena"  -> :cartagena
  "san_andres" -> :san_andres
  otro         -> IO.puts("Destino '#{otro}' no válido.")
end

silla  = Util.ingresar_texto("¿Selección de silla? (s/n): ")  == "s"
maleta = Util.ingresar_texto("¿Maleta de bodega?   (s/n): ")  == "s"
seguro = Util.ingresar_texto("¿Seguro de viaje?    (s/n): ")  == "s"

Aerolinea.calcular(destino, silla, maleta, seguro)
