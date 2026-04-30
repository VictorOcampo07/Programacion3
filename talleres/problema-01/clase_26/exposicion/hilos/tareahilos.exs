receptor = spawn(fn -> receive do
                  {:saludo, nombre} -> IO.puts("Hola,  #{nombre}!")
                  {:suma, a, b} -> IO.puts("Resultado: #{a + b}")
                  _ -> IO.puts("Mensaje deconocido")
                end
              end)

send(receptor,{:saludo, "Juliana"})
send(receptor,{:suma, 7, 3})
