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

  # @header_receipt_and_payment_method [
  #   "Created Date",
  #   "Cashier Name",
  #   "Receipt Number",
  #   "Donor Name",
  #   "Payment Method",
  #   "Total Amount (RM)"
  # ]

  ## RECEIPTS AND CONTRIBUTIONS

  @header_receipt_and_contribution [
    "Created Date",
    "Receipt Number",
    "Donor Name",
    "Contribution for",
    "Payment Method",
    "Total Amount (RM)",
    "Remark"
  ]

  @header_financial_mass_offering [
    "Created Date",
    "Name",
    "Payment Method",
    "Total Amount (RM)"
  ]

  @header_financial_donation [
    "Created Date",
    "Name",
    "Payment Method",
    "Total Amount (RM)",
    "Intention"
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

  # def render("receipts_and_payment_methods.xlsx", %{receipts: receipts}) do
  #   report_generator_for_receipts_and_payment_methods(receipts)
  #   |> Elixlsx.write_to_memory("receipts_and_payment_methods.xlsx")
  #   |> elem(1)
  #   |> elem(1)
  # end

  def render("receipts_and_contributions.xlsx", %{receipt_items: receipt_items, total_payments: total_payments}) do
    report_generator_for_receipts(receipt_items, total_payments)
    |> Elixlsx.write_to_memory("receipts_and_contributions.xlsx")
    |> elem(1)
    |> elem(1)
  end

  def render("financial_mass_offerings.xlsx", %{mass_offerings: mass_offerings, total_payments: total_payments}) do
    report_generator_for_financial_mass_offerings(mass_offerings, total_payments)
    |> Elixlsx.write_to_memory("financial_mass_offerings.xlsx")
    |> elem(1)
    |> elem(1)
  end

  def render("financial_donations.xlsx", %{donations: donations, total_payments: total_payments}) do
    report_generator_for_financial_donations(donations, total_payments)
    |> Elixlsx.write_to_memory("financial_donations.xlsx")
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

  # defp report_generator_for_receipts_and_payment_methods(receipts) do
  #   rows =
  #     receipts
  #     |> Enum.map(&row_receipt_and_payment_method(&1))

  #   %Workbook{
  #     sheets: [
  #       %Sheet{
  #         name: "Receipts and Payment Methods",
  #         rows: [@header_receipt_and_payment_method] ++ rows
  #       }
  #     ]
  #   }
  # end

  defp report_generator_for_receipts(receipt_items, total_payments) do
    rows =
      receipt_items
      |> Enum.map(&row_receipt_and_contribution(&1))

    rows_total = 
      total_payments
      |> Enum.map(fn {payment_method, total} -> ["#{payment_method}", Decimal.to_float(total)] end)

    %Workbook{
      sheets: [
        %Sheet{
          name: "Receipts",
          rows: [@header_receipt_and_contribution] ++ rows ++ [''] ++ rows_total
        }
        |> Sheet.set_col_width("A", 30)
        |> Sheet.set_col_width("B", 20)
        |> Sheet.set_col_width("C", 20)
        |> Sheet.set_col_width("D", 20)
        |> Sheet.set_col_width("E", 20)
        |> Sheet.set_col_width("F", 20)
        |> Sheet.set_col_width("G", 50)
      ]
    }
  end

  defp report_generator_for_financial_mass_offerings(mass_offerings, total_payments) do
    rows =
      mass_offerings
      |> Enum.map(&row_financial_mass_offering(&1))

    rows_total = 
      total_payments
      |> Enum.map(fn {payment_method, total} -> ["#{payment_method}", Decimal.to_float(total)] end)

    %Workbook{
      sheets: [
        %Sheet{
          name: "Financial Mass Offerings",
          rows: [@header_financial_mass_offering] ++ rows ++ [''] ++ rows_total
        }
        |> Sheet.set_col_width("A", 30)
        |> Sheet.set_col_width("B", 20)
        |> Sheet.set_col_width("C", 20)
        |> Sheet.set_col_width("D", 20)
      ]
    }
  end

  defp report_generator_for_financial_donations(donations, total_payments) do
    rows =
      donations
      |> Enum.map(&row_financial_donations(&1))

    rows_total = 
      total_payments
      |> Enum.map(fn {payment_method, total} -> ["#{payment_method}", Decimal.to_float(total)] end)

    %Workbook{
      sheets: [
        %Sheet{
          name: "Financial Donations",
          rows: [@header_financial_donation] ++ rows ++ [''] ++ rows_total
        }
        |> Sheet.set_col_width("A", 30)
        |> Sheet.set_col_width("B", 20)
        |> Sheet.set_col_width("C", 20)
        |> Sheet.set_col_width("D", 20)
        |> Sheet.set_col_width("E", 30)
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
      to_mytz_format(donation.inserted_at),
      donation.contribution.name,
      donation.intention,
      Decimal.to_float(donation.contribution.amount)
    ]
  end

  # defp row_receipt_and_payment_method(receipt) do
  #   [
  #     to_mytz_format(receipt.inserted_at),
  #     receipt.user.name,
  #     receipt.receipt_number,
  #     receipt.donor_name,
  #     receipt.type_of_payment_method.name,
  #     Decimal.to_float(receipt.total_amount)
  #   ]
  # end

  defp row_receipt_and_contribution(receipt_item) do
    [
      to_mytz_format(receipt_item.receipt.inserted_at),
      receipt_item.receipt.receipt_number,
      receipt_item.receipt.donor_name,
      receipt_item.type_of_contribution.name,
      receipt_item.receipt.type_of_payment_method.name,
      Decimal.to_float(receipt_item.price),
      receipt_item.remark
    ]
  end

  defp row_financial_mass_offering(mass_offering) do
    [
      to_mytz_format(mass_offering.inserted_at),
      mass_offering.name,
      mass_offering.payment_method,
      Decimal.to_float(mass_offering.amount)
    ]
  end

  defp row_financial_donations(donation) do
    [
      to_mytz_format(donation.inserted_at),
      donation.name,
      donation.payment_method,
      Decimal.to_float(donation.amount),
      donation.donation.intention
    ]
  end

  # Convert to Malaysia Timezone & format
  def to_mytz_format(newdatetime) do
    { _, utc } = DateTime.from_naive(newdatetime, "Etc/UTC")
    utc
    |> Timex.Timezone.convert("Asia/Kuala_Lumpur")
    |> Timex.format!("%d.%m.%Y %H:%M:%S", :strftime)
  end

  def verified?(contribution) do
    if contribution.web_payment && contribution.web_payment.verified do
      "Success"
    else
      "Failed"
    end
  end

end
