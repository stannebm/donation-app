defmodule DonationWeb.ContributionApiView do
  use DonationWeb, :view
  alias DonationWeb.ContributionApiView, as: V

  def render("index.json", %{offerings: offerings}) do
    %{data: render_many(offerings, V, "offering_simple.json")}
  end

  def render("show.json", %{offering: offering}) do
    %{data: render_one(offering, V, "offering_full.json")}
  end

  def render("offering_simple.json", %{offering: o}) do
    %{
      id: o.id,
      reference_no: o.reference_no,
      type: o.type,
      name: o.name,
      email: o.email,
      contact_number: o.contact_number,
      mass_language: o.mass_language,
      amount: o.amount,
      transferred: o.transferred
    }
  end

  def render("offering_full.json", %{offering: o}) do
    %{
      id: o.id,
      reference_no: o.reference_no,
      type: o.type,
      name: o.name,
      email: o.email,
      contact_number: o.contact_number,
      mass_language: o.mass_language,
      amount: o.amount,
      transferred: o.transferred,
      fpx_txn_info: o.fpx_txn_info,
      cybersource_txn_info: o.cybersource_txn_info,
      intentions: render_many(o.intentions, V, "intention.json")
    }
  end

  def render("intention.json", %{intention: i}) do
    %{
      type_of_mass: i.type_of_mass,
      intention: i.intention,
      other_intention: i.other_intention,
      dates: i.dates
    }
  end
end
