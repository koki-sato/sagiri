require "line/bot"

module Sagiri
  module Bot
    class Line < Base
      DEFAULT_ENDPOINT = "/callback/line".freeze

      def on_post(request)
        bad_request unless request.post? && request.fullpath == endpoint

        body = request.body.read

        signature = request.env["HTTP_X_LINE_SIGNATURE"]
        bad_request unless client.validate_signature(body, signature)

        events = client.parse_events_from(body)
        events.each do |event|
          case event
          when ::Line::Bot::Event::Message
            case event.type
            when ::Line::Bot::Event::MessageType::Text
              reply(event) if source_user?(event) || mention?(event.message["text"])
            end
          end
        end
        "OK"
      end

      # @note Override {Sagiri::Bot::Base#endpoint}
      def endpoint
        ENV["LINE_ENDPOINT"] || DEFAULT_ENDPOINT
      end

      private

      def mention
        "@#{name} "
      end

      def mention?(text)
        text.start_with?(mention)
      end

      def source_user?(event)
        event["source"]["type"] == "user"
      end

      def client
        @client ||= ::Line::Bot::Client.new do |config|
          config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
          config.channel_token  = ENV["LINE_CHANNEL_TOKEN"]
        end
      end

      def reply(event)
        reply_token = event["replyToken"]
        text = event.message["text"]
        text = "#{mention}#{text}" if source_user?(event) && !mention?(text)
        message = {
          type: "text",
          text: robot.receive(body: text)
        }
        client.reply_message(reply_token, message)
      end
    end
  end
end
