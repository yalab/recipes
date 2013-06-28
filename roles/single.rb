name 'single'
description 'Single server as roles web, app, db.'
run_list 'recipe[nginx]', 'recipe[mysql]', 'recipe[mysql::server]', 'recipe[database::mysql]', 'recipe[unicorn]'
