defmodule EventConsumer do
  @moduledoc """
  This module is used to consume events from the event queue.
  """
  require Logger

  def start_link(event) do
    Logger.info("EventConsumer received #{event}")

    Task.start_link(fn ->
      Logger.info("EventConsumer doing work!!")
    end)
  end
end
