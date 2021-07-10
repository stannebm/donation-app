defmodule DonationWeb.InputHelpers do
  use Phoenix.HTML

  def array_date_input(form, field) do
    values = Phoenix.HTML.Form.input_value(form, field) || [""]

    content_tag :ul, class: "date-input-container" do
      for {value, i} <- Enum.with_index(values) do
        input_opts = [
          value: value,
          id: nil,
          type: "date",
          class: "input"
        ]

        create_li(form, field, input_opts, index: i)
      end
    end
  end

  def create_li(form, field, input_opts \\ [], data \\ []) do
    type = Phoenix.HTML.Form.input_type(form, field)
    name = Phoenix.HTML.Form.input_name(form, field) <> "[]"
    opts = Keyword.put_new(input_opts, :name, name)

    content_tag :li do
      [
        apply(Phoenix.HTML.Form, type, [form, field, opts]),
        link("Remove", to: "#", data: data, title: "Remove", class: "remove-array-item")
      ]
    end
  end
end
