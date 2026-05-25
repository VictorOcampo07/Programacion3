# =====================================================================
# 1. DEFINICIÓN DEL STRUCT
# =====================================================================
defmodule Oferta do
  defstruct [:comprador_id, :monto, :timestamp]
end

# =====================================================================
# 2. EL ACTOR CENTRAL: EL SUBASTADOR
# =====================================================================
defmodule Subastador do
  @doc """
  Arranca el proceso del subastador con su estado inicial privado.
  """
  def iniciar(obra_nombre, precio_base) do
    # El estado inicial tiene la obra, el precio base, ninguna oferta actual (nil) y el historial vacío []
    spawn(fn -> escuchar(obra_nombre, precio_base, nil, []) end)
  end

  # Bucle interno del Actor (Mantiene el estado mediante recursión)
  defp escuchar(obra_nombre, precio_base, oferta_actual, historial_ofertas) do
    receive do
      {:ofertar, comprador_pid, comprador_id, monto} ->
        # Determinamos cuál es el precio mínimo a superar
        monto_a_superar = if oferta_actual, do: oferta_actual.monto, else: precio_base

        if monto > monto_a_superar do
          # La oferta es válida: creamos el struct
          timestamp = DateTime.utc_now() |> DateTime.to_string()
          nueva_oferta = %Oferta{comprador_id: comprador_id, monto: monto, timestamp: timestamp}

          send(comprador_pid, {:aceptado, "¡Vas ganando la subasta!"})

          # Ramificamos el ciclo recursivo con el ESTADO ACTUALIZADO
          escuchar(obra_nombre, precio_base, nueva_oferta, [nueva_oferta | historial_ofertas])
        else
          # La oferta es insuficiente
          send(comprador_pid, {:rechazado, "Monto insuficiente. El precio actual es mayor."})

          # El ciclo continúa con el MISMO ESTADO
          escuchar(obra_nombre, precio_base, oferta_actual, historial_ofertas)
        end

      {:consultar_precio, comprador_pid} ->
        monto_actual = if oferta_actual, do: oferta_actual.monto, else: precio_base
        send(comprador_pid, {:precio_actual, monto_actual})

        escuchar(obra_nombre, precio_base, oferta_actual, historial_ofertas)

      :cerrar_subasta ->
        IO.puts("\n==================================================")
        IO.puts("               🚨 MARTILLAZO FINAL 🚨             ")
        IO.puts("==================================================")
        IO.puts("Obra Subastada: #{obra_nombre}")

        if oferta_actual do
          IO.puts("🏆 GANADOR: #{oferta_actual.comprador_id}")
          IO.puts("💰 PRECIO FINAL: $#{oferta_actual.monto} USD")
        else
          IO.puts("❌ Subasta desierta. Nadie ofertó por encima del precio base ($#{precio_base}).")
        end

        guardar_reporte(historial_ofertas)
        :ok # Al no llamar a escuchar(), el proceso muere de forma segura
    end
  end

  # Función privada para la persistencia del CSV
  defp guardar_reporte(historial) do
    encabezado = "comprador_id,monto,timestamp\n"

    lineas =
      historial
      |> Enum.reverse() # Volteamos la lista para que quede en orden cronológico
      |> Enum.map(fn o -> "#{o.comprador_id},#{o.monto},#{o.timestamp}" end)
      |> Enum.join("\n")

    File.write!("reporte_subasta.csv", encabezado <> lineas)
    IO.puts("\n[Sistema] Historial guardado con éxito en 'reporte_subasta.csv'")
  end
end

# =====================================================================
# 3. LOS CLIENTES CONCURRENTES: LOS POSTORES
# =====================================================================
defmodule Comprador do
  @doc """
  Lanza un proceso independiente para un comprador.
  """
  def iniciar(subastador_pid, comprador_id) do
    spawn(fn -> bucle_ofertas(subastador_pid, comprador_id, 4) end)
  end

  # Caso base: cuando ya se agotaron los 4 intentos de oferta
  defp bucle_ofertas(_subastador_pid, _comprador_id, 0), do: :ok

  defp bucle_ofertas(subastador_pid, comprador_id, intentos) do
    # 1. Consultar el precio actual
    send(subastador_pid, {:consultar_precio, self()})

    receive do
      {:precio_actual, precio} ->
        # 2. Calcular incremento aleatorio entre $10 y $50
        incremento = Enum.random(10..50)
        mi_monto = precio + incremento

        IO.puts("👉 [#{comprador_id}] Lanzando oferta por: $#{mi_monto}...")

        # 3. Enviar la oferta al subastador
        send(subastador_pid, {:ofertar, self(), comprador_id, mi_monto})

        # Esperar confirmación del servidor
        receive do
          {:aceptado, msg} -> IO.puts("   └─ 🎉 #{comprador_id} dice: #{msg}")
          {:rechazado, msg} -> IO.puts("   └─ 😭 #{comprador_id} dice: #{msg}")
        end
    end

    # 4. Dormir un tiempo aleatorio entre 200 y 600 ms antes del próximo intento
    tiempo_dormir = Enum.random(200..600)
    :timer.sleep(tiempo_dormir)

    # Siguiente intento recursivo
    bucle_ofertas(subastador_pid, comprador_id, intentos - 1)
  end
end

# =====================================================================
# 4. ORQUESTACIÓN Y CONTROL DEL TIEMPO
# =====================================================================
defmodule Main do
  def run do
    IO.puts("==================================================")
    IO.puts("     CRYPTOLOGIX - SISTEMA DE SUBASTAS EN VIVO    ")
    IO.puts("==================================================\n")

    # 1. Creamos el actor central (Precio Base: $100)
    subastador_pid = Subastador.iniciar("Cyber Punk Mono #42", 100)

    # 2. Despachamos los 3 clientes en paralelo de forma asíncrona
    Comprador.iniciar(subastador_pid, "Comprador_Alfa")
    Comprador.iniciar(subastador_pid, "Comprador_Beta")
    Comprador.iniciar(subastador_pid, "Comprador_Gamma")

    # 3. El proceso principal duerme 3 segundos observando la ráfaga de ofertas
    :timer.sleep(3000)

    # 4. Cerramos el evento de forma definitiva
    send(subastador_pid, :cerrar_subasta)

    # Pausa técnica para permitir la escritura del archivo antes de cortar la terminal
    :timer.sleep(200)
  end
end

# Ejecutar el programa
Main.run()
