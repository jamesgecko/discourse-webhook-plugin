require 'uri'
require 'net/http'

WEBHOOK_LOCATION = ENV['DISCOURSE_WEBHOOK']
raise 'DISCOURSE_WEBHOOK not set' unless WEBHOOK_LOCATION

module Email
  module BuildEmailHelper
    def build_email(*builder_args)
      email = builder_args[0]
      user = User.find_by_email(email)
      topic_title = builder_args[1][:topic_title] ||
                    Topic.find(builder_args[1][:topic_id]).try(:title)
      form_data = {
        'user_email'    => email,
        'discourse_user_id'   => user.try(:id),
        'discourse_user_name' => user.try(:username_lower),
        'topic_title'   => topic_title,
        'discourse_url' => builder_args[1][:url],
        'template'      => builder_args[1][:template]
      }
      hit_webhook(form_data)
    end

    def hit_webhook(post_params)
      uri = URI.parse(WEBHOOK_LOCATION)
      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data(post_params)
      http = Net::HTTP.new(uri.hostname, uri.port)
      http.use_ssl = true if WEBHOOK_LOCATION =~/^https/
      res = http.request(req)
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
