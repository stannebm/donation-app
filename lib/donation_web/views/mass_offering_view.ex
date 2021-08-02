defmodule DonationWeb.MassOfferingView do
  @moduledoc """
  ## For Admin data entry, the Mass Offering without payment
  """
  use DonationWeb, :view

  alias Donation.Admins
  alias Donation.Revenue.{Contribution, MassOffering}

  def link_to_mass_offering_fields do
    changeset =
      Admins.change_mass_offering_by_contributor(%Contribution{mass_offerings: [%MassOffering{}]})

    form = Phoenix.HTML.FormData.to_form(changeset, [])
    fields = render_to_string(__MODULE__, "mass_offering_fields.html", f: form)

    link("Add Offering",
      to: "#",
      "data-template": fields,
      id: "add_offering",
      class: "button is-primary"
    )
  end

  def check_verified(contribution) do
    if contribution.payment_method == "fpx" || contribution.payment_method == "cybersource" do
      if contribution.web_payment && contribution.web_payment.verified do
        "Success"
      else
        "Failed"
      end
    end
  end

  def parse_array_dates(dates) do
    dates
    |> Enum.map(fn date -> 
        Timex.format!(date, "%d.%m.%Y", :strftime)
       end)
    |> Enum.join(", ")
  end

end
