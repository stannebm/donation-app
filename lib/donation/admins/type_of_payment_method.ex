defmodule Donation.Admins.TypeOfPaymentMethod do
  use Ecto.Schema
  import Ecto.Changeset

  schema "type_of_payment_methods" do
    field :name, :string
    has_many :receipts, Donation.Admins.Receipt, on_delete: :nothing
    timestamps()
  end

  @doc false
  def changeset(type_of_payment_method, attrs) do
    type_of_payment_method
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name, message: "This name already exists!")
  end
end
