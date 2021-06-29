defmodule Donation.Admins do
  @moduledoc """
  The Admins context.
  """

  import Ecto.Query, warn: false
  alias Donation.Repo
  alias Donation.Admins.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
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
    # authenticated_user = case Encryption.validate_password(user, password) do
    # {:ok, validated_user} -> validated_user.email == user.email
    # {:error, _} -> false
    # end
    if Bcrypt.verify_pass(password, user.encrypted_password) do
      {:ok, user}
    else
      {:error, "Login error"}
    end
  end

  alias Donation.Admins.Receipt

  @doc """
  Returns the list of receipts.

  ## Examples

      iex> list_receipts()
      [%Receipt{}, ...]

  """
  def list_receipts do
    Receipt
    |> Repo.all()
    |> Repo.preload([:type_of_payment_method, receipt_items: :type_of_contribution])
  end

  def search_receipts(_search_params) do
    Receipt
    |> Repo.all()
    |> Repo.preload([:type_of_payment_method, receipt_items: :type_of_contribution])
  end

  @doc """
  Gets a single receipt.

  Raises `Ecto.NoResultsError` if the Receipt does not exist.

  ## Examples

      iex> get_receipt!(123)
      %Receipt{}

      iex> get_receipt!(456)
      ** (Ecto.NoResultsError)

  """
  # def get_receipt!(id), do: Repo.get!(Receipt, id)

  ## CHANGE
  def get_receipt!(id) do
    Receipt
    |> Repo.get!(id)
    |> Repo.preload([:user, :type_of_payment_method, receipt_items: :type_of_contribution])
  end

  @doc """
  Creates a receipt.

  ## Examples

      iex> create_receipt(%{field: value})
      {:ok, %Receipt{}}

      iex> create_receipt(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
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

  @doc """
  Updates a receipt.

  ## Examples

      iex> update_receipt(receipt, %{field: new_value})
      {:ok, %Receipt{}}

      iex> update_receipt(receipt, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_receipt(%Receipt{} = receipt, attrs) do
    receipt
    |> Receipt.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a receipt.

  ## Examples

      iex> delete_receipt(receipt)
      {:ok, %Receipt{}}

      iex> delete_receipt(receipt)
      {:error, %Ecto.Changeset{}}

  """
  def delete_receipt(%Receipt{} = receipt) do
    Repo.delete(receipt)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking receipt changes.

  ## Examples

      iex> change_receipt(receipt)
      %Ecto.Changeset{data: %Receipt{}}

  """
  def change_receipt(%Receipt{} = receipt, attrs \\ %{}) do
    Receipt.changeset(receipt, attrs)
  end

  alias Donation.Admins.ReceiptItem

  @doc """
  Returns the list of receipt_items.

  ## Examples

      iex> list_receipt_items()
      [%ReceiptItem{}, ...]

  """
  def list_receipt_items do
    Repo.all(ReceiptItem)
  end

  @doc """
  Gets a single receipt_item.

  Raises `Ecto.NoResultsError` if the Receipt item does not exist.

  ## Examples

      iex> get_receipt_item!(123)
      %ReceiptItem{}

      iex> get_receipt_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_receipt_item!(id), do: Repo.get!(ReceiptItem, id)

  @doc """
  Creates a receipt_item.

  ## Examples

      iex> create_receipt_item(%{field: value})
      {:ok, %ReceiptItem{}}

      iex> create_receipt_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_receipt_item(attrs \\ %{}) do
    %ReceiptItem{}
    |> ReceiptItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a receipt_item.

  ## Examples

      iex> update_receipt_item(receipt_item, %{field: new_value})
      {:ok, %ReceiptItem{}}

      iex> update_receipt_item(receipt_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_receipt_item(%ReceiptItem{} = receipt_item, attrs) do
    receipt_item
    |> ReceiptItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a receipt_item.

  ## Examples

      iex> delete_receipt_item(receipt_item)
      {:ok, %ReceiptItem{}}

      iex> delete_receipt_item(receipt_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_receipt_item(%ReceiptItem{} = receipt_item) do
    Repo.delete(receipt_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking receipt_item changes.

  ## Examples

      iex> change_receipt_item(receipt_item)
      %Ecto.Changeset{data: %ReceiptItem{}}

  """
  def change_receipt_item(%ReceiptItem{} = receipt_item, attrs \\ %{}) do
    ReceiptItem.changeset(receipt_item, attrs)
  end

  alias Donation.Admins.TypeOfContribution

  @doc """
  Returns the list of type_of_contributions.

  ## Examples

      iex> list_type_of_contributions()
      [%TypeOfContribution{}, ...]

  """
  def list_type_of_contributions do
    Repo.all(TypeOfContribution)
  end

  @doc """
  Gets a single type_of_contribution.

  Raises `Ecto.NoResultsError` if the Type of contribution does not exist.

  ## Examples

      iex> get_type_of_contribution!(123)
      %TypeOfContribution{}

      iex> get_type_of_contribution!(456)
      ** (Ecto.NoResultsError)

  """
  def get_type_of_contribution!(id), do: Repo.get!(TypeOfContribution, id)

  @doc """
  Creates a type_of_contribution.

  ## Examples

      iex> create_type_of_contribution(%{field: value})
      {:ok, %TypeOfContribution{}}

      iex> create_type_of_contribution(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_type_of_contribution(attrs \\ %{}) do
    %TypeOfContribution{}
    |> TypeOfContribution.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a type_of_contribution.

  ## Examples

      iex> update_type_of_contribution(type_of_contribution, %{field: new_value})
      {:ok, %TypeOfContribution{}}

      iex> update_type_of_contribution(type_of_contribution, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_type_of_contribution(%TypeOfContribution{} = type_of_contribution, attrs) do
    type_of_contribution
    |> TypeOfContribution.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a type_of_contribution.

  ## Examples

      iex> delete_type_of_contribution(type_of_contribution)
      {:ok, %TypeOfContribution{}}

      iex> delete_type_of_contribution(type_of_contribution)
      {:error, %Ecto.Changeset{}}

  """
  def delete_type_of_contribution(%TypeOfContribution{} = type_of_contribution) do
    Repo.delete(type_of_contribution)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking type_of_contribution changes.

  ## Examples

      iex> change_type_of_contribution(type_of_contribution)
      %Ecto.Changeset{data: %TypeOfContribution{}}

  """
  def change_type_of_contribution(%TypeOfContribution{} = type_of_contribution, attrs \\ %{}) do
    TypeOfContribution.changeset(type_of_contribution, attrs)
  end

  alias Donation.Admins.TypeOfPaymentMethod

  @doc """
  Returns the list of type_of_payment_methods.

  ## Examples

      iex> list_type_of_payment_methods()
      [%TypeOfPaymentMethod{}, ...]

  """
  def list_type_of_payment_methods do
    Repo.all(TypeOfPaymentMethod)
  end

  @doc """
  Gets a single type_of_payment_method.

  Raises `Ecto.NoResultsError` if the Type of payment method does not exist.

  ## Examples

      iex> get_type_of_payment_method!(123)
      %TypeOfPaymentMethod{}

      iex> get_type_of_payment_method!(456)
      ** (Ecto.NoResultsError)

  """
  def get_type_of_payment_method!(id), do: Repo.get!(TypeOfPaymentMethod, id)

  @doc """
  Creates a type_of_payment_method.

  ## Examples

      iex> create_type_of_payment_method(%{field: value})
      {:ok, %TypeOfPaymentMethod{}}

      iex> create_type_of_payment_method(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_type_of_payment_method(attrs \\ %{}) do
    %TypeOfPaymentMethod{}
    |> TypeOfPaymentMethod.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a type_of_payment_method.

  ## Examples

      iex> update_type_of_payment_method(type_of_payment_method, %{field: new_value})
      {:ok, %TypeOfPaymentMethod{}}

      iex> update_type_of_payment_method(type_of_payment_method, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_type_of_payment_method(%TypeOfPaymentMethod{} = type_of_payment_method, attrs) do
    type_of_payment_method
    |> TypeOfPaymentMethod.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a type_of_payment_method.

  ## Examples

      iex> delete_type_of_payment_method(type_of_payment_method)
      {:ok, %TypeOfPaymentMethod{}}

      iex> delete_type_of_payment_method(type_of_payment_method)
      {:error, %Ecto.Changeset{}}

  """
  def delete_type_of_payment_method(%TypeOfPaymentMethod{} = type_of_payment_method) do
    Repo.delete(type_of_payment_method)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking type_of_payment_method changes.

  ## Examples

      iex> change_type_of_payment_method(type_of_payment_method)
      %Ecto.Changeset{data: %TypeOfPaymentMethod{}}

  """
  def change_type_of_payment_method(%TypeOfPaymentMethod{} = type_of_payment_method, attrs \\ %{}) do
    TypeOfPaymentMethod.changeset(type_of_payment_method, attrs)
  end
end
