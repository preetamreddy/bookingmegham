class PhoneNumberFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value =~ /^[\+]?[\d\s]*$/ or value == nil or value == ""
      object.errors[attribute] << (options[:message] || "is not formatted properly") 
    end
  end
end
