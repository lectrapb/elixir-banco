defmodule TransportFactory do
  @moduledoc """
  Módulo para la creacion de una factoria para tipos de envio
  """

  @doc """
  Inicia el proceso de la factoria.
  """
  def start do
    # Inicia el factory
    spawn(fn -> loop() end)
  end


  @doc """
  Crea la factoria de tipos de transporte

  ## Parámetros
  - `type_transport`: Tipo de transporte para entrega
.
  """
  defp create_transport(type_transport) do
    case type_transport do

      "truck" ->
              IO.puts("create truck")
              {:deliver , "land"}
      "ship" ->
              IO.puts("create ship one")
              {:deliver , "earth"}
          _ ->
              IO.puts("create nothing")
              {:deliver , "nothing"}
    end
  end

  @doc """
  Cliente que consume la factoria

  ## Parámetros
  - `type_of_deliver`: Tipo de transporte para entrega
.
  """
  defp client_delivery_async(type_of_deliver) do

      {:deliver, value} = create_transport(type_of_deliver)
      IO.puts("Deliver by #{value} " )

 end

  @doc """
  Cliente que consume la factoria  de forma asincrona

  ## Parámetros
  - `factory_pid`: PID cliente que consume la factoria
  - `type_of_deliver`: Tipo de transporte para entrega
.
  """
  def create_delivery(factory_pid, type_of_deliver) do
    send(factory_pid, {:factory, type_of_deliver} )
  end


  @doc """
  Ciclo que esta atento a los llamados de clientes de la factoria
.
  """
  defp loop do
    receive do
      {:factory, type_of_deliver} ->
        IO.puts("new Factory")
        client_delivery_async(type_of_deliver)
        loop()
      _ ->
        IO.puts("No factory")
        loop()
    end
  end

end
