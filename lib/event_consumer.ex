defmodule EventConsumer do
  @moduledoc """
  This module is used to consume events from the event queue.
  """
  require Logger

  def start_link(request) do
    Task.start_link(fn ->
      decision = credit_decision(request)

      Logger.info(
        "Credit Decision for : #{inspect(decision.request_id)} is : #{inspect(decision.status)}"
      )
    end)
  end

  def credit_decision(request) do
    Logger.info("Final decision on credit request: #{inspect(request)}")

    {credit_requested, _} = Integer.parse(request.credit_requested)
    Logger.info("Credit requested: #{inspect(credit_requested)}")

    final_decision =
      case {request.status, credit_requested} do
        {"EXPERIAN_CHECK_DONE", _}
        when credit_requested < 500_000 ->
          "APPROVED"

        {"EXPERIAN_CHECK_DONE", _}
        when credit_requested > 500_000 and credit_requested < 1_000_000 ->
          "EXCEPTION_REVIEW"

        _ ->
          "REJECTED"
      end

    request_processed = %{
      request
      | status: final_decision,
        activity_log: Enum.concat(request.activity_log, ["CREDIT_DECISION"])
    }

    request_processed
  end
end
