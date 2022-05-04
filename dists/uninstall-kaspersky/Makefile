SOFT:=Kasperky-Uninstall
VERSION:=$(shell grep '!define VERSION' ../../package.nsi | cut -f 2 -d '"')
PATCH:=1


.PHONY: all help update clean key zip ocs

all: key zip ocs


help:
	@echo "all      create a zip archive"
	@echo "ocs      help for upload the Zip archive in OCS server"
	@echo "clean    clean folder"
	@echo "update   make a git pull (update local repository)"


update:
	(cd ../..; git pull)


clean:
	rm -f $(SOFT)-$(VERSION)-$(PATCH).zip
	rm -rf tmp
	rm -rf *.key Custom-Var*.psm1


key:
	@pwsh set-password-encrypted.ps1


zip: $(SOFT)-$(VERSION)-$(PATCH).zip

%.zip: Makefile
	mkdir -p ./tmp/WAPT
	perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/;' install.bat > tmp/install.bat
	@perl -p -e ' \
		s/__VERSION__/$(VERSION)/; \
		s/__PATCH__/$(PATCH)/;' control > ./tmp/WAPT/control
	@cp ../../Modules/SWMB.psm1 ../../Modules/SWMB/Custom.psm1 ../../Modules/SWMB/Custom-VarDefault.psm1 ../../Modules/SWMB/Experimental.psm1 ./tmp/; \
		cp ./README.md ./get-password-cleartext.ps1 ./set-password-encrypted.ps1 ./Custom-VarAutodel.psm1 ./*.key ./tmp/; \
		cp ./uninstall-kaspersky-standalone.ps1 ./tmp/uninstall-kaspersky.ps1; \
		cp -f ../../LICENSE.md ./setup.py ./tmp/
	rm -f $@
	(cd tmp; zip -r ../$@ install.bat README.md *.ps1 *.psm1 *.key setup.py LICENSE.md WAPT)
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
	@echo "Remove software $(SOFT)"
	@echo ""
