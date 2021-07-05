defmodule DonationWeb.MassOfferingView do
  @moduledoc """
  ## For Admin data entry, the Mass Offering without payment
  """
  use DonationWeb, :view

  alias Donation.Admins
  alias Donation.Revenue.{Contribution, MassOffering}

  def link_to_mass_offering_fields do
    changeset = Admins.change_mass_offering_by_contributor(%Contribution{mass_offerings: [%MassOffering{}]})
    form = Phoenix.HTML.FormData.to_form(changeset, [])
    fields = render_to_string(__MODULE__, "mass_offering_fields.html", f: form)
    link "Add Offering", to: "#", "data-template": fields, id: "add_offering", class: "button is-primary"
  end

end
