defmodule EventProducerConsumer do
  @moduledoc """
  This module implements a producer-consumer queue.
  """
  use GenStage
  require Logger

  def start_link(_args) do
    initial_state = []
    GenStage.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def init(initial_state) do
    Logger.info("Event Producer Consumer init")

    subscription = [
      {EventProducer, min_demand: 0, max_demand: 1}
    ]

    {:producer_consumer, initial_state, subscribe_to: subscription}
  end

  def handle_events(events, from, state) do
    Logger.info("Event ProducerConsumer received #{inspect(events)} from #{inspect(from)}")
    {:noreply, events, state}
  end
end
