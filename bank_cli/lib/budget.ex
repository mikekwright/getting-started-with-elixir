defmodule Budget do
  alias NimbleCSV.RFC4180, as: CSV

  def list_transactions do
    File.read!("lib/transactions.csv")
      |> parse
      |> filter
      |> normalize
      |> sort
      |> print
  end

  defp parse(string) do
    String.replace(string, "\r", "")
      |> CSV.parse_string
  end

  defp filter(rows) do
    # -> longer fn = Enum.map(rows, fn(row) -> Enum.drop(row, 1) end)
    Enum.map(rows, &Enum.drop(&1, 1))
  end

  defp normalize(rows) do
    Enum.map(rows, &parse_amount(&1))
  end

  defp parse_amount([date, description, amount]) do
    [date, description, parse_to_float(amount)]
  end

  defp parse_to_float(amount) do
    String.to_float(amount)
      |> abs
  end

  defp sort(rows) do
    # -> inline fun = Enum.sort(rows, fn([_, _, l], [_, _, r]) -> l < r end)
    Enum.sort(rows, &sort_asc_by_amount(&1, &2))
  end

  defp sort_asc_by_amount([_, _, l], [_, _, r]) do
    l < r
  end

  defp print(rows) do
    IO.puts "transactions: "
    Enum.each(rows, &print_row(&1))
  end

  defp print_row([date, desc, amount]) do
    IO.puts "  #{String.ljust(date, 10)} #{String.ljust(desc, 15)} $#{format_amount(amount)}"
  end

  defp format_amount(amount) do
    :erlang.float_to_binary(amount, decimals: 2)
  end

  # def hello do
  #  :world
  # end

end
