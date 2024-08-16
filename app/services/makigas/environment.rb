# frozen_string_literal: true

module Makigas
  class Environment
    class << self
      def discord_server_id
        ENV.fetch('DISCORD_SERVER_ID', nil)
      end

      def discord_server_invite
        ENV.fetch('DISCORD_SERVER_INVITE', nil)
      end

      def plausible_domain
        ENV.fetch('PLAUSIBLE_DOMAIN', nil)
      end

      def plausible_api_key
        ENV.fetch('PLAUSIBLE_API_KEY', nil)
      end
    end
  end
end
