run:
	bin/dev

test:
	bundle exec rspec

console:
	bin/rails console

reset_db:
	bin/rails db:drop db:create db:migrate db:seed

lint:
	bundle exec standardrb --format progress

lint_fix:
	bundle exec standardrb --fix --format progress
