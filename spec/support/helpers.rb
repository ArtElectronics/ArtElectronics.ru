# for copybara
def basic_authorize username, password, verbose=nil
  if page.driver.respond_to?(:basic_auth)
      puts 'Responds to basic_auth' unless verbose
      page.driver.basic_auth(username, password)
  elsif page.driver.respond_to?(:basic_authorize)
      puts 'Responds to basic_authorize' unless verbose
      page.driver.basic_authorize(username, password)
  elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:basic_authorize)
      puts 'Responds to browser_basic_authorize' unless verbose
      page.driver.browser.basic_authorize(username, password)
  else
      raise "I don't know how to log in!"
  end
end

# for rspec
def basic_authorize_rspec username, password
  encoded_login = ["#{username}:#{password}"].pack("m*")
  header('Authorization', "Basic #{encoded_login}")
end

# def http_login user, pw
#   request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
# end  