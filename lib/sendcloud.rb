# frozen_string_literal: true

require "json"
require "faraday"

require "sendcloud/client"
require "sendcloud/config"
require "sendcloud/version"

require "sendcloud/errors/client_error"
require "sendcloud/errors/response_error"
require "sendcloud/errors/bad_request_error"
require "sendcloud/errors/deleted_error"

require "sendcloud/operation"
require "sendcloud/operations/cancel_parcel_request"
require "sendcloud/operations/create_parcel_request"
require "sendcloud/operations/create_shipment_request"
require "sendcloud/operations/parcels_request"
require "sendcloud/operations/printer_label_request"
require "sendcloud/operations/shipping_methods_request"
require "sendcloud/operations/tracking_request"

module Sendcloud
end
