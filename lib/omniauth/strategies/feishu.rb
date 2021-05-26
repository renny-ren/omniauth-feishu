require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Feishu < OmniAuth::Strategies::OAuth2
      class NoAppAccessTokenError < StandardError; end

      attr_reader :app_access_token

      option :name, 'feishu'

      option :client_options, {
        site: 'https://open.feishu.cn',
        authorize_url: "/open-apis/authen/v1/user_auth_page_beta",
        token_url: "https://open.feishu.cn/open-apis/authen/v1/access_token",
        app_access_token_url: "https://open.feishu.cn/open-apis/auth/v3/app_access_token/internal",
        user_info_url: "https://open.feishu.cn/open-apis/authen/v1/user_info"
      }

      info do
        {
          name: raw_info['name'],
          email: raw_info['email'],
          mobile: raw_info['mobile'],
          avatar_url: raw_info['avatar_url'],
          avatar_thumb: raw_info['avatar_thumb'],
          avatar_middle: raw_info['avatar_middle'],
          avatar_big: raw_info['avatar_big'],
          user_id: raw_info['user_id'], 
          union_id: raw_info['union_id'], 
          open_id: raw_info['open_id'], 
          app_access_token: @app_access_token
        }
      end

      def raw_info
        @raw_info ||= begin
          response = Faraday.get(
            options.client_options.user_info_url,
            nil,
            content_type: 'application/json', authorization: "Bearer #{access_token.token}"
          )
          response_body = JSON.parse(response.body)
          response_body['data']
        end
      end

      def authorize_params
        super.tap do |params|
          params[:app_id] = options.client_id
        end
      end

      def build_access_token
        resp = Faraday.post(
          options.client_options.token_url,
          { code: request.params["code"], app_access_token: app_access_token, grant_type: "authorization_code" }.to_json,
          content_type: "application/json"
        )
        data = JSON.parse(resp.body)['data']
        ::OAuth2::AccessToken.from_hash(client, data)
      end

      def callback_phase
        get_app_access_token
        super
      end

      private

      def get_app_access_token
        resp = Faraday.post(
          options.client_options.app_access_token_url,
          { app_id: options.client_id, app_secret: options.client_secret }.to_json,
          content_type: "application/json"
        )
        response_body = JSON.parse(resp.body)
        if response_body.key?('app_access_token')
          @app_access_token = response_body['app_access_token']
        else
          raise NoAppAccessTokenError, "cannot get app_access_token."
        end
      end
    end
  end
end
