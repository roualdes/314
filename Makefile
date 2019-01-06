.PHONY: help book clean serve ready

help:
	@echo "Please use 'make <target>' where <target> is one of:"
	@echo "  install     to install the necessary dependencies for jupyter-book to build"
	@echo "  book        to convert the `content/` folder into Jekyll markdown in `_build/`"
	@echo "  clean       to clean out site build files"
	@echo "  runall      to run all notebooks in-place, capturing outputs with the notebook"
	@echo "  serve       to serve the repository locally with Jekyll"
	@echo "  build       to build the site HTML locally with Jekyll, and move it to `docs/`"


install:
	gem install bundler
	bundle install

book:
	python scripts/license.py --path ./content
	python scripts/generate_book.py

runall:
	python scripts/execute_all_notebooks.py

clean:
	python scripts/clean.py

serve:
	bundle exec guard

build:
	bundle exec jekyll build
	 cp -r _site docs
	echo "Deployed to the docs/ folder"

test:
	pytest scripts/tests/test_build.py

ready:
	make clean
	make book
	make build
