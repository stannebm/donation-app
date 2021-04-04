defmodule DonationWeb.MassOfferingItemView do
  use DonationWeb, :view
  alias DonationWeb.MassOfferingItemView

  def render("index.json", %{mass_offering_items: mass_offering_items}) do
    %{data: render_many(mass_offering_items, MassOfferingItemView, "mass_offering_item.json")}
  end

  def render("show.json", %{mass_offering_item: mass_offering_item}) do
    %{data: render_one(mass_offering_item, MassOfferingItemView, "mass_offering_item.json")}
  end

  def render("mass_offering_item.json", %{mass_offering_item: mass_offering_item}) do
    %{id: mass_offering_item.id,
      type_of_mass: mass_offering_item.type_of_mass,
      number_of_mass: mass_offering_item.number_of_mass,
      specific_dates: mass_offering_item.specific_dates,
      to_whom: mass_offering_item.to_whom,
      intention: mass_offering_item.intention}
  end
end
