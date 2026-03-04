mi_lista = [10, 20, 30, 20]
IO.puts("Lista inicial:          #{inspect(mi_lista)}")

resultado = ListaOps.agregar_inicio(mi_lista, 5)
IO.puts("Agregar 5 al inicio:    #{inspect(resultado)}")

resultado = ListaOps.agregar_final(mi_lista, 99)
IO.puts("Agregar 99 al final:    #{inspect(resultado)}")

resultado = ListaOps.revertir(mi_lista)
IO.puts("Lista revertdia:  #{inspect(resultado)}")

resultado = ListaOps.eliminar(mi_lista, 20)
IO.puts("Lista con el 20 eliminado : #{inspect(resultado)}")

resultado = Enum.sort(mi_lista, :desc)
IO.puts ("Lista ordenada: #{inspect(resultado)}")

personas =  [
  %{nombre: "Victor", edad: 19},
  %{nombre: "Juan", edad: 22},
  %{nombre: "Camila", edad: 74}
]

  resultado_mapa = Enum.sort_by(personas, fn p -> p.edad end)
  #imprime la edad en orden menor a mayor
  IO.puts(inspect(resultado_mapa))
  resultado_mapa = Enum.sort_by(personas, fn p -> p.edad end, :desc)
  #imprime en orden mayor a menor
  IO.inspect(resultado_mapa)
