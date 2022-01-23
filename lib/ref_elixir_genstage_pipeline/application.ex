defmodule RefElixirGenstagePipeline.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: RefElixirGenstagePipeline.Worker.start_link(arg)
      # {RefElixirGenstagePipeline.Worker, arg}
      {Registry, keys: :unique, name: ProducerConsumerRegistry},
      EventProducer,
      # EventProducerConsumer,
      producer_consumer_spec(id: 1),
      producer_consumer_spec(id: 2),
      producer_consumer_spec(id: 3),
      EventConsumerSupervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RefElixirGenstagePipeline.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def producer_consumer_spec(id: id) do
    id = "event_producer_consumer_#{id}"
    Supervisor.child_spec({EventProducerConsumer, id}, id: id)
  end
end
