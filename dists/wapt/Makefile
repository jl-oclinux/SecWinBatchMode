SOFT:=SWMB
VERSION:=$(shell grep '!define VERSION' ../../tmp/package.nsi | cut -f 2 -d '"')
REVISION:=1
DATE:=$(shell date '+%Y/%m/%d')

.PHONY: all help update clean

all: $(SOFT)-WAPT-$(VERSION)-$(REVISION).zip


help:
	@echo "all      create a Zip archive"
	@echo "clean    clean folder"
	@echo "update   make a git pull (update local repository)"


update:
	(cd ../..; git pull)


clean:
	rm -f $(SOFT)-WAPT-$(VERSION)-$(REVISION).zip
	rm -rf tmp


%.zip: Makefile
	@rm -rf ./tmp
	@mkdir -p ./tmp/swmb/WAPT
	@sed -e 's/__VERSION__/$(VERSION)/; s/__REVISION__/$(REVISION)/;' control > ./tmp/swmb/WAPT/control
	@perl -p -e 's{__DATE__}{$(DATE)};' README.md > ./tmp/swmb/README.md
	@cp -f ../../LICENSE.md setup.py ./swmb.png ./tmp/swmb/
	@rm -f $@
	@(cd ../..; \
		make; \
		cp SWMB-Setup-$(VERSION).exe ./dists/wapt/tmp/swmb/ \
		)
	@(cd tmp; \
		zip -r ../$@ swmb)
	@chmod ugo+rw $@
