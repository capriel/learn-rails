require 'digest/md5'

# Class for Visitors of the webpage
class Visitor
  include ActiveModel::Model
  attr_accessor :email, :string
  validates_presence_of :email
  validates_format_of :email,
                      with: /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i

  def subscribe
    mailchimp = Gibbon::Request.new(api_key:
                Rails.application.secrets.mailchimp_api_key)
    list_id = Rails.application.secrets.mailchimp_list_id
    md5_hashed_email = Digest::MD5.hexdigest(email)
    result = mailchimp.lists(list_id).members(md5_hashed_email).upsert(body:
                                                       { email_address: email,
                                                         status: 'subscribed' })
    Rails.logger.info("Subscribed #{email} to MailChimp") if result
  end
end
