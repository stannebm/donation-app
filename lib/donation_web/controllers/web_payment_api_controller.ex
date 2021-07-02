defmodule DonationWeb.WebPaymentApiController do
  use DonationWeb, :controller
  use PhoenixSwagger

  alias Donation.Revenue.WebPayment, as: Payment
  alias Donation.Repo

  def payment_notification(conn, %{
        "payment_provider" => provider,
        "txn_info" => %{
          "status" => status,
          "reference_no" => reference_no,
          "signature" => signature,
          "info" => info
        }
      }) do
    with :valid_sig <- verify_sig(provider, reference_no, status, signature),
         {:ok, %Payment{} = updated} <-
           Repo.get!(Payment, reference_no)
           |> Repo.preload(:contribution)
           |> Payment.changeset(%{txn_info: info, verified: status == "OK"})
           |> Repo.update() do
      json(conn, updated)
    else
      :invalid_sig ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid signature"})

      unexpected ->
        IO.inspect(
          type: :error,
          event: :payment_notification,
          details: unexpected
        )

        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Unexpected error"})
    end
  end

  defp verify_sig(provider, reference_no, status, signature) do
    s =
      hmac_fn(:sha256, System.get_env("CHECKOUT_API_SECRET")).(
        Enum.join([provider, reference_no, status], "|")
      )
      |> :base64.encode()

    case Plug.Crypto.secure_compare(s, signature) do
      true -> :valid_sig
      _ -> :invalid_sig
    end
  end

  # OTP compatibility
  if Code.ensure_loaded?(:crypto) and function_exported?(:crypto, :mac, 4) do
    defp hmac_fn(digest, key), do: &:crypto.mac(:hmac, digest, key, &1)
  else
    defp hmac_fn(digest, key), do: &:crypto.hmac(digest, key, &1)
  end

  # -------------------------------------------------------------------------------------------
  # Swagger doc
  # -------------------------------------------------------------------------------------------

  swagger_path :payment_notification do
    post("/api/payment_notification/{payment_provider}")
    description("Receive payment callback")
    tag("Payment")

    parameters do
      payment_provider(:path, :string, "Payment Provider", required: true)

      txn_info(:body, Schema.ref(:txn_info), "Describes whether a payment is successful",
        required: true
      )
    end

    response(201, "Ok")
    response(422, "Unprocessable Entity")
  end

  def swagger_definitions do
    %{
      txn_info:
        swagger_schema do
          title("Payment Callback TxnInfo")
          description("Describes whether a payment is successful")

          properties do
            status(:string, "Status", required: true)
            reference_no(:string, "Reference No", required: true)

            signature(:string, "Hmac(SHA256) Signature \"provider|reference_no|status\"",
              required: true
            )

            info(:map, "Info", required: true)
          end

          example(%{
            txn_info: %{
              status: "OK",
              reference_no: "1625126279658",
              signature: "<Base64String>",
              info: %{
                provider: "fpx",
                fpx_msg: "Transaction is successful",
                fpx_txnCurrency: "MYR",
                fpx_sellerReference: "SE0013401"
              }
            }
          })
        end
    }
  end
end
