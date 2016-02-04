NAME = immutable-js
TYPEDOC = node_modules/.bin/typedoc
DEFINITIONS = immutable.d.ts

all: Contents/Resources

$(TYPEDOC):
	npm install

$(DEFINITIONS):
	wget https://raw.githubusercontent.com/facebook/immutable-js/master/dist/$(DEFINITIONS)

doc/index.html: $(TYPEDOC) $(DEFINITIONS)
	$(TYPEDOC) --out doc --includeDeclarations --entryPoint 'Immutable' --target ES6 --hideGenerator --verbose --mode file --theme minimal $(DEFINITIONS)

clean:
	- rm -r doc
	- rm $(NAME).tgz

Contents/Resources: doc/index.html
	ruby generate.rb doc/index.html

EXCLUDES = .* *.rb *.json *.ts *.tgz doc node_modules
dist:
	tar $(addprefix --exclude=,$(EXCLUDES)) -C .. -cvzf $(NAME).tgz $(NAME).docset

rebuild:
	- rm -rf Contents/Resources doc $(DEFINITIONS) $(NAME).tgz
	- make
