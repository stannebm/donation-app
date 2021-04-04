defmodule DonationWeb.MassOfferingView do
  use DonationWeb, :view
  # alias DonationWeb.MassOfferingView
  alias DonationWeb.{MassOfferingView, MassOfferingItemView}

  def render("index.json", %{mass_offerings: mass_offerings}) do
    %{data: render_many(mass_offerings, MassOfferingView, "mass_offering.json")}
  end

  def render("show.json", %{mass_offering: mass_offering}) do
    %{data: render_one(mass_offering, MassOfferingView, "mass_offering_details.json")}
  end

  def render("mass_offering.json", %{mass_offering: mass_offering}) do
    %{
      id: mass_offering.id,
      contact_name: mass_offering.contact_name,
      contact_number: mass_offering.contact_number,
      email_address: mass_offering.email_address
    }
  end

  def render("mass_offering_details.json", %{mass_offering: mass_offering}) do
    %{
      id: mass_offering.id,
      contact_name: mass_offering.contact_name,
      contact_number: mass_offering.contact_number,
      email_address: mass_offering.email_address,
      mass_offering_items: render_many( mass_offering.mass_offering_items, MassOfferingItemView, "mass_offering_item.json" )
    }
  end

end
