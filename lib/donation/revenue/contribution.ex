defmodule Donation.Revenue.Contribution do
  use Ecto.Schema
  import Ecto.Changeset

  @doc """
  Contributions are income sources of a Church
  Eg. Donations, Mass Offerings, Venue Bookings
  """

  @derive {Jason.Encoder, only: [:type, :name, :email, :contact_number, :amount, :payment_method]}
  schema "contributions" do
    has_many :mass_offerings, Donation.Revenue.MassOffering
    field(:type, :string)
    field(:name, :string)
    field(:email, :string)
    field(:contact_number, :string)
    field(:amount, :decimal, precision: 12, scale: 2)
    field(:payment_method, :string)
    timestamps()
  end

  @doc false
  def changeset(offering, attrs) do
    offering
    |> cast(attrs, [
      :type,
      :name,
      :email,
      :contact_number,
      :amount,
      :payment_method
    ])
    |> cast_assoc(:mass_offerings, required: true)
    |> validate_required([
      :type,
      :name,
      # :email,
      # :contact_number,
      :amount,
      :payment_method
    ])
  end
end
