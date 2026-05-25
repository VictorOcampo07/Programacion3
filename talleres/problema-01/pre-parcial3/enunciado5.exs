defmodule Producto do
  defstruct [:id, :nombre, :categoria, :precio, :stock, :fecha_ingreso]
end

defmodule Gestion do

  def registrar_producto(productos, id, nombre, categoria, precio, stock, fecha_ingreso) do
    nuevo_producto = %Producto{id: id, nombre: nombre, categoria: categoria, precio: precio, stock: stock, fecha_ingreso: fecha_ingreso}
   lista_actualizada = productos ++ [nuevo_producto]
   guardar_csv(lista_actualizada)
   lista_actualizada
  end

  def consultar_producto(productos, categoria) do
    productos
    |> Enum.map(fn producto ->
       Task.async(fn ->
        if producto.categoria == categoria, do: producto, else: nil end)
    end)

  |> Enum.map(&Task.await/1)
  |> Enum.reject(&is_nil/1)
  end

  def actualizar_stock(productos, id_producto, nuevo_stock) do
    lista_actualizada =
      productos
      |> Enum.map(fn producto ->
        Task.async(fn ->
          if producto.id  ==  id_producto do
         %{producto | stock: nuevo_stock}
       else
         producto
       end
      end)
    end)
    |> Enum.map(&Task.await/1)
    guardar_csv(lista_actualizada)
    lista_actualizada
  end

  def consultar_estado_inventario(productos) do
    total_articulos = Enum.sum(Enum.map(productos, & &1.stock))
    valor_total = Enum.sum(Enum.map(productos, fn p -> p.stock * p.precio end))

    {total_articulos, valor_total}
  end

  def guardar_csv(productos) do
  encabezado = "Código,Nombre,Categoría,Precio,Stock,Fecha Entrada\n"

    lineas =
      productos
      |> Enum.map(fn p ->
        "#{p.id},#{p.nombre},#{p.categoria},#{p.precio},#{p.stock},#{p.fecha_ingreso}"
      end)
      |> Enum.join("\n")

    File.write!("productos.csv", encabezado <> lineas)
  end

end

defmodule Main do
  def run do
    # Iniciamos con un inventario vacío
    inventario = []

    IO.puts("1. Registrando nuevos productos...")
    inventario = Gestion.registrar_producto(inventario, "P001", "Laptop Pro", "TECNOLOGIA", 1200.0, 10, "2026-05-20")
    inventario = Gestion.registrar_producto(inventario, "P002", "Teclado Mecánico", "TECNOLOGIA", 85.0, 25, "2026-05-20")
    inventario = Gestion.registrar_producto(inventario, "P003", "Escritorio Ergonómico", "MUEBLES", 300.0, 5, "2026-05-20")
    inventario = Gestion.registrar_producto(inventario, "P004", "Silla Gamer", "MUEBLES", 150.0, 15, "2026-05-20")
    inventario = Gestion.registrar_producto(inventario, "P005", "ASUS TUF", "TECNOLOGIA", 30000, 10, "2026-05-20")

    IO.puts("\n2. Consultando productos de la categoría 'TECNOLOGIA' de manera concurrente:")
    tecnologia = Gestion.consultar_producto(inventario, "TECNOLOGIA")
    IO.inspect(tecnologia)

    IO.puts("\n3. Actualizando el stock del producto P001 (Venta o reposición)...")
    inventario = Gestion.actualizar_stock(inventario, "P001", 8) # Bajó de 10 a 8

    IO.puts("\n4. Consultando el estado global del inventario:")
    {total_items, valor_total} = Gestion.consultar_estado_inventario(inventario)
    IO.puts(" -> Total de productos físicos disponibles: #{total_items} unidades.")
    IO.puts(" -> Valor financiero total del inventario: $#{valor_total}")

    IO.puts("\n¡Listo! Revisa tu carpeta del proyecto, verás el archivo 'productos.csv' creado y actualizado.")
  end
end

Main.run()
