defmodule AtraccionParque do
  use GenServer

  # ---- API Pública ----

  def start_link(capacidad) do
    GenServer.start_link(__MODULE__, capacidad, name: __MODULE__)
  end

  # acquire: la persona intenta subir al carro
  def subir(persona) do
    GenServer.call(__MODULE__, {:subir, persona}, :infinity)
  end

  # release: la persona se baja y libera un asiento
  def bajar(persona) do
    GenServer.cast(__MODULE__, {:bajar, persona})
  end

  # ---- Callbacks ----

  @impl true
  def init(capacidad) do
    {:ok, %{asientos_libres: capacidad, fila: :queue.new()}}
  end

  # Hay asiento disponible -> sube de inmediato
  @impl true
  def handle_call({:subir, persona}, _from, %{asientos_libres: libres} = estado)
      when libres > 0 do
    IO.puts("🎢 #{persona} se sube al carro. Asientos libres: #{libres - 1}")
    {:reply, :ok, %{estado | asientos_libres: libres - 1}}
  end

  # No hay asientos -> se queda en la fila (no respondemos todavía)
  def handle_call({:subir, persona}, from, estado) do
    IO.puts("⏳ #{persona} se queda esperando en la fila...")
    nueva_fila = :queue.in({from, persona}, estado.fila)
    {:noreply, %{estado | fila: nueva_fila}}
  end

  # Alguien se baja -> revisamos si hay alguien esperando
  @impl true
  def handle_cast({:bajar, persona}, estado) do
    IO.puts("✅ #{persona} se baja del carro")

    case :queue.out(estado.fila) do
      # Hay alguien esperando: le damos el asiento que se liberó
      {{:value, {from, siguiente}}, fila_restante} ->
        IO.puts("🎢 Le toca a #{siguiente} (sale de la fila y sube)")
        GenServer.reply(from, :ok)
        {:noreply, %{estado | fila: fila_restante}}

      # Fila vacía: simplemente liberamos el asiento
      {:empty, _} ->
        {:noreply, %{estado | asientos_libres: estado.asientos_libres + 1}}
    end
  end
end

# Abrimos la atracción con capacidad para 8
AtraccionParque.start_link(8)

# Llegan 50 personas a la fila
for n <- 1..50 do
  Task.start(fn ->
    AtraccionParque.subir("Persona #{n}")
    :timer.sleep(2000)        # duración del recorrido
    AtraccionParque.bajar("Persona #{n}")
  end)
end

# Esperamos a que terminen todos
:timer.sleep(20_000)
