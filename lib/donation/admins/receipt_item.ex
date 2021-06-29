defmodule Donation.Admins.ReceiptItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "receipt_items" do
    belongs_to :receipt, Donation.Admins.Receipt
    belongs_to :type_of_contribution, Donation.Admins.TypeOfContribution
    field :others, :string
    field :price, :decimal, precision: 12, scale: 2
    field :remark, :string
    timestamps()
  end

  @doc false
  def changeset(receipt_item, attrs) do
    receipt_item
    |> cast(attrs, [:type_of_contribution_id, :others, :remark, :price])
    |> validate_required([:type_of_contribution_id, :price])
    |> validate_number(:price, greater_than_or_equal_to: Decimal.new(0))
    |> foreign_key_constraint(:type_of_contribution_id, message: "Select a type of contribution")
  end
end
