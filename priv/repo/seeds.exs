# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Donation.Repo.insert!(%Donation.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Donation.Admins

## USER
Admins.create_user(%{
  username: "super", 
  password: "12345678",
  name: "Agatha Teh",
  is_admin: true
})

Admins.create_user(%{
  username: "volunteer", 
  password: "12345678",
  name: "Jason"
})

## PAYMENT METHOD

Admins.create_type_of_payment_method(%{ name: "Cash" })
Admins.create_type_of_payment_method(%{ name: "Cheque" })
Admins.create_type_of_payment_method(%{ name: "Credit Card" })
Admins.create_type_of_payment_method(%{ name: "Debit Card" })
Admins.create_type_of_payment_method(%{ name: "Direct Deposits" })
Admins.create_type_of_payment_method(%{ name: "Online Transfer" })
Admins.create_type_of_payment_method(%{ name: "Qr Code" })

## CONTRIBUTION

Admins.create_type_of_contribution(%{ name: "Donation for Church" })
Admins.create_type_of_contribution(%{ name: "Donation for the poor/sick" })
Admins.create_type_of_contribution(%{ name: "Mass Offering" })
Admins.create_type_of_contribution(%{ name: "Booking" })
Admins.create_type_of_contribution(%{ name: "Others" })