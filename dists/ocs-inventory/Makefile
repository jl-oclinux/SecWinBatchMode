SOFT:=SWMB
VERSION:=$(shell grep '!define VERSION' ../../package.nsi | cut -f 2 -d '"')
PATCH:=1


.PHONY: all help update clean ocs

all: $(SOFT)-OCS-$(VERSION)-$(PATCH).zip ocs


help:
	@echo "all      Création de l'archive zip"
	@echo "ocs      Aide pour le téléversement de l'archive dans OCS"
	@echo "clean    Nettoyage du dossier"
	@echo "update   Réalise un git pull (mise à jour) du projet SWMB à sa racine"


update:
	(cd ../..; git pull)


clean:
	rm -f $(SOFT)-OCS-$(VERSION)-$(PATCH).zip
	rm -rf tmp


%.zip: Makefile
	mkdir -p tmp
	perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > tmp/install.bat
	rm -f $@
	(cd ../..; \
		make pkg; \
		cp SWMB-Setup-$(VERSION).exe ./dists/ocs-inventory/tmp/ \
		)
	(cd tmp; \
		cp ../README.md ./; \
		zip -r ../$@ install.bat README.md SWMB-Setup-$(VERSION).exe)
	chmod ugo+rw $@


ocs:
	@echo ""
	@echo "Name:     $(SOFT)-$(VERSION)-$(PATCH)"
	@echo "priority: 2"
	@echo "Launch:   install.bat"
	@echo "Message:  no"
	@echo ""
	@echo "RESINFO GT SWMB"
	@echo " --- "
	@echo "Installation et/ou mise à jour de $(SOFT)"
	@echo ""
