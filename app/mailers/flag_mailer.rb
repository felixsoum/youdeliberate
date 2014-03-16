class FlagMailer < ActionMailer::Base
  default from: 'flag_reason@youdeliberate.com'
  default to: Admin.first.user_name
  def flag_reason_email narrative_id, reason
    mail(subject: "The reason to flag narrative #{narrative_id}", 
            body: "Narrative #{narrative_id}: #{reason}")
  end
end