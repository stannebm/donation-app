defmodule Donation.Admins do
  @moduledoc """
  The Admins context.
  """

  import Ecto.Query, warn: false
  alias Donation.Repo
  alias Donation.Admins.User
  alias Donation.Admins.{Receipt, ReceiptItem}
  alias Donation.Admins.{TypeOfContribution, TypeOfPaymentMethod}
  alias Donation.Revenue.{Contribution, MassOffering, Donation}

  @doc """
  Admins: USER
  """

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

  def list_receipts(params) do
    Receipt
    |> order_by(desc: :inserted_at)
    |> Repo.paginate(params)
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

  def list_mass_offering_by_contributors(search_params) do
    Contribution
    |> filter_by_date(search_params["start_date"], search_params["end_date"])
    |> filter_by_type(search_params["type"])
    |> filter_by_name(search_params["name"])
    |> filter_by_email(search_params["email"])
    |> filter_by_contact_number(search_params["contact_number"])
    |> filter_by_online_payment_method(search_params["payment_method"])
    |> order_by(desc: :inserted_at)
    |> Repo.all()
    |> Repo.preload([:mass_offerings])
  end

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

  def filter_donations(%{search: nil}) do
    Repo.all(
      from d in Donation,
        join: c in Contribution,
        on: c.id == d.contribution_id,
        order_by: [desc: :inserted_at],
        preload: [:contribution]
    )
  end

  ## Practice: https://stackoverflow.com/questions/49382461/ecto-query-composition-with-nil-values
  def filter_donations(%{search: search}) do
    from_date =
      if get_in(search, ["from_date"]) != "" do
        Date.from_iso8601!(get_in(search, ["from_date"]))
      else
        Date.utc_today()
      end
    Repo.all(
      from d in Donation,
        join: c in Contribution,
        on: c.id == d.contribution_id,
        where: fragment("?::date", d.inserted_at) >= ^from_date,
        where: fragment("?::date", d.inserted_at) <= ^from_date,
        preload: [:contribution]
    )
  end

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

  @doc """
    RECEIPT REPORTS
  """

  def unique_cashier_in_receipt() do
    Repo.all(
      from r in Receipt,
      join: u in User, on: u.id == r.user_id,
      order_by: [u.name],
      distinct: r.user_id,
      select: {u.name,  u.id}
    )
  end

  def filter_receipt_and_payment_method(search_params) do
    Receipt
    |> filter_by_date(search_params["start_date"], search_params["end_date"])
    |> filter_by_cashier_name(search_params["user_id"])
    |> filter_by_receipt_number(search_params["receipt_number"])
    |> filter_by_donor_name(search_params["donor_name"])
    |> filter_by_payment_method(search_params["type_of_payment_method_id"])
    |> order_by(desc: :inserted_at)
    |> Repo.all()
    |> Repo.preload([:user, :type_of_payment_method])
  end

  def filter_receipt_and_payment_method() do
    Repo.all(
      from r in Receipt,
      join: u in User, on: u.id == r.user_id,
      order_by: [u.name],
      preload: [:user, :type_of_payment_method]
    )
  end

  ## PROTECTED FILTER

  defp filter_by_date(query, nil, nil), do: query
  defp filter_by_date(query, "", ""), do: query
  defp filter_by_date(query, start_date, end_date) do
    case {start_date, end_date} do
      {start_date, ""} -> 
        sd = Date.from_iso8601!(start_date)
        ed = Date.from_iso8601!(start_date)
        from q in query,
          where: fragment("?::date", q.inserted_at) >= ^sd,
          where: fragment("?::date", q.inserted_at) <= ^ed
      {start_date, end_date} ->
        sd = Date.from_iso8601!(start_date)
        ed = Date.from_iso8601!(end_date)
        from q in query,
          where: fragment("?::date", q.inserted_at) >= ^sd,
          where: fragment("?::date", q.inserted_at) <= ^ed
    end
  end

  defp filter_by_cashier_name(query, nil), do: query
  defp filter_by_cashier_name(query, ""), do: query
  defp filter_by_cashier_name(query, user_id) do
    from receipt in query,
    where: receipt.user_id == ^user_id
  end

  defp filter_by_receipt_number(query, nil), do: query
  defp filter_by_receipt_number(query, ""), do: query
  defp filter_by_receipt_number(query, receipt_number) do
    from receipt in query,
    where: ilike(receipt.receipt_number, ^"%#{receipt_number}%")
  end

  defp filter_by_donor_name(query, nil), do: query
  defp filter_by_donor_name(query, ""), do: query
  defp filter_by_donor_name(query, donor_name) do
    from receipt in query,
    where: receipt.donor_name == ^donor_name
  end

  defp filter_by_payment_method(query, nil), do: query
  defp filter_by_payment_method(query, ""), do: query
  defp filter_by_payment_method(query, type_of_payment_method_id) do
    from receipt in query,
    where: receipt.type_of_payment_method_id == ^type_of_payment_method_id
  end

  defp filter_by_type(query, nil), do: query
  defp filter_by_type(query, ""), do: query
  defp filter_by_type(query, type) do
    from q in query,
    where: q.type == ^type
  end

  defp filter_by_name(query, nil), do: query
  defp filter_by_name(query, ""), do: query
  defp filter_by_name(query, name) do
    from q in query,
    where: ilike(q.name, ^"%#{name}%")
  end

  defp filter_by_email(query, nil), do: query
  defp filter_by_email(query, ""), do: query
  defp filter_by_email(query, email) do
    from q in query,
    where: ilike(q.email, ^"%#{email}%")
  end

  defp filter_by_contact_number(query, nil), do: query
  defp filter_by_contact_number(query, ""), do: query
  defp filter_by_contact_number(query, contact_number) do
    from q in query,
    where: ilike(q.contact_number, ^"%#{contact_number}%")
  end

  defp filter_by_online_payment_method(query, nil), do: query
  defp filter_by_online_payment_method(query, ""), do: query
  defp filter_by_online_payment_method(query, payment_method) do
    from q in query,
    where: q.payment_method == ^payment_method
  end

end
