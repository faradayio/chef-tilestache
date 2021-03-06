require 'spec_helper'

describe 'tilestache::default' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set[:tilestache][:gunicorn_proxy]  = true
    end.converge(described_recipe)
  end

  it 'should python_pip install gunicorn' do
    chef_run.should install_python_pip('gunicorn').with(
      version: '18.0'
    )
  end

  context 'tornado worker class' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set[:tilestache][:gunicorn][:worker_class] = 'tornado'
      end.converge(described_recipe)

      it 'should install tornado' do
        chef_run.should install_package 'python-tornado'
      end
      it 'should not install gevent' do
        chef_run.should_not install_package 'python-gevent'
      end
    end
  end

  context 'gevent worker class' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set[:tilestache][:gunicorn][:worker_class] = 'gevent'
      end.converge(described_recipe)

      it 'should install gevent' do
        chef_run.should install_package 'python-gevent'
      end
      it 'should not install tornado' do
        chef_run.should_not install_package 'python-tornado'
      end
    end
  end

  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'should create gunicorn config' do
    chef_run.should create_gunicorn_config('/etc/tilestache/gunicorn.cfg').with(
      pid:                  '/var/log/tilestache/pids/gunicorn.pid',
      backlog:              2048,
      preload_app:          false,
      worker_max_requests:  0,
      worker_keepalive:     5,
      worker_class:         'sync'
    )
  end

end
