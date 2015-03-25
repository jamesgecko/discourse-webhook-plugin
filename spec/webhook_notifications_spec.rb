require 'spec_helper'
require_dependency 'jobs/base'
require_relative '../email_helper.rb'

describe 'WebhookNotificationsPlugin' do
  before do
    SiteSetting.stubs(:email_time_window_mins).returns(10)
  end

  context "Sending a notification" do
    let!(:user)        { Fabricate(:user, last_seen_at: 1.day.ago ) }
    let(:post)         { Fabricate(:post, user: user) }
    let(:notification) { Fabricate(:notification, user: user) }

    it "Fires the webhook method" do
      UserNotifications.any_instance.expects(:hit_webhook)
      Jobs::UserEmail.new.execute(type: :user_replied, user_id: user.id, post_id: post.id,
                                  notification_id: notification.id)
    end
  end
end
