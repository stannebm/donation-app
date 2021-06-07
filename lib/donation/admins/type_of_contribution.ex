defmodule Donation.Admins.TypeOfContribution do
  use Ecto.Schema
  import Ecto.Changeset

  schema "type_of_contributions" do
    field :name, :string
    field :price, :decimal, precision: 12, scale: 2, default: 0
    has_many :receipt_items, Donation.Admins.ReceiptItem, on_delete: :nothing

    timestamps()
  end

  @doc false
  def changeset(type_of_contribution, attrs) do
    type_of_contribution
    |> cast(attrs, [:name, :price])
    |> validate_required([:name])
    |> validate_number(:price, greater_than_or_equal_to: Decimal.new(0))
    |> unique_constraint(:name, message: "This name already exists!")
  end
end
