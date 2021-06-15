defmodule DonationWeb.OfferingView do
  use DonationWeb, :view
  alias DonationWeb.OfferingView

  def render("show.json", %{mass_offering_item: mass_offering_item}) do
    %{data: render_one(mass_offering_item, OfferingView, "mass_offering_item.json")}
  end

  def render("offering.json", %{offering: offering}) do
    %{
      typeOfMass: offering.typeOfMass,
      intention: offering.intention,
      dates: offering.dates
    }
  end
end
