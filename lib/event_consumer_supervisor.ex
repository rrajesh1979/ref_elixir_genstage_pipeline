defmodule EventConsumerSupervisor do
  @moduledoc """
  This module is responsible for managing the event consumers.
  """
  use ConsumerSupervisor
  require Logger

  def start_link(_args) do
    ConsumerSupervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    Logger.info("EventConsumerSupervisor init")

    children = [
      %{
        id: EventConsumer,
        start: {EventConsumer, :start_link, []},
        restart: :transient
      }
    ]

    opts = [
      strategy: :one_for_one,
      subscribe_to: [
        {EventProducerConsumer.via("event_producer_consumer_1"), []},
        {EventProducerConsumer.via("event_producer_consumer_2"), []},
        {EventProducerConsumer.via("event_producer_consumer_3"), []}
      ]
    ]

    ConsumerSupervisor.init(children, opts)
  end
end
