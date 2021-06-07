defmodule Donation.Admins.Receipt do
  use Ecto.Schema
  import Ecto.Changeset
  
  alias Donation.Admins.User
  alias Donation.Admins.ReceiptItem
  alias Donation.Admins.TypeOfPaymentMethod

  schema "receipts" do
    has_many :receipt_items, ReceiptItem, on_delete: :delete_all
    belongs_to :user, User
    belongs_to :type_of_payment_method, TypeOfPaymentMethod
    field :donor_name, :string
    field :receipt_number, :string, default: "MBSA"
    field :total_amount, :decimal, precision: 12, scale: 2
    timestamps()
  end

  @doc false
  def changeset(receipt, attrs) do
    receipt
    |> cast(attrs, [:user_id, :type_of_payment_method_id, :donor_name, :receipt_number, :total_amount])
    |> cast_assoc(:receipt_items, required: true)
    |> validate_required([:type_of_payment_method_id, :donor_name, :receipt_number, :total_amount])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:type_of_payment_method_id)
  end

end
