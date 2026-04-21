Code.require_file("../../util.ex", __DIR__)

defmodule App do
  @moduledoc """
  Juego para consola con CRUD aplicando listas, tuplas y mapas.
  """
  def contratar_empleado(empresa) do
    nombre = Util.ingresar_texto("Nombre del empleado: ")
    cargo = Util.ingresar_texto("Cargo (ej. Desarrollador, Analista, Ventas): ")

    #Mapa para representar al empleado
      nuevo_empleado  = %{
        id: empresa.proximo_id,
        nombre: nombre,
        cargo: cargo,
        habilidades: []
      }

    nuevos_empleados = [nuevo_empleado | empresa.empleados]

    nuevo_estado = {:ok, "Empleado #{nombre} contratado exitosamente"}

    #se actualiza el mapa de la empresa
    %{
      empresa
      |empleados: nuevos_empleados,
      proximo_id: empresa.proximo_id + 1,
      estado: nuevo_estado
    }
  end

  def listar_empleados(empresa) do
    Util.mostrar_mensaje("\n---Nómina de empleados---")

    if empresa.empleados == [] do
      Util.mostrar_mensaje("La empresa aún no tiene empleados registrados")
    else
      #Enum.each para recorrer la lista de mapas
      Enum.each(empresa.empleados, fn emp ->
        Util.mostrar_mensaje("[ID: #{emp.id} |Nombre: #{emp.nombre} | Cargo: #{emp.cargo}")

        if length(emp.habilidades) > 0 do
        Util.mostrar_mensaje(" | Habilidades: #{Enum.join(emp.habilidades, ", ")}")
        end
      end)
    end

    #patter maching para extraer el estado
      {status, mensaje} = empresa.estado
        Util.mostrar_mensaje("\n>> Estado actual: #{mensaje} (#{status})")
        empresa
    end

    def capacitar_empleado(empresa) do
      id_str = Util.ingresar_entero("Ingrese el ID del empleado para capacitar: ", :entero)

      empleado_existe = Enum.any?(empresa.empleados, fn e -> e.id == id_str end)

      if empleado_existe do
        nueva_hab = Util.ingresar_texto("Nueva habilidad (ej. Elixir, Phyton, Java): ")

        empleados_actualizados = Enum.map(empresa.empleados, fn emp ->
          if emp.id == id_str do
            %{emp | habilidades: [nueva_hab | emp.habilidades]}
          else
            emp
          end
        end)

        %{
          empresa
          |empleados: empleados_actualizados,
          estado: {:ok, "Empleado ID #{id_str} capacitado con exito"}
        }
      else
        Util.mostrar_mensaje("No se encontro ningun empleado con ese ID.")
        %{empresa | estado: {:error, "Intento fallido de capacitación"}}
      end
    end

    def despedir_empleado(empresa) do
      id_str = Util.ingresar_entero("Ingrese el ID del empleado a dar de baja: ", :entero)

      #Se filtra la lista conservando los que no conciden con el id_str
      empleados_restantes = Enum.filter(empresa.empleados, fn emp -> emp.id != id_str end)

      if length(empleados_restantes) == length(empresa.empleados) do
        Util.mostrar_mensaje("No se encontro el empleado")
        %{empresa | estado: {:error, "ID no válido para despedir"}}
      else
        Util.mostrar_mensaje("Empleado dado de baja del sistema")
        %{empresa | estado: {:ok, "Empleado eliminado del sistema"}}
      end
    end

    def main do

      estado_inicial = %{
        nombre: "ScaleLabs",
        empleados: [],
        proximo_id: 1,
        estado: {:ok, "Sistema de recursos humanos inciado"}
      }

      Util.mostrar_mensaje("______________________________________________")
      Util.mostrar_mensaje("BIENVENIDO A #{String .upcase(estado_inicial.nombre)}")
      Util.mostrar_mensaje("______________________________________________")

      loop(estado_inicial)
    end

    #Al no haber while o for se usa loop como recurso funcional
    defp loop(empresa) do
      Util.mostrar_mensaje("""
      \nMenú Principal
      1. Contratar empleado
      2. Ver nómina
      3. Capacitar empleado
      4. Dar de baja a un empleado
      5. Salir
      """)

      opcion = Util.ingresar_entero("Ingrese una opcion: ", :entero)

      datos_empresa =
        case opcion do
          1 -> contratar_empleado(empresa)
          2 -> listar_empleados(empresa)
          3 -> capacitar_empleado(empresa)
          4 -> despedir_empleado(empresa)
          5 -> :salir
          _ -> Util.mostrar_mensaje("Opcion no valida")
          empresa
        end

        if datos_empresa == :salir do
          Util.mostrar_mensaje("Apagando el sistema...")
        else
          loop(datos_empresa)
        end
      end
    end


App.main()
