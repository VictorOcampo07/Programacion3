defmodule Envio do

  defstruct [:id, :tipo, :distancia, :costo_base]
end

defmodule Servidor do
  def calcular_costo(envio) do

  case envio.tipo do

     "NACIONAL" ->
      envio.costo_base + envio.distancia *0.5

      "INTERNACIONAL" ->
        envio.costo_base + envio.distancia *1.2
        _ -> {:error, "Tipo de envio desconocido"}
      end

    end


  def escuchar do
    receive do
      {cliente_pid, %Envio{} = envio} ->
        costo_total = calcular_costo(envio)
        send(cliente_pid, {:ok, envio.id, costo_total})
        IO.puts("[Servidor] Costo total del envio #{envio.id} es: $#{costo_total}")

        escuchar()

        :detener ->
          IO.puts("[Servidor] Apagando el sistema de calculo de forma segura...")
          :ok
    end
  end
end

defmodule Cliente do

  def solicitar_calculo(servidor_pid, %Envio{} = envio) do

    IO.puts("[Cliente] Enviando solicitud de calculo para el envio #{envio.id}, #{envio.tipo}...")
    send(servidor_pid, {self(), envio})

    receive do
      {:ok, id, costo} ->
        IO.puts("[Cliente] El costo total para el envio #{id} fue recibido: $#{costo}")

      after 5000 -> IO.puts("[Cliente] No se recibió respuesta del servidor en el tiempo esperado.")
    end
  end
end

defmodule Main do

  def run do
   pid_servidor = spawn(fn -> Servidor.escuchar() end)

  envio_local = %Envio{id: "TRX-101", tipo: "NACIONAL", distancia: 350, costo_base: 25}
  envio_global = %Envio{id: "TRX-202", tipo: "INTERNACIONAL", distancia: 1200, costo_base: 150}

  Cliente.solicitar_calculo(pid_servidor,envio_local)
  Cliente.solicitar_calculo(pid_servidor,envio_global)

  send(pid_servidor, :detener)
  :timer.sleep(100)




  end
  end
  Main.run()
