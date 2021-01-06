require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Feishu < OmniAuth::Strategies::OAuth2
      attr_reader :app_access_token

      option :name, 'feishu'

      option :client_options, {
        site: 'https://open.feishu.cn',
        authorize_url: "/open-apis/authen/v1/user_auth_page_beta",
        token_url: "https://open.feishu.cn/open-apis/authen/v1/access_token",
        app_access_token_url: "https://open.feishu.cn/open-apis/auth/v3/app_access_token/internal",
        user_info_url: "https://open.feishu.cn/open-apis/authen/v1/user_info"
      }

      option :access_token_options, {
        app_access_token: get_app_access_token,
        grant_type: 'authorization_code'
      }

      def build_access_token
        options.access_token_options.merge!(headers: { 'Content-Type' => 'application/json' })
        super
      end

      info do
        {
          name: raw_info['name'],
          email: raw_info['email'],
          mobile: raw_info['mobile']
        }
      end

      def raw_info
        @raw_info ||= begin
          client.request(:get, options.client_options.user_info_url, :params => {
              :format => :json,
              :anthorization => access_token.token,
            }, :parse => :json).parsed
        end
      end

      private

      def get_app_access_token
        resp = Faraday.post(
          options.client_options.app_access_token_url,
          {app_id: options.client_id, app_secret: options.client_secret}.to_json,
          content_type: 'application/json'
        )
        @app_access_token = JSON.parse(resp.body)['app_access_token']
      end
    end
  end
end