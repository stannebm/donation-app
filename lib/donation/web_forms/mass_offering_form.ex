defmodule Donation.WebForms.MassOfferingForm do
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
    field(:mass_language, :string)

    embeds_many :intentions, Intention, primary_key: false do
      field(:type_of_mass, :string)
      field(:dates, {:array, :date})
      field(:intention, :string)
    end
  end

  def new(form) do
    changeset =
      %MassOfferingForm{}
      |> cast(form, [
        :reference_no,
        :contact_number,
        :email,
        :name,
        :amount,
        :payment_method,
        :mass_language
      ])
      |> cast_embed(:intentions, with: &intention_changeset/2)

    case changeset do
      %{valid?: true} = changeset -> {:ok, apply_changes(changeset)}
      changeset -> {:error, changeset}
    end
  end

  defp intention_changeset(schema, params) do
    schema
    |> cast(params, [:type_of_mass, :dates, :intention])
  end
end
