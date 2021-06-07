defmodule Donation.AdminsTest do
  use Donation.DataCase

  alias Donation.Admins

  describe "users" do
    alias Donation.Admins.User

    @valid_attrs %{is_admin: true, name: "some name", password_hash: "some password_hash", username: "some username"}
    @update_attrs %{is_admin: false, name: "some updated name", password_hash: "some updated password_hash", username: "some updated username"}
    @invalid_attrs %{is_admin: nil, name: nil, password_hash: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admins.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Admins.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Admins.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Admins.create_user(@valid_attrs)
      assert user.is_admin == true
      assert user.name == "some name"
      assert user.password_hash == "some password_hash"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admins.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Admins.update_user(user, @update_attrs)
      assert user.is_admin == false
      assert user.name == "some updated name"
      assert user.password_hash == "some updated password_hash"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Admins.update_user(user, @invalid_attrs)
      assert user == Admins.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Admins.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Admins.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Admins.change_user(user)
    end
  end

  describe "users" do
    alias Donation.Admins.User

    @valid_attrs %{encrypted_password: "some encrypted_password", is_admin: true, name: "some name", username: "some username"}
    @update_attrs %{encrypted_password: "some updated encrypted_password", is_admin: false, name: "some updated name", username: "some updated username"}
    @invalid_attrs %{encrypted_password: nil, is_admin: nil, name: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admins.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Admins.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Admins.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Admins.create_user(@valid_attrs)
      assert user.encrypted_password == "some encrypted_password"
      assert user.is_admin == true
      assert user.name == "some name"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admins.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Admins.update_user(user, @update_attrs)
      assert user.encrypted_password == "some updated encrypted_password"
      assert user.is_admin == false
      assert user.name == "some updated name"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Admins.update_user(user, @invalid_attrs)
      assert user == Admins.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Admins.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Admins.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Admins.change_user(user)
    end
  end


  describe "receipts" do
    alias Donation.Admins.Receipt

    @valid_attrs %{donor_name: "some donor_name", receipt_number: "some receipt_number", total_amount: 42, type_of_payment_method: 42}
    @update_attrs %{donor_name: "some updated donor_name", receipt_number: "some updated receipt_number", total_amount: 43, type_of_payment_method: 43}
    @invalid_attrs %{donor_name: nil, receipt_number: nil, total_amount: nil, type_of_payment_method: nil}

    def receipt_fixture(attrs \\ %{}) do
      {:ok, receipt} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admins.create_receipt()

      receipt
    end

    test "list_receipts/0 returns all receipts" do
      receipt = receipt_fixture()
      assert Admins.list_receipts() == [receipt]
    end

    test "get_receipt!/1 returns the receipt with given id" do
      receipt = receipt_fixture()
      assert Admins.get_receipt!(receipt.id) == receipt
    end

    test "create_receipt/1 with valid data creates a receipt" do
      assert {:ok, %Receipt{} = receipt} = Admins.create_receipt(@valid_attrs)
      assert receipt.donor_name == "some donor_name"
      assert receipt.receipt_number == "some receipt_number"
      assert receipt.total_amount == 42
      assert receipt.type_of_payment_method == 42
    end

    test "create_receipt/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admins.create_receipt(@invalid_attrs)
    end

    test "update_receipt/2 with valid data updates the receipt" do
      receipt = receipt_fixture()
      assert {:ok, %Receipt{} = receipt} = Admins.update_receipt(receipt, @update_attrs)
      assert receipt.donor_name == "some updated donor_name"
      assert receipt.receipt_number == "some updated receipt_number"
      assert receipt.total_amount == 43
      assert receipt.type_of_payment_method == 43
    end

    test "update_receipt/2 with invalid data returns error changeset" do
      receipt = receipt_fixture()
      assert {:error, %Ecto.Changeset{}} = Admins.update_receipt(receipt, @invalid_attrs)
      assert receipt == Admins.get_receipt!(receipt.id)
    end

    test "delete_receipt/1 deletes the receipt" do
      receipt = receipt_fixture()
      assert {:ok, %Receipt{}} = Admins.delete_receipt(receipt)
      assert_raise Ecto.NoResultsError, fn -> Admins.get_receipt!(receipt.id) end
    end

    test "change_receipt/1 returns a receipt changeset" do
      receipt = receipt_fixture()
      assert %Ecto.Changeset{} = Admins.change_receipt(receipt)
    end
  end

  describe "receipt_items" do
    alias Donation.Admins.ReceiptItem

    @valid_attrs %{others: "some others", price: 42, remark: "some remark", type_of_contribution: 42}
    @update_attrs %{others: "some updated others", price: 43, remark: "some updated remark", type_of_contribution: 43}
    @invalid_attrs %{others: nil, price: nil, remark: nil, type_of_contribution: nil}

    def receipt_item_fixture(attrs \\ %{}) do
      {:ok, receipt_item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admins.create_receipt_item()

      receipt_item
    end

    test "list_receipt_items/0 returns all receipt_items" do
      receipt_item = receipt_item_fixture()
      assert Admins.list_receipt_items() == [receipt_item]
    end

    test "get_receipt_item!/1 returns the receipt_item with given id" do
      receipt_item = receipt_item_fixture()
      assert Admins.get_receipt_item!(receipt_item.id) == receipt_item
    end

    test "create_receipt_item/1 with valid data creates a receipt_item" do
      assert {:ok, %ReceiptItem{} = receipt_item} = Admins.create_receipt_item(@valid_attrs)
      assert receipt_item.others == "some others"
      assert receipt_item.price == 42
      assert receipt_item.remark == "some remark"
      assert receipt_item.type_of_contribution == 42
    end

    test "create_receipt_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admins.create_receipt_item(@invalid_attrs)
    end

    test "update_receipt_item/2 with valid data updates the receipt_item" do
      receipt_item = receipt_item_fixture()
      assert {:ok, %ReceiptItem{} = receipt_item} = Admins.update_receipt_item(receipt_item, @update_attrs)
      assert receipt_item.others == "some updated others"
      assert receipt_item.price == 43
      assert receipt_item.remark == "some updated remark"
      assert receipt_item.type_of_contribution == 43
    end

    test "update_receipt_item/2 with invalid data returns error changeset" do
      receipt_item = receipt_item_fixture()
      assert {:error, %Ecto.Changeset{}} = Admins.update_receipt_item(receipt_item, @invalid_attrs)
      assert receipt_item == Admins.get_receipt_item!(receipt_item.id)
    end

    test "delete_receipt_item/1 deletes the receipt_item" do
      receipt_item = receipt_item_fixture()
      assert {:ok, %ReceiptItem{}} = Admins.delete_receipt_item(receipt_item)
      assert_raise Ecto.NoResultsError, fn -> Admins.get_receipt_item!(receipt_item.id) end
    end

    test "change_receipt_item/1 returns a receipt_item changeset" do
      receipt_item = receipt_item_fixture()
      assert %Ecto.Changeset{} = Admins.change_receipt_item(receipt_item)
    end
  end

  describe "type_of_contributions" do
    alias Donation.Admins.TypeOfContribution

    @valid_attrs %{name: "some name", price: "120.5"}
    @update_attrs %{name: "some updated name", price: "456.7"}
    @invalid_attrs %{name: nil, price: nil}

    def type_of_contribution_fixture(attrs \\ %{}) do
      {:ok, type_of_contribution} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admins.create_type_of_contribution()

      type_of_contribution
    end

    test "list_type_of_contributions/0 returns all type_of_contributions" do
      type_of_contribution = type_of_contribution_fixture()
      assert Admins.list_type_of_contributions() == [type_of_contribution]
    end

    test "get_type_of_contribution!/1 returns the type_of_contribution with given id" do
      type_of_contribution = type_of_contribution_fixture()
      assert Admins.get_type_of_contribution!(type_of_contribution.id) == type_of_contribution
    end

    test "create_type_of_contribution/1 with valid data creates a type_of_contribution" do
      assert {:ok, %TypeOfContribution{} = type_of_contribution} = Admins.create_type_of_contribution(@valid_attrs)
      assert type_of_contribution.name == "some name"
      assert type_of_contribution.price == Decimal.new("120.5")
    end

    test "create_type_of_contribution/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admins.create_type_of_contribution(@invalid_attrs)
    end

    test "update_type_of_contribution/2 with valid data updates the type_of_contribution" do
      type_of_contribution = type_of_contribution_fixture()
      assert {:ok, %TypeOfContribution{} = type_of_contribution} = Admins.update_type_of_contribution(type_of_contribution, @update_attrs)
      assert type_of_contribution.name == "some updated name"
      assert type_of_contribution.price == Decimal.new("456.7")
    end

    test "update_type_of_contribution/2 with invalid data returns error changeset" do
      type_of_contribution = type_of_contribution_fixture()
      assert {:error, %Ecto.Changeset{}} = Admins.update_type_of_contribution(type_of_contribution, @invalid_attrs)
      assert type_of_contribution == Admins.get_type_of_contribution!(type_of_contribution.id)
    end

    test "delete_type_of_contribution/1 deletes the type_of_contribution" do
      type_of_contribution = type_of_contribution_fixture()
      assert {:ok, %TypeOfContribution{}} = Admins.delete_type_of_contribution(type_of_contribution)
      assert_raise Ecto.NoResultsError, fn -> Admins.get_type_of_contribution!(type_of_contribution.id) end
    end

    test "change_type_of_contribution/1 returns a type_of_contribution changeset" do
      type_of_contribution = type_of_contribution_fixture()
      assert %Ecto.Changeset{} = Admins.change_type_of_contribution(type_of_contribution)
    end
  end

  describe "type_of_payment_methods" do
    alias Donation.Admins.TypeOfPaymentMethod

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def type_of_payment_method_fixture(attrs \\ %{}) do
      {:ok, type_of_payment_method} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admins.create_type_of_payment_method()

      type_of_payment_method
    end

    test "list_type_of_payment_methods/0 returns all type_of_payment_methods" do
      type_of_payment_method = type_of_payment_method_fixture()
      assert Admins.list_type_of_payment_methods() == [type_of_payment_method]
    end

    test "get_type_of_payment_method!/1 returns the type_of_payment_method with given id" do
      type_of_payment_method = type_of_payment_method_fixture()
      assert Admins.get_type_of_payment_method!(type_of_payment_method.id) == type_of_payment_method
    end

    test "create_type_of_payment_method/1 with valid data creates a type_of_payment_method" do
      assert {:ok, %TypeOfPaymentMethod{} = type_of_payment_method} = Admins.create_type_of_payment_method(@valid_attrs)
      assert type_of_payment_method.name == "some name"
    end

    test "create_type_of_payment_method/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admins.create_type_of_payment_method(@invalid_attrs)
    end

    test "update_type_of_payment_method/2 with valid data updates the type_of_payment_method" do
      type_of_payment_method = type_of_payment_method_fixture()
      assert {:ok, %TypeOfPaymentMethod{} = type_of_payment_method} = Admins.update_type_of_payment_method(type_of_payment_method, @update_attrs)
      assert type_of_payment_method.name == "some updated name"
    end

    test "update_type_of_payment_method/2 with invalid data returns error changeset" do
      type_of_payment_method = type_of_payment_method_fixture()
      assert {:error, %Ecto.Changeset{}} = Admins.update_type_of_payment_method(type_of_payment_method, @invalid_attrs)
      assert type_of_payment_method == Admins.get_type_of_payment_method!(type_of_payment_method.id)
    end

    test "delete_type_of_payment_method/1 deletes the type_of_payment_method" do
      type_of_payment_method = type_of_payment_method_fixture()
      assert {:ok, %TypeOfPaymentMethod{}} = Admins.delete_type_of_payment_method(type_of_payment_method)
      assert_raise Ecto.NoResultsError, fn -> Admins.get_type_of_payment_method!(type_of_payment_method.id) end
    end

    test "change_type_of_payment_method/1 returns a type_of_payment_method changeset" do
      type_of_payment_method = type_of_payment_method_fixture()
      assert %Ecto.Changeset{} = Admins.change_type_of_payment_method(type_of_payment_method)
    end
  end
end
