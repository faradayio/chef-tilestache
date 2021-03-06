#
# Cookbook Name:: tilestache
# Recipe:: gunicorn
#
# Copyright 2013, Mapzen
#
# All rights reserved - Do Not Redistribute
#

python_pip 'gunicorn' do
  version node[:tilestache][:gunicorn][:version]
end

case node[:tilestache][:gunicorn][:worker_class]
when 'tornado'
  package 'python-tornado'
when 'gevent'
  package 'python-gevent'
end

gunicorn_config "#{node[:tilestache][:gunicorn][:cfgbasedir]}/#{node[:tilestache][:gunicorn][:cfg_file]}" do
  listen              "#{node[:ipaddress]}:#{node[:tilestache][:gunicorn][:port]}"
  pid                 "#{node[:tilestache][:gunicorn][:piddir]}/#{node[:tilestache][:gunicorn][:pidfile]}"
  backlog             node[:tilestache][:gunicorn][:backlog]
  preload_app         node[:tilestache][:gunicorn][:preload]
  worker_max_requests node[:tilestache][:gunicorn][:max_requests]
  worker_processes    node[:tilestache][:gunicorn][:workers]
  worker_keepalive    node[:tilestache][:gunicorn][:keepalive]
  worker_timeout      node[:tilestache][:gunicorn][:timeout]
  worker_class        node[:tilestache][:gunicorn][:worker_class]

  if node[:tilestache][:init_type]
    case node[:tilestache][:supervisor]
    when true
      notifies :restart, 'supervisor_service[tilestache]', :delayed
    else
      notifies :restart, 'service[tilestache]', :delayed
    end
  end
end
