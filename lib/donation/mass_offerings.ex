defmodule Donation.MassOfferings do
  @moduledoc """
  The MassOfferings context.
  """

  import Ecto.Query, warn: false
  alias Donation.Repo

  alias Donation.MassOfferings.MassOffering

  @doc """
  Returns the list of mass_offerings.

  ## Examples

      iex> list_mass_offerings()
      [%MassOffering{}, ...]

  """
  def list_mass_offerings do
    Repo.all( MassOffering )
  end

  @doc """
  Gets a single mass_offering.

  Raises `Ecto.NoResultsError` if the Mass offering does not exist.

  ## Examples

      iex> get_mass_offering!(123)
      %MassOffering{}

      iex> get_mass_offering!(456)
      ** (Ecto.NoResultsError)

  """
  # def get_mass_offering!(id), do: Repo.get!(MassOffering, id)
  def get_mass_offering!( id ) do
    MassOffering
    |> Repo.get!( id )
    |> Repo.preload( :mass_offering_items )
  end

  @doc """
  Creates a mass_offering.

  ## Examples

      iex> create_mass_offering(%{field: value})
      {:ok, %MassOffering{}}

      iex> create_mass_offering(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_mass_offering( attrs \\ %{} ) do
    %MassOffering{}
    |> MassOffering.changeset( attrs )
    |> Repo.insert()
    |> case do
      { :ok, %MassOffering{} = mass_offering } -> { :ok, Repo.preload( mass_offering, :mass_offering_items ) }
      error -> error
    end
  end

  @doc """
  Updates a mass_offering.

  ## Examples

      iex> update_mass_offering(mass_offering, %{field: new_value})
      {:ok, %MassOffering{}}

      iex> update_mass_offering(mass_offering, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_mass_offering( %MassOffering{} = mass_offering, attrs ) do
    mass_offering
    |> MassOffering.changeset( attrs )
    |> Repo.update()
  end

  @doc """
  Deletes a mass_offering.

  ## Examples

      iex> delete_mass_offering(mass_offering)
      {:ok, %MassOffering{}}

      iex> delete_mass_offering(mass_offering)
      {:error, %Ecto.Changeset{}}

  """
  def delete_mass_offering( %MassOffering{} = mass_offering ) do
    Repo.delete( mass_offering )
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mass_offering changes.

  ## Examples

      iex> change_mass_offering(mass_offering)
      %Ecto.Changeset{data: %MassOffering{}}

  """
  def change_mass_offering( %MassOffering{} = mass_offering, attrs \\ %{} ) do
    MassOffering.changeset( mass_offering, attrs )
  end

  alias Donation.MassOfferings.MassOfferingItem

  @doc """
  Returns the list of mass_offering_items.

  ## Examples

      iex> list_mass_offering_items()
      [%MassOfferingItem{}, ...]

  """
  # def list_mass_offering_items do
  #   Repo.all(MassOfferingItem)
  # end

  @doc """
  Gets a single mass_offering_item.

  Raises `Ecto.NoResultsError` if the Mass offering item does not exist.

  ## Examples

      iex> get_mass_offering_item!(123)
      %MassOfferingItem{}

      iex> get_mass_offering_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_mass_offering_item!(id), do: Repo.get!(MassOfferingItem, id)

  @doc """
  Creates a mass_offering_item.
  Enter sample of specific_dates: 2021-03-31

  ## Examples

      iex> create_mass_offering_item(%{field: value})
      {:ok, %MassOfferingItem{}}

      iex> create_mass_offering_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_mass_offering_item( %MassOffering{} = mass_offering, attrs \\ %{} ) do
    mass_offering
    |> Ecto.build_assoc( :mass_offering_items )
    |> MassOfferingItem.changeset( attrs )
    |> Repo.insert()
  end

  @doc """
  Updates a mass_offering_item.

  ## Examples

      iex> update_mass_offering_item(mass_offering_item, %{field: new_value})
      {:ok, %MassOfferingItem{}}

      iex> update_mass_offering_item(mass_offering_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_mass_offering_item( %MassOfferingItem{} = mass_offering_item, attrs ) do
    mass_offering_item
    |> MassOfferingItem.changeset( attrs )
    |> Repo.update()
  end

  @doc """
  Deletes a mass_offering_item.

  ## Examples

      iex> delete_mass_offering_item(mass_offering_item)
      {:ok, %MassOfferingItem{}}

      iex> delete_mass_offering_item(mass_offering_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_mass_offering_item( %MassOfferingItem{} = mass_offering_item ) do
    Repo.delete( mass_offering_item )
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mass_offering_item changes.

  ## Examples

      iex> change_mass_offering_item(mass_offering_item)
      %Ecto.Changeset{data: %MassOfferingItem{}}

  """
  def change_mass_offering_item( %MassOfferingItem{} = mass_offering_item, attrs \\ %{} ) do
    MassOfferingItem.changeset( mass_offering_item, attrs )
  end
end
