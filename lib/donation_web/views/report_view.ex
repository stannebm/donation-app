defmodule DonationWeb.ReportView do
  use DonationWeb, :view

  alias Elixlsx.{Workbook, Sheet}

  ## MASS OFFERING: EXPORT EXCEL

  @header [
    "Type",
    "Mass Language",
    "Type of Mass",
    "From Whom",
    "Intention"
  ]

  def render("mass_intention.xlsx", %{mass_offerings: mass_offerings}) do
    report_generator(mass_offerings)
    |> Elixlsx.write_to_memory("mass_intention.xlsx")
    |> elem(1)
    |> elem(1)
  end

  defp report_generator(mass_offerings) do
    rows =
      mass_offerings
      |> Enum.map(&row(&1))

    %Workbook{
      sheets: [
        %Sheet{
          name: "Mass Intention",
          rows: [@header] ++ rows
        }
      ]
    }
  end

  defp row(mass_offering) do
    [
      mass_offering.contribution.type,
      mass_offering.mass_language,
      mass_offering.type_of_mass,
      mass_offering.contribution.name,
      mass_offering.intention
    ]
  end

  ## DONATION: EXPORT EXCEL

  @header_donations [
    "Created Date",
    "From Whom",
    "Intention",
    "Amount (RM)"
  ]

  def render("donations.xlsx", %{donations: donations}) do
    report_generator_for_donations(donations)
    |> Elixlsx.write_to_memory("donations.xlsx")
    |> elem(1)
    |> elem(1)
  end

  defp report_generator_for_donations(donations) do
    rows =
      donations
      |> Enum.map(&row_donation(&1))

    %Workbook{
      sheets: [
        %Sheet{
          name: "Donations",
          rows: [@header_donations] ++ rows
        }
      ]
    }
  end

  defp row_donation(donation) do
    [
      Timex.format!(donation.inserted_at, "%d.%m.%Y", :strftime),
      donation.contribution.name,
      donation.intention,
      Decimal.to_string(donation.contribution.amount)
    ]
  end

  ## RECEIPTS AND PAYMENT METHODS

  @header_receipt_and_payment_method [
    "Created Date",
    "Cashier Name",
    "Receipt Number",
    "Donor Name",
    "Payment Method",
    "Total Amount (RM)"
  ]

  def render("receipts_and_payment_methods.xlsx", %{receipts: receipts}) do
    report_generator_for_receipts_and_payment_methods(receipts)
    |> Elixlsx.write_to_memory("receipts_and_payment_methods.xlsx")
    |> elem(1)
    |> elem(1)
  end

  defp report_generator_for_receipts_and_payment_methods(receipts) do
    rows =
      receipts
      |> Enum.map(&row_receipt_and_payment_method(&1))

    %Workbook{
      sheets: [
        %Sheet{
          name: "Receipts and Payment Methods",
          rows: [@header_receipt_and_payment_method] ++ rows
        }
      ]
    }
  end

  defp row_receipt_and_payment_method(receipt) do
    [
      Timex.format!(receipt.inserted_at, "%d.%m.%Y", :strftime),
      receipt.user.name,
      receipt.receipt_number,
      receipt.donor_name,
      receipt.type_of_payment_method.name,
      Decimal.to_string(receipt.total_amount)
    ]
  end

end
