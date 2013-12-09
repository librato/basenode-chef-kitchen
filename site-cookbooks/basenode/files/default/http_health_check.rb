#!/bin/env ruby

require 'rubygems'
require 'rest-client'
require 'json'

module HttpHealthCheck
  class << self
    def check_http(url, expected_status)
      begin
        response = RestClient.get(url)
        return expected_status == response.code, response
      rescue Exception => e
        return false, e
      end
    end

    def do_check(url, expected_status, service_key)
      ok, response = check_http(url, Integer(expected_status))
      notify_pd(response, service_key) unless ok
      return ok
    end

    def notify_pd(response, service_key)
      msg = response.to_s
      puts "FAILING WITH: #{msg}"

      incident_key = %x{hostname}.chomp
      post = {
        :service_key => service_key,
        :event_type => 'trigger',
        :description => msg,
        :incident_key => incident_key,
        :details => {
          :msg => msg,
          :check_uid => Process.uid,
          :check_gid => Process.gid
        }
      }

      pd_integration_url = "https://events.pagerduty.com/generic/2010-04-15/create_event.json"
      RestClient.post(pd_integration_url, post.to_json, :content_type => :json)

      exit 1
    end
  end
end

if __FILE__ == $0
  if ARGV.length == 3
    if HttpHealthCheck::do_check(*ARGV)
      exit(0)
    else
      exit(1)
    end
  else
    puts "Usage: health.rb <url> <expected-status> <service-key>"
    exit(-127)
  end
end
