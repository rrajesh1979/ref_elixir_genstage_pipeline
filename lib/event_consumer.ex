defmodule EventConsumer do
  @moduledoc """
  This module is used to consume events from the event queue.
  """
  require Logger

  def start_link(request) do
    Logger.info("EventConsumer received #{request.request_id}")

    Task.start_link(fn ->
      Logger.info("EventConsumer doing work!!")
    end)
  end
end
