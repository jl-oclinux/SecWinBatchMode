SOFT:=SWMB
VERSION:=$(shell grep '!define VERSION' ../../package.nsi | cut -f 2 -d '"')
PATCH:=1
DATE:=$(shell date '+%Y/%m/%d')

.PHONY: all help update clean

all: $(SOFT)-WAPT-$(VERSION)-$(PATCH).zip


help:
	@echo "all      Création de l'archive zip"
	@echo "clean    Nettoyage du dossier"
	@echo "update   Réalise un git pull (mise à jour) du projet SWMB à sa racine"


update:
	(cd ../..; git pull)


clean:
	rm -f $(SOFT)-WAPT-$(VERSION)-$(PATCH).zip
	rm -rf tmp


%.zip: Makefile
	@rm -rf ./tmp
	@mkdir -p ./tmp/swmb/WAPT
	@perl -p -e ' \
		s/__VERSION__/$(VERSION)/; \
		s/__PATCH__/$(PATCH)/;' control > ./tmp/swmb/WAPT/control
	@perl -p -e 's{__DATE__}{$(DATE)};' README.md > ./tmp/swmb/README.md
	@cp -f ../../LICENSE.md setup.py ./swmb.png ./tmp/swmb/
	@rm -f $@
	@(cd ../..; \
		make pkg; \
		cp SWMB-Setup-$(VERSION).exe ./dists/wapt/tmp/swmb/ \
		)
	@(cd tmp; \
		zip -r ../$@ swmb)
	@chmod ugo+rw $@
