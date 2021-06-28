defmodule Donation.Contribution do
  @moduledoc """
  The Contribution context.
  """

  import Ecto.Query, warn: false
  alias Donation.Repo
  alias Donation.Contribution.Offering

  def list_offerings do
    Repo.all(Offering)
  end

  def get_offering!(id) do
    Offering
    |> Repo.get!(id)
    |> Repo.preload(:intentions)
  end

  def get_offering_by_reference_no(reference_no) do
    Offering
    |> Repo.get_by(reference_no: reference_no)
    |> Repo.preload(:intentions)
  end

  def create_offering(attrs \\ %{}) do
    %Offering{}
    |> Offering.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, %Offering{} = o} -> {:ok, Repo.preload(o, :intentions)}
      error -> error
    end
  end

  def update_offering(%Offering{} = offering, attrs) do
    offering
    |> Offering.changeset(attrs)
    |> Repo.update()
  end

  def update_with_txn_info(%Offering{} = offering, :fpx, success, info) do
    offering
    |> Offering.changeset(%{fpx_txn_info: info, transferred: success})
    |> Repo.update()
  end

  def update_with_txn_info(%Offering{} = offering, :cybersource, success, info) do
    offering
    |> Offering.changeset(%{cybersource_txn_info: info, transferred: success})
    |> Repo.update()
  end

  def delete_offering(%Offering{} = offering) do
    Repo.delete(offering)
  end
end
