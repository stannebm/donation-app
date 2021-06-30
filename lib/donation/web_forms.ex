defmodule Donation.WebForms do
  @moduledoc """
  The Web Forms context.
  Donation form, Mass Offering form, etc
  """

  alias Donation.Repo
  alias Ecto.Changeset
  alias Donation.WebForms.{DonationForm, MassOfferingForm}
  alias Donation.WebForms.MassOfferingForm.Intention, as: MassIntentionForm
  alias Donation.Revenue.{Contribution, Donation, WebPayment, MassOffering}

  def save_donation_form(attrs) do
    Repo.transaction(fn ->
      with {:ok,
            %{
              reference_no: reference_no,
              contact_number: contact_number,
              email: email,
              name: name,
              amount: amount,
              payment_method: payment_method,
              intention: intention
            }} <- DonationForm.new(attrs),

           # create contribution
           {:ok, contribution} <-
             %Contribution{}
             |> Contribution.changeset(%{
               type: "donation",
               name: name,
               email: email,
               contact_number: contact_number,
               amount: amount,
               payment_method: payment_method
             })
             |> Repo.insert(),

           # create donation
           {:ok, donation} <-
             %Donation{}
             |> Donation.changeset(%{
               intention: intention
             })
             |> Changeset.put_assoc(:contribution, contribution)
             |> Repo.insert(),

           # track payment info with reference no
           {:ok, web_payment} <-
             %WebPayment{}
             |> WebPayment.changeset(%{
               reference_no: reference_no
             })
             |> Changeset.put_assoc(:contribution, contribution)
             |> Repo.insert() do
        {:ok, %{contribution: contribution, donation: donation, web_payment: web_payment}}
      end
    end)
  end

  def save_mass_offering_form(attrs) do
    Repo.transaction(fn ->
      with {:ok,
            %{
              reference_no: reference_no,
              contact_number: contact_number,
              email: email,
              name: name,
              amount: amount,
              payment_method: payment_method,
              mass_language: mass_language,
              intentions: intentions
            }} <- MassOfferingForm.new(attrs),

           # create contribution
           {:ok, contribution} <-
             %Contribution{}
             |> Contribution.changeset(%{
               type: "mass_offering",
               name: name,
               email: email,
               contact_number: contact_number,
               amount: amount,
               payment_method: payment_method
             })
             |> Repo.insert(),

           # track payment info with reference no
           {:ok, web_payment} <-
             %WebPayment{}
             |> WebPayment.changeset(%{
               reference_no: reference_no
             })
             |> Changeset.put_assoc(:contribution, contribution)
             |> Repo.insert(),

           # create list of mass offerings
           {:ok, mass_offerings} <-
             Enum.map(
               intentions,
               fn %MassIntentionForm{
                    type_of_mass: type_of_mass,
                    dates: dates,
                    intention: intention
                  } ->
                 %MassOffering{}
                 |> MassOffering.changeset(%{
                   type_of_mass: type_of_mass,
                   mass_language: mass_language,
                   dates: dates,
                   intention: intention
                 })
                 |> Changeset.put_assoc(:contribution, contribution)
                 |> Repo.insert()
               end
             )
             |> Enum.reduce(fn x, acc ->
               with {:ok, m} <- x,
                    {:ok, ms} <- acc do
                 {:ok, [m | ms]}
               end
             end) do
        {:ok,
         %{contribution: contribution, mass_offerings: mass_offerings, web_payment: web_payment}}
      end
    end)
  end
end
