NAME = immutable-js
TYPEDOC = node_modules/.bin/typedoc
DEFINITIONS = immutable.d.ts
DOCUMENTATION = doc

all: Contents/Resources

$(TYPEDOC):
	npm install

$(DEFINITIONS):
	wget https://raw.githubusercontent.com/facebook/immutable-js/master/dist/$(DEFINITIONS)

$(DOCUMENTATION)/index.html: $(TYPEDOC) $(DEFINITIONS)
	$(TYPEDOC) --out $(DOCUMENTATION) --includeDeclarations --entryPoint 'Immutable' --target ES6 --hideGenerator --verbose --mode file --theme minimal $(DEFINITIONS)

clean:
	- rm -r $(DOCUMENTATION)
	- rm $(NAME).tgz

Contents/Resources: $(DOCUMENTATION)/index.html
	ruby generate.rb $(DOCUMENTATION)/index.html

EXCLUDES = .* *.rb *.json *.ts *.tgz $(DOCUMENTATION) node_modules
dist:
	tar $(addprefix --exclude=,$(EXCLUDES)) -C .. -cvzf $(NAME).tgz $(NAME).docset

rebuild:
	- rm -rf Contents/Resources $(DOCUMENTATION) $(DEFINITIONS) $(NAME).tgz
	- make
