# frozen_string_literal: true

require "json"
require "faraday"

require "sendcloud/client"
require "sendcloud/config"
require "sendcloud/operation"
require "sendcloud/operations/create_parcel_request"
require "sendcloud/operations/create_shipment_request"
require "sendcloud/operations/printer_label_request"
require "sendcloud/operations/shipping_methods_request"
require "sendcloud/response_error"
require "sendcloud/version"

module Sendcloud
end
