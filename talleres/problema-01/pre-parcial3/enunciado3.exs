# =====================================================================
# 1. DEFINICIÓN DEL STRUCT
# =====================================================================
defmodule Sensor do
  @moduledoc """
  Estructura de datos para representar la lectura de un sensor.
  """
  defstruct [:id, :zona, :temperaturas]
end

# =====================================================================
# 2. MÓDULO LOGICO Y CONCURRENTE
# =====================================================================
defmodule DataSensor do

  def procesar_sensor(%Sensor{temperaturas: []}) do
    {:ok, 0.0}
  end

  def procesar_sensor(%Sensor{temperaturas: temps}) do
    promedio = Enum.sum(temps) / length(temps)
    {:ok, promedio}
  end

  @doc """
  Procesa una lista de sensores de manera concurrente usando Task.
  """
  def analizar_concurrente(sensores) do
    sensores
    |> Enum.map(fn sensor ->
      Task.async(fn -> {:ok, promedio} = procesar_sensor(sensor)

        # Retornamos un mapa con los datos limpios
        %{id: sensor.id, zona: sensor.zona, promedio: promedio}
      end)
    end)
    |> Enum.map(&Task.await/1)
  end
end

# =====================================================================
# 3. MÓDULO DE EJECUCIÓN (Evita el error de contexto en scripts .exs)
# =====================================================================
defmodule Main do
  def run do
    # Simulamos la base de datos de sensores de la planta industrial
    sensores_planta = [
      %Sensor{id: "S-01", zona: "Calderas", temperaturas: [45.5, 46.0, 46.2, 45.8]},
      %Sensor{id: "S-02", zona: "Refrigeración", temperaturas: [2.0, 2.5, 2.1, 1.8]},
      %Sensor{id: "S-03", zona: "Embalaje", temperaturas: [22.0, 22.1, 21.9, 22.0]},
      %Sensor{id: "S-04", zona: "Hornos", temperaturas: [150.0, 155.0, 153.5, 152.0]},
      %Sensor{id: "S-05", zona: "Reactores", temperaturas: [80.0, 82.4, 81.1, 79.9]}
    ]

    IO.puts("==================================================")
    IO.puts("  Iniciando procesamiento concurrente DataSensor  ")
    IO.puts("==================================================")

    # Ejecutamos la función concurrente
    resultados = DataSensor.analizar_concurrente(sensores_planta)

    # Imprimimos el resultado final formateado en la consola
    IO.inspect(resultados, label: "Resultados del Análisis", syntax_colors: [number: :cyan, map: :green])

    IO.puts("==================================================")
    IO.puts("  Procesamiento finalizado con éxito.             ")
    IO.puts("==================================================")
  end
end


Main.run()
