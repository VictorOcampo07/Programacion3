pid = spawn(fn -> IO.puts("Hola desde el proceso #{inspect(self())}")end)

IO.puts("PID del proceso: #{inspect(pid)}")
Process.alive?(pid)

1..5
|> Enum.map(fn i-> spawn(fn -> IO.puts("Proceso #{i} corriendo")end)end)
Process.sleep(100)
