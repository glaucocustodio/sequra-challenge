run:
	bin/rails server

test:
	bundle exec rspec

console:
	bin/rails console

lint:
	bundle exec standardrb --format progress

lint_fix:
	bundle exec standardrb --fix --format progress
