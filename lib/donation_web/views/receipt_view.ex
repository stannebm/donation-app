defmodule DonationWeb.ReceiptView do
  use DonationWeb, :view

  alias Donation.Admins
  alias Donation.Admins.Receipt
  alias Donation.Admins.ReceiptItem

  def link_to_receipt_item_fields(type_of_contributions) do
    changeset = Admins.change_receipt(%Receipt{ receipt_items: [%ReceiptItem{}] })
    form = Phoenix.HTML.FormData.to_form(changeset, [])
    fields = render_to_string(__MODULE__, "receipt_item_fields.html", f: form, type_of_contributions: type_of_contributions)
    link "Add Receipt Item", to: "#", "data-template": fields, id: "add_receipt_item"
  end

  # def render("new.html", assigns) do
    # IO.inspect(assigns)
    # "test with assigns #{inspect assigns[:conn]}"
    # [:changeset, :conn, :view_module, :view_template]
  # end

end
