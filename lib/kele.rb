require 'httparty'
require 'json'
require_relative 'roadmap'

class Kele

  include HTTParty
  include Roadmap

  def initialize(email, password)
    @base_url = 'https://www.bloc.io/api/v1'

    response = self.class.post("#{@base_url}/sessions", body: { email: email, password:password }
    )

    if response && response["auth_token"]
      @auth_token = response["auth_token"]
      puts "#{email} has sucessfully logged in"
    else
      puts "Login invalid"
    end
  end

  def get_me
    response = self.class.get(base_url("/users/me"), headers: { "authorization" => @auth_token })
    return @user_data = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(base_url("/mentors/#{mentor_id}/student_availability"), headers: { "content_type" => "authorization/json", "authorization" => @auth_token })
    return @mentor_avail = JSON.parse(response.body)
  end

  private

  def base_url(endpoint)
    return "https://www.bloc.io/api/v1/#{endpoint}"
  end
end