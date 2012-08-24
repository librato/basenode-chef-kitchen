current_dir = File.dirname(__FILE__)

cookbook_path [ "#{current_dir}/../cookbooks",
	        "#{current_dir}/../site-cookbooks" ]

log_level                :info
log_location             STDOUT
