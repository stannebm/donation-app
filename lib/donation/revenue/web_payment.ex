defmodule Donation.Revenue.WebPayment do
  use Ecto.Schema
  import Ecto.Changeset

  @doc """
  Web payment. Currently supports FPX and Cybersource
  """

  @primary_key {:reference_no, :integer, autogenerate: false}
  @derive {Phoenix.Param, key: :reference_no}
  schema "web_payments" do
    belongs_to(:contribution, Donation.Revenue.Contribution)
    field(:verified, :boolean)
    field(:txn_info, :map)
    field(:extra_info, :map)
    timestamps()
  end

  @doc false
  def changeset(offering, attrs) do
    offering
    |> cast(attrs, [:verified, :txn_info, :extra_info])
    |> assoc_constraint(:contribution)
  end
end
