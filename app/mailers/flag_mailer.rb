class FlagMailer < ActionMailer::Base
  default from: 'soen390@youdeliberate.com'

  def flag_narrative_email narrative_id, reason
    mail(to: Admin.first.user_name, subject: "Content has been flagged in narrative #{narrative_id}",
            body: "Narrative: #{narrative_id}\nReason provided by user: #{reason}")
  end
  
  def flag_comment_email narrative_id, comment_id, reason
    mail(to: Admin.first.user_name, subject: "Content has been flagged in narrative #{narrative_id}",
            body: "Narrative: #{narrative_id}\nComment: #{comment_id}\nReason provided by user: #{reason}\n" +
            "Please log in as an administrator on the admin portal and visit " + root_url + share_narrative_path(narrative_id) + " to moderate the comment.")
  end

  def forget_password_email email
    admin = Admin.find_by user_name: email
    pwd = 8.times.map { [*'0'..'9', *'a'..'z', *'A'..'Z'].sample }.join
    admin.update(password: pwd, password_confirmation: pwd)
    mail(to: email, subject: "Forget your password",
            body: "Your Password is: #{pwd}")
  end

end