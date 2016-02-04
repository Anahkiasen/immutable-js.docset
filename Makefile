NAME = immutable-js
TYPEDOC = node_modules/.bin/typedoc
DEFINITIONS = immutable.d.ts
DOCUMENTATION = doc
RESOURCES = Contents/Resources

all: $(RESOURCES)

$(TYPEDOC):
	npm install

$(DEFINITIONS):
	wget https://raw.githubusercontent.com/facebook/immutable-js/master/dist/$(DEFINITIONS)

$(DOCUMENTATION)/index.html: $(TYPEDOC) $(DEFINITIONS)
	$(TYPEDOC) --out $(DOCUMENTATION) --includeDeclarations --entryPoint 'Immutable' --target ES6 --hideGenerator --verbose --mode file --theme minimal $(DEFINITIONS)

$(RESOURCES): $(DOCUMENTATION)/index.html
	ruby generate.rb $(DOCUMENTATION)/index.html

clean:
	- rm -rf $(RESOURCES)
	- rm -rf $(DOCUMENTATION)
	- rm $(DEFINITIONS)
	- rm $(NAME).tgz

rebuild: clean all

EXCLUDES = .* *.rb *.json *.ts *.tgz $(DOCUMENTATION) node_modules
dist:
	tar $(addprefix --exclude=,$(EXCLUDES)) -C .. -cvzf $(NAME).tgz $(NAME).docset
