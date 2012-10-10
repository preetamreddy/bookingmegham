# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Bookingmegham::Application.initialize!

# Load rails extensions
require 'rails_extensions'

ENV['RECAPTCHA_PUBLIC_KEY']  = '6LeJi9cSAAAAAEpyh-3pSbIH5Ujmu9dyXrsiLLlR'
ENV['RECAPTCHA_PRIVATE_KEY'] = '6LeJi9cSAAAAAP4JWD_Dnn-njTQ1DHjVmc89xgzu'
