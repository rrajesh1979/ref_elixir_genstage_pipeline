defmodule EventProducer do
  @moduledoc """
  This module provides a simple event producer.
  """
  use GenStage
  require Logger

  alias NimbleCSV.RFC4180, as: CSV

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

  def produce_events(file_path) do
    read_file(file_path)
    |> parse_rows
    |> Enum.map(&process_data([&1]))
  end

  def process_data(data_records) when is_list(data_records) do
    GenStage.cast(__MODULE__, {:data_records, data_records})
  end

  def handle_cast({:data_records, data_records}, state) do
    {:noreply, data_records, state}
  end

  def read_file(file_path) do
    file_path
    |> File.read!()
  end

  def parse_rows(row) do
    row
    |> CSV.parse_string()
    |> Enum.map(fn row ->
      %{
        request_id: Enum.at(row, 0),
        name: Enum.at(row, 1),
        credit_requested: Enum.at(row, 2),
        requested_date: Enum.at(row, 3),
        location: Enum.at(row, 4),
        status: "NEW_REQUEST",
        activity_log: ["REQUEST_CREATED"]
      }
    end)
  end
end

# Commands
# data = ["record 1", "record 2", "record 3", "record 4", "record 5", "record 6", "record 7", "record 8", "record 9", "record 10"]
# EventProducer.process_data(data)

# file_path = "/Users/rajesh/Learn/elixir/ref_elixir_genstage_pipeline/priv/data/data_1.csv"
# EventProducer.produce_events(file_path)
