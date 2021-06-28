defmodule Donation.Contribution do
  @moduledoc """
  The Contribution context.
  """

  import Ecto.Query, warn: false
  alias Donation.Repo
  alias Donation.Contribution.Offering
  alias Donation.Contribution.Intention

  def list_mass_offerings do
    Repo.all(MassOffering)
  end

  def get_mass_offering!(id) do
    MassOffering
    |> Repo.get!(id)
    |> Repo.preload(:offerings)
  end

  def get_mass_offering_reference_no(reference_no) do
    MassOffering
    |> Repo.get_by(reference_no: reference_no)
    |> Repo.preload(:offerings)
  end

  def create_mass_offering(attrs \\ %{}) do
    %MassOffering{}
    |> MassOffering.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, %MassOffering{} = mass_offering} -> {:ok, Repo.preload(mass_offering, :offerings)}
      error -> error
    end
  end

  def update_mass_offering(%MassOffering{} = mass_offering, attrs) do
    mass_offering
    |> MassOffering.changeset(attrs)
    |> Repo.update()
  end

  def update_fpx_callback(%MassOffering{} = mass_offering, fpx_callback_attrs) do
    mass_offering
    |> MassOffering.changeset(%{"fpx_callback" => fpx_callback_attrs})
    |> Repo.update()
  end

  def update_cybersource_callback(%MassOffering{} = mass_offering, cybersource_callback_attrs) do
    mass_offering
    |> MassOffering.changeset(%{"cybersource_callback" => cybersource_callback_attrs})
    |> Repo.update()
  end

  def delete_mass_offering(%MassOffering{} = mass_offering) do
    Repo.delete(mass_offering)
  end

  def change_mass_offering(%MassOffering{} = mass_offering, attrs \\ %{}) do
    MassOffering.changeset(mass_offering, attrs)
  end

  def get_offering!(id), do: Repo.get!(Offering, id)

  def create_mass_offering_item(%MassOffering{} = mass_offering, attrs \\ %{}) do
    mass_offering
    |> Ecto.build_assoc(:offerings)
    |> Offering.changeset(attrs)
    |> Repo.insert()
  end

  def update_offering(%Offering{} = offering, attrs) do
    offering
    |> Offering.changeset(attrs)
    |> Repo.update()
  end

  def delete_offering(%Offering{} = offering) do
    Repo.delete(offering)
  end

  def change_mass_offering_item(%Offering{} = offering, attrs \\ %{}) do
    Offering.changeset(offering, attrs)
  end
end
