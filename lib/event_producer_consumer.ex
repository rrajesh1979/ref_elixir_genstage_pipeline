defmodule EventProducerConsumer do
  @moduledoc """
  This module implements a producer-consumer queue.
  """
  use GenStage
  require Logger

  require Application
  @experian_endpoint Application.compile_env(:ref_elixir_genstage_pipeline, :experian_endpoint)

  def start_link(id) do
    initial_state = []
    GenStage.start_link(__MODULE__, initial_state, name: via(id))
  end

  def via(id) do
    {:via, Registry, {ProducerConsumerRegistry, id}}
  end

  def init(initial_state) do
    Logger.info("Event Producer Consumer init")

    subscription = [
      {EventProducer, min_demand: 1, max_demand: 3}
    ]

    {:producer_consumer, initial_state, subscribe_to: subscription}
  end

  def handle_events(events, from, state) do
    Logger.info("Event ProducerConsumer received #{inspect(events)} from #{inspect(from)}")

    new_events = Enum.map(events, &experian_check/1)
    Logger.info("Event ProducerConsumer transformed #{inspect(events)} to #{inspect(new_events)}")

    {:noreply, new_events, state}
  end

  def experian_check(request) do
    Logger.info("Request for Experian Check: #{inspect(request)}")

    api_response = HTTPoison.get!(@experian_endpoint)

    response =
      case api_response do
        %HTTPoison.Response{status_code: 200} ->
          %{
            request_id: request.request_id,
            request_type: "Experian Check",
            status_code: 200
          }

        _ ->
          %{
            request_id: request.request_id,
            request_type: "Experian Check",
            status_code: :error
          }
      end

    request_processed = %{
      request
      | status: "EXPERIAN_CHECK_DONE",
        activity_log: Enum.concat(request.activity_log, ["EXPERIAN_CHECK"])
    }

    request_processed
  end
end
