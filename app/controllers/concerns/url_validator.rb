require 'uri'

class UrlValidator
  attr_reader :params
  attr_reader :errors

  def initialize(params)
    @params = params
    @errors = []
  end

  def validate
    validate_extra_params
    validate_missing_required_params
    validate_required_params
    if errors.blank?
      return true
    else
      params['errors'] = errors
      return false
    end
  end

  private

  def param_keys
    @param_keys ||= params.except(:action, :controller).keys
  end

  def validate_extra_params
    extra_params = param_keys - required_params
    if extra_params.present?
      errors.push("Extra params: #{extra_params}")
    end
  end

  def missing_required_params
    @missing_required_params ||= required_params - param_keys
  end

  def validate_missing_required_params
    if missing_required_params.present?
      errors.push("Missing required params: #{missing_required_params}")
    end
  end

  def validate_required_params
    if missing_required_params.blank?
      validate_original_param_value
      validate_original_param_is_url
    end
  end

  def is_params_original_present?
    params['original'].present?
  end

  def validate_original_param_value
    if !is_params_original_present?
      errors.push('params["original"] cannot be blank')
    end
  end

  def validate_original_param_is_url
    if is_params_original_present?
      uri = URI.parse(params['original'])
      if !(uri.is_a?(URI::HTTP) && !uri.host.nil?)
        errors.push("#{params['original']} is not a valid url")
      end
    end
  end

  def required_params
    ['original']
  end
end
