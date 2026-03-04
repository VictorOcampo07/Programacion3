lista = [1, 2, 3, 45745, 5,87,876,765,654,7654,8765,654,6,4,3,2,56,8,0,7,5,2,5,7,8,5,3,45,7,9,6,3,3,6,8988,7,4,4,7,9,6,4,6,]
[primero | resto] = lista
[uno,dos,tres,cuatro,cinco | resto_cinco] = lista

resultado = Enum.at(lista, 24)
IO.puts(resultado)
IO.puts(inspect(resto))
IO.puts(inspect(cuatro))

indice = Enum.find_index(lista, fn x -> x == 8988 end)
IO.puts(indice)
