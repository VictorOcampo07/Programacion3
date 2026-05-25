defmodule Carrera do
  @meta 50 #longitud de la pista


  def iniciar do
     IO.puts("\e[H\e[2J") #comando para limpiar la terminal
     IO.puts("¡PREPARADOS, LISTOS, YA! \n")
     Process.sleep(1000)


     competidores = [
      {"Corredor 1", "🐷"},
      {"Corredor 2", "🐽"},
      {"Corredor 3", "🐗"},
      {"Corredor 4", "🐖"}
     ]

     pid_pista = self()

     estado_inicial = Map.new(competidores, fn {nombre, emoji} ->
      pid = spawn(fn -> correr(nombre, pid_pista)end)
      {nombre, %{emoji: emoji, posicion: 0, pid: pid}}end)

      loop_pista(estado_inicial)
  end

  defp correr(nombre, pid_pista) do
    receive do
      :detener -> :ok
    after 0 ->
      Process.sleep(Enum.random(100..500))
      pasos = Enum.random(1..3)
      send(pid_pista, {:avance, nombre, pasos})
      correr(nombre, pid_pista)
    end
  end

  defp loop_pista(estado) do
    receive do
      {:avance, nombre, pasos} ->
        datos_cerdito = Map.get(estado, nombre)
        nueva_posicion = datos_cerdito.posicion + pasos
        estado_actualizado = Map.put(estado, nombre,%{datos_cerdito | posicion: nueva_posicion})
        dibujar_pista(estado_actualizado)

        if nueva_posicion >= @meta do
          IO.puts("¡¡EL GANADOR ES EL #{String.upcase(nombre)}!!")
          detener_competidores(estado_actualizado)
        else
          loop_pista(estado_actualizado)
        end
    end
  end

  defp dibujar_pista(estado) do
    IO.puts("\e[H\e[2J")
    IO.puts("GRAN CARRERA DE CERDITOS \n")
    estado
      |> Enum.sort()
      |>Enum.each( fn {nombre, datos} ->
        posicion_segura = min(datos.posicion, @meta)
        espacios_recorridos = String.duplicate(" ",posicion_segura)
        distancia_restante = String.duplicate("-", @meta - posicion_segura)
        IO.puts("#{espacios_recorridos}#{datos.emoji}#{distancia_restante}| META (#{nombre})")
      end)
  end

  defp detener_competidores(estado) do
    Enum.each(estado, fn {_nombre, datos} ->
      send(datos.pid, :detener)
    end)
  end
end

Carrera.iniciar()
