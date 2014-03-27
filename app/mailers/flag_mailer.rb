class FlagMailer < ActionMailer::Base
  default from: 'soen390@youdeliberate.com'

  def flag_reason_email narrative_id, reason
    mail(to: Admin.first.user_name, subject: "The reason to flag narrative #{narrative_id}",
            body: "Narrative #{narrative_id}: #{reason}")
  end

  def forget_password_email email
    admin = Admin.find_by user_name: email
    pwd = 8.times.map { [*'0'..'9', *'a'..'z', *'A'..'Z'].sample }.join
    admin.update(password: pwd, password_confirmation: pwd)
    mail(to: email, subject: "Forget your password",
            body: "Your Password is: #{pwd}")
  end

end