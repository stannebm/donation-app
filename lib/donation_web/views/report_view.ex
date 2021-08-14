defmodule DonationWeb.ReportView do
  use DonationWeb, :view

  alias Elixlsx.{Workbook, Sheet}

  ## MASS OFFERING

  @header [
    "Type",
    "Mass Language",
    "Type of Mass",
    "From Whom",
    "Intention"
  ]

  ## DONATION

  @header_donations [
    "Created Date",
    "From Whom",
    "Intention",
    "Amount (RM)"
  ]

  ## RECEIPTS AND PAYMENT METHODS

  @header_receipt_and_payment_method [
    "Created Date",
    "Cashier Name",
    "Receipt Number",
    "Donor Name",
    "Payment Method",
    "Total Amount (RM)"
  ]

  ## RECEIPTS AND CONTRIBUTIONS

  @header_receipt_and_contribution [
    "Created Date",
    "Receipt Number",
    "Donor Name",
    "Contribution for",
    "Total Amount (RM)",
    "Remark"
  ]

  def render("mass_intention.xlsx", %{mass_offerings: mass_offerings}) do
    report_generator(mass_offerings)
    |> Elixlsx.write_to_memory("mass_intention.xlsx")
    |> elem(1)
    |> elem(1)
  end

  def render("donations.xlsx", %{donations: donations}) do
    report_generator_for_donations(donations)
    |> Elixlsx.write_to_memory("donations.xlsx")
    |> elem(1)
    |> elem(1)
  end

  def render("receipts_and_payment_methods.xlsx", %{receipts: receipts}) do
    report_generator_for_receipts_and_payment_methods(receipts)
    |> Elixlsx.write_to_memory("receipts_and_payment_methods.xlsx")
    |> elem(1)
    |> elem(1)
  end

  def render("receipts_and_contributions.xlsx", %{receipt_items: receipt_items}) do
    report_generator_for_receipts_and_contributions(receipt_items)
    |> Elixlsx.write_to_memory("receipts_and_contributions.xlsx")
    |> elem(1)
    |> elem(1)
  end

  ## PROTECTED

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

  defp report_generator_for_receipts_and_contributions(receipt_items) do
    rows =
      receipt_items
      |> Enum.map(&row_receipt_and_contribution(&1))

    %Workbook{
      sheets: [
        %Sheet{
          name: "Receipts and Contributions",
          rows: [@header_receipt_and_contribution] ++ rows
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

  defp row_donation(donation) do
    [
      Timex.format!(donation.inserted_at, "%d.%m.%Y", :strftime),
      donation.contribution.name,
      donation.intention,
      Decimal.to_float(donation.contribution.amount)
    ]
  end

  defp row_receipt_and_payment_method(receipt) do
    [
      Timex.format!(receipt.inserted_at, "%d.%m.%Y", :strftime),
      receipt.user.name,
      receipt.receipt_number,
      receipt.donor_name,
      receipt.type_of_payment_method.name,
      Decimal.to_float(receipt.total_amount)
    ]
  end

  defp row_receipt_and_contribution(receipt_item) do
    [
      Timex.format!(receipt_item.inserted_at, "%d.%m.%Y", :strftime),
      receipt_item.receipt.receipt_number,
      receipt_item.receipt.donor_name,
      receipt_item.type_of_contribution.name,
      Decimal.to_float(receipt_item.price),
      receipt_item.remark
    ]
  end

end
