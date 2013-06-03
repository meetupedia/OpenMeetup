# encoding: UTF-8

STATUS = 'bounced'

emails = []

IO.foreach('mail.log') do |line|
  if line =~ /status=#{STATUS}/ and line =~ /to=<([^>]+)>/
    email = $1
    unless emails.include?(email)
      puts email
      if user = User.find_by_email(email)
        user.update_attributes email_bounced: true
        puts '  OK'
      end
      emails << email
    end
  end
end
