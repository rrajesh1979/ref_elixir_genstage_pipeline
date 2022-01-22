defmodule RefElixirGenstagePipeline do
  @moduledoc """
  Documentation for `RefElixirGenstagePipeline`.
  """

  require Logger
  alias NimbleCSV.RFC4180, as: CSV

  require Application
  @experian_endpoint Application.compile_env(:ref_elixir_genstage_pipeline, :experian_endpoint)
  @equifax_endpoint Application.compile_env(:ref_elixir_genstage_pipeline, :equifax_endpoint)
  @aml_check_endpoint Application.compile_env(:ref_elixir_genstage_pipeline, :aml_check_endpoint)
  @fraud_check_endpoint Application.compile_env(
                          :ref_elixir_genstage_pipeline,
                          :fraud_check_endpoint
                        )
  @account_balance_endpoint Application.compile_env(
                              :ref_elixir_genstage_pipeline,
                              :account_balance_endpoint
                            )

  @doc """
  Hello world.

  ## Examples

      iex> RefElixirGenstagePipeline.hello()
      :world

  """
  def hello do
    :world
  end
end
