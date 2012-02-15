ActionMailer::Base.smtp_settings = {
	:address							=> "smtp.gmail.com",
	:port									=> 587,
	:user_name						=> "banjaracamps@ezbook.in",
	:password							=> "batseri1993",
	:authentication				=> "plain",
	:enable_starttls_auto	=> true
}
