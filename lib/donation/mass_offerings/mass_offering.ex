defmodule Donation.MassOfferings.MassOffering do
  use Ecto.Schema
  import Ecto.Changeset

  alias Donation.MassOfferings.MassOfferingItem

  schema "mass_offerings" do
    field :contact_name, :string
    field :contact_number, :string
    field :email_address, :string
    has_many( :mass_offering_items, MassOfferingItem, on_replace: :delete )
    timestamps()
  end

  @doc false
  def changeset(mass_offering, attrs) do
    mass_offering
    |> cast(attrs, [:contact_name, :contact_number, :email_address])
    |> cast_assoc( :mass_offering_items )
    |> validate_required([ :contact_name, :contact_number, :email_address ])
  end
end

# API module
# {
#   "mass_offering": {
#     "contact_name": "St Anne Office",
#     "contact_number": "1234567890", 
#     "email_address": "donation@app.com",
#     "mass_offering_items": [
#       {
#         "intention": "Praise to our Lord",
#         "number_of_mass": 1,
#         "specific_dates": "2021-04-01",
#         "to_whom": "Joseph",
#         "type_of_mass": "Special Intention"
#       }
#     ]
#   }
# }
