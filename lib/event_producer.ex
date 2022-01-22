defmodule EventProducer do
  @moduledoc """
  This module provides a simple event producer.
  """
  use GenStage
  require Logger

  def start_link(_args) do
    Logger.info("EventProducer start_link")
    initial_state = []
    GenStage.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def init(initial_state) do
    Logger.info("EventProducer init")
    {:producer, initial_state}
  end

  def handle_demand(demand, state) do
    Logger.info("EventProducer received demand for #{demand} records")
    events = []
    {:noreply, events, state}
  end

  def process_data(data_records) when is_list(data_records) do
    GenStage.cast(__MODULE__, {:data_records, data_records})
  end

  def handle_cast({:data_records, data_records}, state) do
    {:noreply, data_records, state}
  end
end
