PDFKit.configure do |config|
	config.wkhtmltopdf = Rails.root.join('bin', 'wkhtmltopdf')
end
