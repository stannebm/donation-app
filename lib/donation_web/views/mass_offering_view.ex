defmodule DonationWeb.MassOfferingView do
  use DonationWeb, :view
  alias DonationWeb.{MassOfferingView, OfferingView}

  def render("index.json", %{mass_offerings: mass_offerings}) do
    %{ data: render_many(mass_offerings, MassOfferingView, "mass_offering.json") }
  end

  def render("show.json", %{mass_offering: mass_offering}) do
    %{ data: render_one(mass_offering, MassOfferingView, "mass_offering_details.json") }
  end

  def render("mass_offering.json", %{mass_offering: mass_offering}) do
    %{
      id: mass_offering.id,
      fromWhom: mass_offering.fromWhom,
      contactNumber: mass_offering.contactNumber,
      emailAddress: mass_offering.emailAddress,
      massLanguage: mass_offering.massLanguage
    }
  end

  def render("mass_offering_details.json", %{mass_offering: mass_offering}) do
    %{
      id: mass_offering.id,
      fromWhom: mass_offering.fromWhom,
      contactNumber: mass_offering.contactNumber,
      emailAddress: mass_offering.emailAddress,
      offerings: render_many( mass_offering.offerings, OfferingView, "offering.json" )
    }
  end

end
