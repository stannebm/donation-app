# https://medium.com/@njwest/jwt-auth-with-an-elixir-on-phoenix-1-3-guardian-api-and-react-native-mobile-app-1bd00559ea51

defmodule Donation.Guardian do
  use Guardian, otp_app: :donation

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Donation.Admins.get_user!(id)
    {:ok,  resource}
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
