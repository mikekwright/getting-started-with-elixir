defmodule Mix.Tasks.ListTransactions do
  use Mix.Task

  @shortdoc "List transactions from csv file"
  def run(_) do
    Budget.list_transactions |> IO.inspect
  end
end

