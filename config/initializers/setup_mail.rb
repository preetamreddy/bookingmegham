ActionMailer::Base.smtp_settings = {
	:address							=> "smtp.gmail.com",
	:port									=> 587,
	:user_name						=> "info@ezbook.in",
	:password							=> "delhinov2011",
	:authentication				=> "plain",
	:enable_starttls_auto	=> true
}
