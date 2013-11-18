class FacebookReader

  def user(id)
    read(id, false)
  end

  def friends(user)
    read("#{user.facebook_id}/friends" + access_token(user))
  end

  def groups(user)
    read("#{user.facebook_id}/groups" + access_token(user))
  end

private

  def access_token(user)
    "?access_token=#{user.facebook_access_token}"
  end

  def read(query, array_output = true)
    output = HTTParty.get("https://graph.facebook.com/#{query}").parsed_response
    output = output['data'] if array_output
    output
  end
end
