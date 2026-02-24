defmodule Util do
  @moduledoc """
  Funciones utilitarias compartidas.
  """

  def mostrar_mensaje(mensaje) do
    mensaje
    |> IO.puts()
  end

  def mostrar_mensaje_java(mensaje) do
    System.cmd("java", ["-cp", ".", "Mensaje", mensaje])
  end

 def ingresar_texto(mensaje) do
  valor =
    mensaje
    |> IO.gets()
    |> String.trim()

  if Regex.match?(~r/^\d+$/, valor) do
    "Error, se espera ingresar texto, no números\n"
    |> mostrar_error()
    mensaje
    |> ingresar_texto()
  else
    valor
  end
end

  def ingresar_entero(mensaje, :entero) do
    mensaje
    |> IO.gets()
    |> String.trim()
    |> String.to_integer()
  rescue
    ArgumentError ->
      "Error, se espera que ingrese un número entero\n"
      |>mostrar_error()
      mensaje
      |> ingresar_entero(:entero)
  end

  def mostrar_error(mensaje) do
    IO.puts(:standard_error,mensaje)
  end

  def ingresar_real(mensaje, :real) do
    mensaje
    |> IO.gets()
    |> String.trim()
    |> String.to_float()
  rescue
    ArgumentError ->
      "ERROR, se espera un numero real \n"
      |>mostrar_error()
      mensaje
      |> ingresar_real(:real)
  end

  def ingresar_booleano(mensaje, :booleano) do
  valor =
    mensaje
    |> IO.gets()
    |> String.trim()
    |> String.downcase()

  case valor do
    "true" -> true
    "false" -> false
    _ ->
      "Error, se espera ingresar true o false\n"
      |> mostrar_error()
      mensaje
      |> ingresar_booleano(:booleano)
  end
end
end
