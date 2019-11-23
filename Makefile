.PHONY: serve clean update install

IP := $(shell ifconfig | grep 'inet' | head -1 | sed 's/.*inet \(.*\) netmask.*/\1/')

clean: 
	bundle exec jekyll clean
serve:
	bundle exec jekyll serve --host=$(IP)
	
update:
	bundle update
install:
	bundle install
