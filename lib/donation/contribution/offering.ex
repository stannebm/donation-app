defmodule Donation.Contribution.Offering do
  use Ecto.Schema
  import Ecto.Changeset

  alias Donation.Contribution.Intention

  schema "offerings" do
    field(:reference_no, :string)
    # type: donation/mass_offering
    field(:type, :string)
    field(:name, :string)
    field(:email, :string)
    field(:contact_number, :string)
    field(:mass_language, :string)
    field(:amount, :decimal, precision: 12, scale: 2)
    field(:transferred, :boolean)
    field(:fpx_txn_info, :map)
    field(:cybersource_txn_info, :map)
    has_many(:intentions, Intention, on_delete: :delete_all)
    timestamps()
  end

  @doc false
  def changeset(mass_offering, attrs) do
    mass_offering
    |> cast(attrs, [
      :reference_no,
      :type,
      :name,
      :email,
      :contact_number,
      :mass_language,
      :amount,
      :transferred,
      :fpx_txn_info,
      :cybersource_txn_info
    ])
    |> validate_required([
      :reference_no,
      :type,
      :from_whom,
      :contact_number,
      :email,
      :mass_language,
      :amount
    ])
    |> unique_constraint(:reference_no)
    |> cast_assoc(:intentions)
  end
end
