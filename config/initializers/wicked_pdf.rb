WickedPdf.configure do |config|
	config.wkhtmltopdf = Rails.root.join('bin', 'wkhtmltopdf').to_s if Rails.env.production?
end
