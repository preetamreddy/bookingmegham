WickedPdf.config = {
	:exe_path => Rails.root.join('bin', 'wkhtmltopdf').to_s if Rails.env.production?
}
