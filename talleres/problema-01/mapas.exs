persona = %{
  nombre: "Victor",
  edad: 19,
  ciudad: "Armenia"
}
#Acceder
IO.puts(persona.nombre)

IO.inspect(Map.get(persona, :nombre))
IO.inspect(Map.delete(persona,:ciudad))

#modificar
usuario_actualizado = %{persona | edad: 15 }

IO.inspect(usuario_actualizado)

defmodule MapasEjemplo do
  def saludar(persona) do
    if persona.edad >= 18 do
    "Hola #{persona.nombre}, tienes #{persona.edad} años"
    else
      "No eres mayor de edad"
      end
    end
end

IO.puts(MapasEjemplo.saludar(persona))
