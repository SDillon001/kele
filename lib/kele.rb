require 'httparty'
require 'json'
require_relative 'roadmap'

class Kele

  include HTTParty
  include Roadmap

  # attr_reader :base_url
  
  def initialize(email, password)
    @base_url = 'https://www.bloc.io/api/v1'

    response = self.class.post("#{@base_url}/sessions", body: { email: email, password:password }
    )

    if response && response["auth_token"]
      @auth_token = response["auth_token"]
      puts "#{email} has successfully logged in"
    else
      puts "Login invalid"
    end
  end

  def get_me
    response = self.class.get(base_url("/users/me"), headers: { "authorization" => @auth_token })
    @user_data = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(base_url("/mentors/#{mentor_id}/student_availability"), headers: { "content_type" => "authorization/json", "authorization" => @auth_token })
    @mentor_avail = JSON.parse(response.body)
  end

  def get_messages(page = 1)
    response = self.class.get(base_url("/message_threads"), values: {"page": page}, headers: { "content_type" => "authorization/json", "authorization" => @auth_token })
    @messages = JSON.parse(response.body)
  end

  def create_message(sender, recipient_id, token, subject, stripped_text)
    self.class.post(base_url("/messages", body: { sender: sender, recipient_id: recipient_id, subject: subject, "stripped-text": stripped_text }, headers: { "authorization" => @authorization_token} ))
  end

  private

  def base_url(endpoint)
    return "https://www.bloc.io/api/v1/#{endpoint}"
  end
end