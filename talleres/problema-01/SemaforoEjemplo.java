import java.util.concurrent.Semaphore;

public class SemaforoEjemplo {

    // Semáforo con 2 permisos (máximo 2 hilos simultáneos)
    static Semaphore semaforo = new Semaphore(2);

    static class Tarea implements Runnable {
        private String nombre;

        Tarea(String nombre) {
            this.nombre = nombre;
        }

        @Override
        public void run() {
            try {
                System.out.println(nombre + " esperando permiso...");
                semaforo.acquire();  // Solicita un permiso
                System.out.println(nombre + " entrando a la sección crítica ✓");

                Thread.sleep(2000);  // Simula trabajo


                System.out.println(nombre + " saliendo de la sección crítica");
            } catch (InterruptedException e) {
                e.printStackTrace();
            } finally {
                semaforo.release();  // Libera el permiso
            }
        }
    }
    public static void main(String[] args) {
        // Lanzamos 5 hilos pero solo 2 pueden entrar a la vez
        for (int i = 1; i <= 5; i++) {
            new Thread(new Tarea("Hilo-" + i)).start();
        }
    }
}