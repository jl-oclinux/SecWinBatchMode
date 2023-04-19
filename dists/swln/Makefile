
SOFT:=SWLN
VERSION:=5.18
PATCH:=1
SWMB_VERSION:=3.14.10.0


.PHONY: all clean ocs setup

all: $(SOFT)-$(VERSION)-$(PATCH).zip ocs

setup: $(SOFT)-Setup-$(VERSION).exe

clean:
	@rm -rf tmp
	@rm -f $(SOFT)-$(VERSION)-$(PATCH).zip
	@rm -f SWMB-Setup-*.exe
	@find . -name '*.bak' -delete

%.zip: Makefile
	@mkdir -p tmp
	@(cd tmp ; \
		curl -# --remote-name --insecure "https://resinfo-gt.pages.in2p3.fr/swmb/resinfo-swmb/SWMB-Setup-$(SWMB_VERSION).exe" ; \
		file "SWMB-Setup-$(SWMB_VERSION).exe" | grep -q "PE32 executable" || echo "Error: bad format for binary SWMB-Setup-$(SWMB_VERSION).exe" ; \
		which peres >/dev/null && { peres -a "SWMB-Setup-$(SWMB_VERSION).exe" | grep -q "^Product Version:[[:space:]]*$(SWMB_VERSION)" || echo "Error: bad version for binary SWMB-Setup-$(SWMB_VERSION).exe" ; } ; \
		)
	@perl -p -e ' \
		s/^(SET\ssoftversion=)\d[\.\d]+/$${1}$(VERSION)/; \
		s/^(SET\ssoftpatch=)\d+/$${1}$(PATCH)/; \
		s/^(SET\sswmbversion=)\d[\.\d]+/$${1}$(SWMB_VERSION)/;' install.bat > tmp/install.bat
	@perl -p -e ' \
		s/^(\$$SWLNVersion = )"\d[\.\d]+"/$${1}"$(VERSION)"/; \
		s/^(\$$SWMBVersion = )"\d[\.\d]+"/$${1}"$(SWMB_VERSION)"/;' post-install.ps1 > tmp/post-install.ps1
	@rm -f $@
	@zip --quiet -r $@ \
		uninstall.bat \
		logo-swmb.ico \
		CurrentUser-Logon.preset \
		LocalMachine-Boot.preset \
		LocalMachine-PostInstall.preset \
		Custom-VarOverload.psm1 \
		Local-Addon.psm1 \
		-x \*.git/*
		@# print/* 
	@(cd tmp ; \
		zip -r ../$@ install.bat post-install.ps1 SWMB-Setup-$(SWMB_VERSION).exe ; \
		)
	@chmod ugo+rw $@


ocs:
	@echo ""
	@echo "Name:     $(SOFT)-$(VERSION)-$(PATCH)"
	@echo "priority: *2*"
	@echo "Launch:   install.bat"
	@echo "Message:  no"
	@echo ""
	@echo "Service Informatique du LEGI"
	@echo " --- "
	@echo "Installation et/ou mise à jour de $(SOFT)"
	@echo ""
