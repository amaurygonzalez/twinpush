require 'faraday'
require 'cgi'
require 'json'

class TWINPUSH
  DEFAULT_TIMEOUT = 30
  FORMAT = :json
  BASE_URI = 'https://subdomain.twinpush.com'
  API_URL = '/api/v2/apps'

  attr_accessor :uri, :app_id, :api_token, :api_token_creator

  # @param [Hash] authentication_keys
  # @param [Hash] client_options
  # @param [Integer] timeout
  def initialize(authentication_keys, client_options = {}, timeout = nil)
    validate_keys(authentication_keys)
    authentication_keys.each_pair do |key, value|
      instance_variable_set("@#{key}", value)
      self.class.instance_eval { attr_accessor key.to_sym }
    end
    @uri = BASE_URI.sub 'subdomain', @subdomain
    @client_options = client_options
    @timeout = timeout | DEFAULT_TIMEOUT
  end

  #obtains details from a previously created notification
  def show_notification(notification_id, device_id = nil)
    path = "#{API_URL}/#{app_id}#{"/devices/#{device_id}" if device_id }/notifications/#{notification_id}"
    for_uri(uri) do |connection|
      response = connection.get(path)
      build_response(response)
    end
  end

  alias show show_notification

  #obtains notification details in OpenStruct
  def show_notification_object(notification_id, device_id = nil)
    OpenStruct.new JSON.parse(show_notification(notification_id, device_id)[:body])
  end

  #creates a new notification to be delivered from the platform
  def create_notification(notification_params)
    path = "#{API_URL}/#{app_id}/notifications"
    for_uri(uri) do |connection|
      response = connection.post(path, notification_params.to_json)
      build_response(response)
    end
  end

  alias create create_notification

  # obtains delivery statistics for a given notification
  def report_notification(notification_id)
    path = "#{API_URL}/#{app_id}/notifications/#{notification_id}/report"
    for_uri(uri) do |connection|
      response = connection.get(path)
      build_response(response)
    end
  end

  alias report report_notification

  #Obtains paginated list of all the deliveries for a given notification.
  #This is useful to obtain exactly who has been the recipient of the notification and also who has opened it
  def deliveries_notification(notification_id)
    path = "#{API_URL}/#{app_id}/notifications/#{notification_id}/deliveries"
    for_uri(uri) do |connection|
      response = connection.get(path)
      build_response(response)
    end
  end

  alias deliveries deliveries_notification

  # Makes a paginated search of the notifications sent to an user through the device alias. It allows filtering by notification tags
  def inbox(device_id)
    path = "#{API_URL}/#{app_id}/devices/#{device_id}/inbox"
    for_uri(uri) do |connection|
      response = connection.get(path)
      build_response(response)
    end
  end

  #Obtains a fast summary of the notification inbox associated to the current device alias
  #It offers the total notification count and the unopened notification count
  def inbox_summary(device_id)
    path = "#{API_URL}/#{app_id}/devices/#{device_id}/inbox_summary"
    for_uri(uri) do |connection|
      response = connection.get(path)
      build_response(response)
    end
  end

  #Removes the selected notification from the inbox of the user (or alias) associated to the device
  def delete_inbox(device_id, notification_id)
    path = "#{API_URL}/#{app_id}/devices/#{device_id}/notifications/#{notification_id}"
    for_uri(uri) do |connection|
      response = connection.delete(path)
      build_response(response)
    end
  end

  # assigns value for a device custom property
  def set_custom_property(device_id, properties)
    path = "#{API_URL}/#{app_id}/devices/#{device_id}/set_custom_property"
    for_uri(uri) do |connection|
      response = connection.post(path, properties.to_json)
      build_response(response)
    end
  end

  #Makes a paginated search of the notifications received by a device. It allows filtering by notification tags
  def search_device_notifications(device_id, params)
    path = "#{API_URL}/#{app_id}/devices/#{device_id}/search_notifications"
    for_uri(uri) do |connection|
      response = connection.post(path, params.to_json)
      build_response(response)
    end
  end

  # Clears all the custom properties for a given device
  def clear_properties(device_id)
    path = "#{API_URL}/#{app_id}/devices/#{device_id}/clear_custom_properties"
    for_uri(uri) do |connection|
      response = connection.delete(path)
      build_response(response)
    end
  end

  private

  def validate_keys(authentication_keys)
    required_params = [:app_id, :subdomain, :api_token, :api_token_creator]
    (required_params - authentication_keys.keys).each do |params|
      raise ArgumentError, "Required authentication_key #{params} missing"
    end
  end

  def for_uri(uri, extra_headers = {})
    connection = ::Faraday.new(:url => uri) do |faraday|
      faraday.adapter  Faraday.default_adapter
      faraday.headers["Content-Type"] = "application/json"
      faraday.headers["X-TwinPush-REST-API-Key-Creator"] = api_token_creator
      faraday.headers["X-TwinPush-REST-API-Token"] = api_token
      extra_headers.each do |key, value|
        faraday.headers[key] = value
      end
    end
    yield connection
  end

  def build_response(response)
    body = response.body || {}
    response_hash = { body: body, headers: response.headers, status_code: response.status }
    case response.status
    when 200
      response_hash[:response] = 'success'
    when 403
      response_hash[:response] = 'API Key Token or Creator API Key Token are not valid or does not match with App ID'
    when 404
      response_hash[:response] = 'Application not found for given application_id, device not found for given device_id or delivery not found for given notification and device'
    when 422
      response_hash[:response] = 'Some of the parameters given is not valid when trying to create a notification, create a device property or register or update a device'
    when 500..599
      response_hash[:response] = 'There was an internal error in the Twinpush server while trying to process the request.'
    end
    response_hash
  end


end