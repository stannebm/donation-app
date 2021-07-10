defmodule Donation.Admins do
  @moduledoc """
  The Admins context.
  """

  import Ecto.Query, warn: false
  alias Donation.Repo

  @doc """
  Admins: USER
  """

  alias Donation.Admins.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
    AUTHENTICATE USERNAME AND PASSWORD
  """

  def auth(username, password) when is_binary(username) and is_binary(password) do
    with {:ok, user} <- get_by_username(username), do: verify_password(password, user)
  end

  defp get_by_username(username) when is_binary(username) do
    case Repo.get_by(User, username: username) do
      nil ->
        {:error, :unauthorized}

      user ->
        {:ok, user}
    end
  end

  # defp verify_password(password, nil), do: nil
  defp verify_password(password, %User{} = user) when is_binary(password) do
    if Bcrypt.verify_pass(password, user.encrypted_password) do
      {:ok, user}
    else
      {:error, "Login error"}
    end
  end

  @doc """
  Admins: RECEIPT
  """

  alias Donation.Admins.Receipt

  def list_receipts do
    Receipt
    |> order_by(desc: :inserted_at)
    |> Repo.all()
    |> Repo.preload([:type_of_payment_method, receipt_items: :type_of_contribution])
  end

  def search_receipts(_search_params) do
    Receipt
    |> Repo.all()
    |> Repo.preload([:type_of_payment_method, receipt_items: :type_of_contribution])
  end

  def get_receipt!(id) do
    Receipt
    |> Repo.get!(id)
    |> Repo.preload([:user, :type_of_payment_method, receipt_items: :type_of_contribution])
  end

  def create_receipt(attrs \\ %{}) do
    %Receipt{}
    |> Receipt.changeset(attrs)
    |> Repo.insert()
  end

  def put_receipt_number(receipt) do
    post = Repo.get!(Receipt, receipt.id)
    post = Ecto.Changeset.change(post, receipt_number: "MBSA-21-#{number_with_zeros(receipt.id)}")
    Repo.update(post)
  end

  defp number_with_zeros(value) do
    value
    |> Integer.to_string()
    |> String.pad_leading(5, "0")
  end

  def update_receipt(%Receipt{} = receipt, attrs) do
    receipt
    |> Receipt.changeset(attrs)
    |> Repo.update()
  end

  def delete_receipt(%Receipt{} = receipt) do
    Repo.delete(receipt)
  end

  def change_receipt(%Receipt{} = receipt, attrs \\ %{}) do
    Receipt.changeset(receipt, attrs)
  end

  @doc """
  Admins: RECEIPT ITEM
  """

  alias Donation.Admins.ReceiptItem

  def list_receipt_items do
    Repo.all(ReceiptItem)
  end

  def get_receipt_item!(id), do: Repo.get!(ReceiptItem, id)

  def create_receipt_item(attrs \\ %{}) do
    %ReceiptItem{}
    |> ReceiptItem.changeset(attrs)
    |> Repo.insert()
  end

  def update_receipt_item(%ReceiptItem{} = receipt_item, attrs) do
    receipt_item
    |> ReceiptItem.changeset(attrs)
    |> Repo.update()
  end

  def delete_receipt_item(%ReceiptItem{} = receipt_item) do
    Repo.delete(receipt_item)
  end

  def change_receipt_item(%ReceiptItem{} = receipt_item, attrs \\ %{}) do
    ReceiptItem.changeset(receipt_item, attrs)
  end

  @doc """
  Admins: Type of Contributions
  """

  alias Donation.Admins.TypeOfContribution

  def list_type_of_contributions do
    Repo.all(TypeOfContribution)
  end

  def get_type_of_contribution!(id), do: Repo.get!(TypeOfContribution, id)

  def create_type_of_contribution(attrs \\ %{}) do
    %TypeOfContribution{}
    |> TypeOfContribution.changeset(attrs)
    |> Repo.insert()
  end

  def update_type_of_contribution(%TypeOfContribution{} = type_of_contribution, attrs) do
    type_of_contribution
    |> TypeOfContribution.changeset(attrs)
    |> Repo.update()
  end

  def delete_type_of_contribution(%TypeOfContribution{} = type_of_contribution) do
    Repo.delete(type_of_contribution)
  end

  def change_type_of_contribution(%TypeOfContribution{} = type_of_contribution, attrs \\ %{}) do
    TypeOfContribution.changeset(type_of_contribution, attrs)
  end

  @doc """
  Admins: Type of Payment Methods
  """

  alias Donation.Admins.TypeOfPaymentMethod

  def list_type_of_payment_methods do
    Repo.all(TypeOfPaymentMethod)
  end

  def get_type_of_payment_method!(id), do: Repo.get!(TypeOfPaymentMethod, id)

  def create_type_of_payment_method(attrs \\ %{}) do
    %TypeOfPaymentMethod{}
    |> TypeOfPaymentMethod.changeset(attrs)
    |> Repo.insert()
  end

  def update_type_of_payment_method(%TypeOfPaymentMethod{} = type_of_payment_method, attrs) do
    type_of_payment_method
    |> TypeOfPaymentMethod.changeset(attrs)
    |> Repo.update()
  end

  def delete_type_of_payment_method(%TypeOfPaymentMethod{} = type_of_payment_method) do
    Repo.delete(type_of_payment_method)
  end

  def change_type_of_payment_method(%TypeOfPaymentMethod{} = type_of_payment_method, attrs \\ %{}) do
    TypeOfPaymentMethod.changeset(type_of_payment_method, attrs)
  end

  @doc """
  Admins: Contribution -> list Mass Offering
  In Admin, they need to data entry for Mass Offering without Payment
  A contribution has many mass_offerings
  """
  alias Donation.Revenue.{Contribution, MassOffering}

  def list_mass_offering_by_contributors do
    Contribution
    |> order_by(desc: :inserted_at)
    |> Repo.all()
    |> Repo.preload([:mass_offerings])
  end

  def get_mass_offering_by_contributor!(id) do
    Contribution
    |> Repo.get!(id)
    |> Repo.preload([:mass_offerings])
  end

  def create_mass_offering_by_contributor(attrs \\ %{}) do
    %Contribution{}
    |> Contribution.changeset(attrs)
    |> Repo.insert()
  end

  def update_mass_offering_by_contributor(%Contribution{} = contribution, attrs) do
    contribution
    |> Contribution.changeset(attrs)
    |> Repo.update()
  end

  def delete_mass_offering_by_contributor(%Contribution{} = contribution) do
    Repo.delete(contribution)
  end

  def change_mass_offering_by_contributor(%Contribution{} = contribution, attrs \\ %{}) do
    Contribution.changeset(contribution, attrs)
  end

  @doc """
    REPORTS
  """
  def find_mass_offering_dates(from_date) do
    Repo.all(
      from mo in MassOffering,
        join: c in Contribution,
        on: c.id == mo.contribution_id,
        where: fragment("? = ANY (?)", ^from_date, mo.dates),
        order_by: [mo.mass_language, mo.type_of_mass],
        preload: [:contribution]
    )
  end

  def filter_mass_intentions(_), do: nil

  def filter_mass_intentions(scope, language, type_mass) do
    scope
    |> Enum.filter(&(&1.mass_language == language and &1.type_of_mass == type_mass))
    |> Enum.map(fn x -> x.intention end)
    |> Enum.join("; ")
  end
end
