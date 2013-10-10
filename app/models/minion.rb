# encoding: UTF-8

class Minion

  def users
    User.joins(ActiveRecord::Base.send(:sanitize_sql_array, ['INNER JOIN watch_logs ON watch_logs.user_id != users.id OR watch_logs.user_id = users.id AND NOT watch_logs.action = ?', action]))
  end

  def items
    eval(code + ".joins(:user).where('users.id' => #{users.pluck(:id)})")
  end
end
