defmodule DonationWeb.WebPaymentApiController do
  use DonationWeb, :controller
  use PhoenixSwagger

  alias Donation.Revenue.WebPayment, as: Payment
  alias Donation.Repo

  def payment_notification(conn, %{
        # "payment_provider" => "fpx",
        "reference_no" => reference_no,
        "txn_info" => %{"status" => status, "info" => info}
      }) do
    with {:ok, %Payment{} = updated} <-
           Repo.get!(Payment, reference_no)
           |> Repo.preload(:contribution)
           |> Payment.changeset(%{txn_info: info, verified: status == "OK"})
           |> Repo.update() do
      json(conn, updated)
    end
  end

  # -------------------------------------------------------------------------------------------
  # Swagger doc
  # -------------------------------------------------------------------------------------------

  swagger_path :payment_notification do
    post("/api/payment_notification/{payment_provider}/{reference_no}")
    description("Receive payment callback")
    tag("Payment")

    parameters do
      payment_provider(:path, :string, "Payment Provider", required: true)
      reference_no(:path, :string, "Reference No", required: true)

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
            info(:map, "Info", required: true)
          end

          example(%{
            txn_info: %{
              status: "OK",
              info: %{
                provider: "FPX",
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
