require 'uri'
require 'net/http'

WEBHOOK_LOCATION = ENV['DISCOURSE_WEBHOOK']
raise 'DISCOURSE_WEBHOOK not set' unless WEBHOOK_LOCATION

module Email
  module BuildEmailHelper
    def build_email(*builder_args)
      form_data = { 'user_email' => builder_args[0] }
      form_data.merge!(builder_args[1])
      hit_webhook(form_data)
    end

    def hit_webhook(post_params)
      uri = URI(WEBHOOK_LOCATION)
      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data(post_params)

      res = Net::HTTP.start(uri.hostname, uri.port) {|http| http.request(req) }
      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        Rails.logger.info res.value
      else
        Rails.logger.error res.value
      end
    end
  end
end

# Don't send any email accidentally
Mail::Message.class_eval do
  def deliver; end
  def deliver!; end
end
