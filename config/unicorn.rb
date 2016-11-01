# -*- coding: utf-8 -*-
@app_path = '/home/vpsuser/projects/test1028'
working_directory @app_path

worker_processes 4
preload_app true
timeout 30
listen "/home/vpsuser/projects/test1028/tmp/unicorn.sock", :backlog => 64

pid "#{@app_path}/tmp/pids/unicorn.pid"
# pid "#{@app_path}/shared/tmp/pids/unicorn.pid"
stderr_path "#{@app_path}/log/unicorn.stderr.log"
stdout_path "#{@app_path}/log/unicorn.stdout.log"

before_fork do |server, worker|
        ENV['BUNDLE_GEMFILE'] = File.expand_path('Gemfile', ENV['RAILS_ROOT'])
end

before_fork do |server, worker|
        if defined?(ActiveRecord::Base)
                ActiveRecord::Base.connection.disconnect!
        end

        old_pid = "#{server.config[:pid]}.oldbin"
        if File.exists?(old_pid) && server.pid != old_pid
                begin
                        Process.kill("QUIT", File.read(old_pid).to_i)
                rescue Errno::ENOENT, Errno::ESRCH
                end
                end
end

after_fork do |server, worker|
        if defined?(ActiveRecord::Base)
                ActiveRecord::Base.establish_connection
        end
end
