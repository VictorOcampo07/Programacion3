defmodule Cliente do
defstruct nombre: "", edad: 0, altura: 0.0

def crear(nombre, edad, altura) do
  %Cliente{nombre: nombre, edad: edad, altura: altura}
end

def ingresar(mensaje) do
  Util.mostrar_mensaje(mensaje)
  nombre = "Ingrese nombre"|> Util.ingresar_texto()
  edad = "Ingrese su edad"|> Util.ingresar_entero(:entero)
  altura = "Ingrese su altura"|> Util.ingresar_real(:real)

  crear(nombre,edad,altura)
end

def ingresar(mensaje, :clientes) do
  mensaje
  |> ingresar([], :clientes)
end

defp ingresar(mensaje, lista, :clientes) do
  cliente =
    mensaje
    |> ingresar()
  nueva_lista = lista ++ [cliente]
  mas_clientes =
    "\nIngresar más clientes (s/n): "
    |> Util.ingresar(:boolean)

  case mas_clientes do
    true ->
      mensaje
      |> ingresar(nueva_lista, :clientes)
    false ->
      nueva_lista
    end
end

def escribir_csv(clientes, nombre) do
clientes
|> generar_mensaje_clientes(&convertir_cliente_linea_csv/1)
|> (&("nombre, edad, altura\n"<> &1)).() # adiciona los títulos
|> (&File.write(nombre, &1)).()
end

def generar_mensaje_clientes(lista_clientes, parser) do
lista_clientes
|> Enum.map(parser)
|> Enum.join("\n")
end

defp convertir_cliente_linea_csv(cliente) do
"#{cliente.nombre},#{cliente.edad}, #{cliente.altura}"
end


end
