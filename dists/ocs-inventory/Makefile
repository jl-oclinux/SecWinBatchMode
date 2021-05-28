SOFT:=SWMB
VERSION:=1.0
PATCH:=1



.PHONY: all help update clean ocs

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs


help:
	@echo "all      Création de l'archive zip"
	@echo "ocs      Aide pour le téléversement de l'archive dans OCS"
	@echo "clean    Nettoyage du dossier"
	@echo "update   Réalise un git pull (mise à jour) du projet SWMB à sa racine"


update:
	(cd ../..; git pull)


clean:
	rm -f $(SOFT)-$(VERSION)-$(PATCH).zip


%.zip: Makefile
	perl -pi.bak -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat
	rm -f $@
	zip -r $@ install.bat
	(cd ../..; zip -r dists/ocs/$@ \
		Presets/*.preset \
		Modules/*.psm1 \
		Modules/SWMB/*.psm1 \
		Win10.ps1 \
		-x \*.git/* \
		)
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
