defmodule Donation.Revenue.WebPayment do
  use Ecto.Schema
  import Ecto.Changeset

  @doc """
  Web payment. Currently supports FPX and Cybersource

  Render as JSON:
    Jason.encode(Repo.all(WebPayment) |> Repo.preload(:contribution), pretty: true)
  """

  @primary_key {:reference_no, :integer, autogenerate: false}
  @derive {Phoenix.Param, key: :reference_no}
  @derive {Jason.Encoder, only: [:contribution, :reference_no, :verified, :txn_info, :extra_info]}
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
    |> cast(attrs, [:reference_no, :verified, :txn_info, :extra_info])
    |> assoc_constraint(:contribution)
  end
end
