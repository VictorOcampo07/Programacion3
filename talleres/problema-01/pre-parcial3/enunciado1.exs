defmodule Carrito.Item do
  @moduledoc """
  Estructura que representa un ítem dentro del carrito de compras.
  """
  @enforce_keys [:id, :nombre, :cantidad, :precio_unitario]
  defstruct [:id, :nombre, :cantidad, :precio_unitario]
end

defmodule Carrito do
  @moduledoc """
  Actor Carrito de Compras implementado mediante procesos puros de Elixir.
  Cumple estrictamente con el Modelo de Actores (estado aislado, paso de mensajes).
  """
  alias Carrito.Item

  # --- INTERFAZ DE INICIO ---

  @doc """
  Inicia el proceso del actor.
  Lee automáticamente el archivo CSV especificado para cargar el estado previo.
  """
  def start(archivo_csv \\ "carrito.csv") do
    spawn(fn ->
      items_iniciales = cargar_desde_csv(archivo_csv)
      loop(items_iniciales, archivo_csv)
    end)
  end

  # --- BUCLE DEL ACTOR (ESTADO PRIVADO) ---

  # El estado (lista de items) se mantiene vivo y privado a través de la recursión.
  defp loop(items, archivo_csv) do
    receive do
      {:agregar_item, %Item{} = nuevo_item} ->
        items_actualizados = agregar_o_sumar_item(items, nuevo_item)
        loop(items_actualizados, archivo_csv)

      {:quitar_item, id} ->
        items_actualizados = Enum.reject(items, &(&1.id == id))
        loop(items_actualizados, archivo_csv)

      {:total, pid} ->
        total = calcular_total(items)
        send(pid, {:respuesta_total, total})
        loop(items, archivo_csv)

      {:listar, pid} ->
        send(pid, {:respuesta_listar, items})
        loop(items, archivo_csv)

      :guardar_carrito ->
        guardar_en_csv(items, archivo_csv)
        loop(items, archivo_csv)

      :vaciar ->
        loop([], archivo_csv)

      :detener ->
        :ok
    end
  end

  # --- LÓGICA INTERNA DEL ESTADO ---

  defp agregar_o_sumar_item(items, nuevo_item) do
    if Enum.any?(items, &(&1.id == nuevo_item.id)) do
      Enum.map(items, fn item ->
        if item.id == nuevo_item.id do
          %{item | cantidad: item.cantidad + nuevo_item.cantidad}
        else
          item
        end
      end)
    else
      items ++ [nuevo_item]
    end
  end

  defp calcular_total(items) do
    Enum.reduce(items, 0, fn item, acc ->
      acc + (item.cantidad * item.precio_unitario)
    end)
  end

  # --- LÓGICA DE PERSISTENCIA (CSV) ---

  defp cargar_desde_csv(archivo) do
    case File.read(archivo) do
      {:ok, contenido} ->
        contenido
        |> String.split("\n", trim: true)
        |> Enum.drop(1) # Omitir la línea del encabezado
        |> Enum.map(&parsear_linea_csv/1)
        |> Enum.reject(&is_nil/1)

      {:error, _razon} ->
        [] # Si el archivo no existe, iniciamos con el carrito vacío
    end
  end

  defp parsear_linea_csv(linea) do
    case String.split(linea, ",") do
      [id, nombre, cantidad_str, precio_str] ->
        %Item{
          id: String.trim(id),
          nombre: String.trim(nombre),
          cantidad: String.to_integer(String.trim(cantidad_str)),
          # Soporta tanto enteros como decimales en el precio
          precio_unitario: parsear_numero(String.trim(precio_str))
        }

      _ ->
        nil
    end
  end

  defp parsear_numero(str) do
    case Float.parse(str) do
      {float, ""} -> float
      _ ->
        {int, _} = Integer.parse(str)
        int
    end
  end

  defp guardar_en_csv(items, archivo) do
    encabezado = "id,nombre,cantidad,precio"

    lineas =
      Enum.map(items, fn item ->
        "#{item.id},#{item.nombre},#{item.cantidad},#{item.precio_unitario}"
      end)

    contenido_completo = Enum.join([encabezado | lineas], "\n") <> "\n"
    File.write!(archivo, contenido_completo)
  end
end
