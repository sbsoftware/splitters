class SettingsResource < ApplicationResource
  PAYPAL_USERNAME_FIELD = "paypal_username"

  def self.root_path
    SettingsPage.uri_path
  end

  before(:create) do
    unless ctx.session.user
      redirect HomePage.uri_path
      return 303
    end

    true
  end

  def create
    unless body = ctx.request.body
      ctx.response.status = :bad_request
      return
    end

    paypal_username = nil
    HTTP::Params.parse(body.gets_to_end) do |key, value|
      case key
      when PAYPAL_USERNAME_FIELD
        paypal_username = self.class.normalized_paypal_username(value)
      end
    end

    ctx.session.user.not_nil!.update(paypal_username: paypal_username)
    redirect SettingsPage.uri_path
  end

  def self.normalized_paypal_username(value : String) : String?
    stripped = value.strip.lchop("@").strip
    stripped.empty? ? nil : stripped
  end
end
