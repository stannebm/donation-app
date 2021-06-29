defmodule Donation.WebForms.DonationForm do
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  @primary_key false
  embedded_schema do
    field(:reference_no, :integer)
    field(:contact_number, :string)
    field(:email, :string)
    field(:name, :string)
    field(:amount, :float)
    field(:payment_method, :string)
    field(:intention, :string)
  end

  def new(form) do
    changeset =
      %DonationForm{}
      |> cast(form, [
        :reference_no,
        :contact_number,
        :email,
        :name,
        :amount,
        :payment_method,
        :intention
      ])

    case changeset do
      %{valid?: true} = changeset -> {:ok, apply_changes(changeset)}
      changeset -> {:error, changeset}
    end
  end
end
