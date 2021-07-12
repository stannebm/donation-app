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

  def report_generator(mass_offerings) do
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

  def row(mass_offering) do
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
    "Intention"
  ]

  def render("donations.xlsx", %{donations: donations}) do
    report_generator_for_donations(donations)
    |> Elixlsx.write_to_memory("donations.xlsx")
    |> elem(1)
    |> elem(1)
  end

  def report_generator_for_donations(donations) do
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

  def row_donation(donation) do
    [
      Timex.format!(donation.inserted_at, "%d.%m.%Y", :strftime),
      donation.contribution.name,
      donation.intention
    ]
  end

end
