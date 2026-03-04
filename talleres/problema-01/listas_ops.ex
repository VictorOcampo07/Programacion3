defmodule ListaOps do
  @moduledoc """
  Módulo para manipulación de listas en Elixir.
  Cubre operaciones básicas y avanzadas.
  """

  # ─────────────────────────────────────────
  # 1. OPERACIONES BÁSICAS
  # ─────────────────────────────────────────

  @doc "Agrega un elemento al inicio de la lista"
  def agregar_inicio(lista, elemento), do: [elemento | lista]

  @doc "Agrega un elemento al final de la lista"
  def agregar_final(lista, elemento), do: lista ++ [elemento]

  @doc "Elimina la primera ocurrencia de un elemento"
  def eliminar(lista, elemento), do: List.delete(lista, elemento)

  @doc "Revierte la lista"
  def revertir(lista), do: Enum.reverse(lista)

  @doc "Ordena la lista"
  def ordenar(lista), do: Enum.sort(lista)

  @doc "Concatena dos listas"
  def concatenar(l1, l2), do: l1 ++ l2

  # ─────────────────────────────────────────
  # 2. BÚSQUEDA Y FILTRADO
  # ─────────────────────────────────────────

  @doc "Filtra elementos que cumplen una condición"
  def filtrar(lista, condicion), do: Enum.filter(lista, condicion)

  @doc "Verifica si un elemento existe en la lista"
  def contiene?(lista, elemento), do: Enum.member?(lista, elemento)

  @doc "Devuelve el máximo y mínimo"
  def max_min(lista), do: {Enum.max(lista), Enum.min(lista)}

  # ─────────────────────────────────────────
  # 3. TRANSFORMACIONES
  # ─────────────────────────────────────────

  @doc "Aplica una función a cada elemento (map)"
  def transformar(lista, funcion), do: Enum.map(lista, funcion)

  @doc "Reduce la lista a un solo valor"
  def reducir(lista, inicial, funcion), do: Enum.reduce(lista, inicial, funcion)

  @doc "Suma todos los elementos numéricos"
  def suma(lista), do: Enum.sum(lista)

  @doc "Promedio de una lista numérica"
  def promedio(lista) do
    Enum.sum(lista) / length(lista)
  end

  @doc "Elimina duplicados"
  def sin_duplicados(lista), do: Enum.uniq(lista)

  @doc "Aplana una lista de listas"
  def aplanar(lista), do: List.flatten(lista)

  @doc "Divide la lista en grupos de n elementos"
  def dividir_en(lista, n), do: Enum.chunk_every(lista, n)

  @doc "Comprime dos listas en tuplas"
  def comprimir(l1, l2), do: Enum.zip(l1, l2)

  # ─────────────────────────────────────────
  # 4. OPERACIONES CON PATTERN MATCHING
  # ─────────────────────────────────────────

  @doc "Obtiene la cabeza y la cola de la lista"
  def cabeza_cola([]), do: {:error, "Lista vacía"}
  def cabeza_cola([h | t]), do: {:ok, h, t}

  @doc "Cuenta elementos de forma recursiva"
  def contar([]), do: 0
  def contar([_h | t]), do: 1 + contar(t)

  @doc "Suma recursiva"
  def suma_recursiva([]), do: 0
  def suma_recursiva([h | t]), do: h + suma_recursiva(t)

  @doc "Búsqueda del n-ésimo elemento (base 0)"
  def en_posicion(lista, pos), do: Enum.at(lista, pos)
end

# ─────────────────────────────────────────
# DEMO: Ejemplos de uso
# ─────────────────────────────────────────
defmodule Demo do
  def ejecutar do
    IO.puts("====== MANIPULACIÓN DE LISTAS EN ELIXIR ======\n")

    lista = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3]
    IO.puts("Lista original: #{inspect(lista)}")

    IO.puts("\n--- Operaciones básicas ---")
    IO.puts("Agregar 0 al inicio: #{inspect(ListaOps.agregar_inicio(lista, 0))}")
    IO.puts("Agregar 99 al final: #{inspect(ListaOps.agregar_final(lista, 99))}")
    IO.puts("Eliminar primera '5': #{inspect(ListaOps.eliminar(lista, 5))}")
    IO.puts("Revertir: #{inspect(ListaOps.revertir(lista))}")
    IO.puts("Ordenar: #{inspect(ListaOps.ordenar(lista))}")

    IO.puts("\n--- Búsqueda y filtrado ---")
    pares = ListaOps.filtrar(lista, fn x -> rem(x, 2) == 0 end)
    IO.puts("Solo pares: #{inspect(pares)}")
    IO.puts("¿Contiene 9?: #{ListaOps.contiene?(lista, 9)}")
    {max, min} = ListaOps.max_min(lista)
    IO.puts("Máximo: #{max}, Mínimo: #{min}")

    IO.puts("\n--- Transformaciones ---")
    duplicados = ListaOps.transformar(lista, fn x -> x * 2 end)
    IO.puts("Cada elemento x2: #{inspect(duplicados)}")
    IO.puts("Suma total: #{ListaOps.suma(lista)}")
    IO.puts("Promedio: #{ListaOps.promedio(lista)}")
    IO.puts("Sin duplicados: #{inspect(ListaOps.sin_duplicados(lista))}")
    IO.puts("Grupos de 3: #{inspect(ListaOps.dividir_en(lista, 3))}")

    IO.puts("\n--- Aplanar lista anidada ---")
    anidada = [[1, 2], [3, [4, 5]], [6]]
    IO.puts("Lista anidada: #{inspect(anidada)}")
    IO.puts("Aplanada: #{inspect(ListaOps.aplanar(anidada))}")

    IO.puts("\n--- Pattern Matching ---")
    {:ok, cabeza, cola} = ListaOps.cabeza_cola(lista)
    IO.puts("Cabeza: #{cabeza}")
    IO.puts("Cola: #{inspect(cola)}")
    IO.puts("Contar (recursivo): #{ListaOps.contar(lista)}")
    IO.puts("Suma recursiva: #{ListaOps.suma_recursiva(lista)}")
    IO.puts("Elemento en posición 4: #{ListaOps.en_posicion(lista, 4)}")

    IO.puts("\n--- Zip de dos listas ---")
    nombres = ["Ana", "Luis", "María"]
    edades  = [28, 34, 22]
    IO.puts("Zip nombres+edades: #{inspect(ListaOps.comprimir(nombres, edades))}")

    IO.puts("\n====== FIN ======")
  end
end

Demo.ejecutar()
