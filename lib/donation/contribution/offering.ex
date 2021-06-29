defmodule Donation.Contribution.Offering do
  use Ecto.Schema
  import Ecto.Changeset
  alias Donation.Contribution.Intention

  @doc """
  An offering can be of type `donation` or `mass`.
  """

  schema "offerings" do
    field(:reference_no, :string)
    field(:type, :string)
    field(:name, :string)
    field(:email, :string)
    field(:contact_number, :string)
    field(:amount, :decimal, precision: 12, scale: 2)
    field(:transfer_method, :string)
    field(:transferred, :boolean)
    field(:mass_language, :string)
    field(:fpx_txn_info, :map)
    field(:cybersource_txn_info, :map)
    has_many(:intentions, Intention, on_delete: :delete_all)
    timestamps()
  end

  @doc false
  def changeset(offering, attrs) do
    offering
    |> cast(attrs, [
      :reference_no,
      :type,
      :name,
      :email,
      :contact_number,
      :amount,
      :transfer_method,
      :transferred,
      :mass_language,
      :fpx_txn_info,
      :cybersource_txn_info
    ])
    |> validate_required([
      :reference_no,
      :type,
      :name,
      :email,
      :contact_number,
      :amount,
      :transfer_method
    ])
    |> unique_constraint(:reference_no)
    |> cast_assoc(:intentions)
  end
end
