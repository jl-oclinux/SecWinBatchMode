
SOFT:=SWLN
SWLN_NAME:=SWLN
SWLN_VERSION:=5.18
PATCH:=1
SWMB_VERSION:=$(shell curl -s -L 'https://resinfo-gt.pages.in2p3.fr/swmb/resinfo-swmb/version.txt')


FILES:=uninstall.bat
FILES+=logo-swmb.ico
FILES+=$(shell ls -1 CurrentUser-Logon.preset        2> /dev/null)
FILES+=$(shell ls -1 LocalMachine-Boot.preset        2> /dev/null)
FILES+=$(shell ls -1 LocalMachine-PostInstall.preset 2> /dev/null)
FILES+=$(shell ls -1 Custom-VarOverload.psm1         2> /dev/null)
FILES+=$(shell ls -1 Local-Addon.psm1                2> /dev/null)

TFILES:=install.bat
TFILES+=post-install.ps1

IT_Team:=IT Team

sinclude extend-variables.mk

TFILES+=SWMB-Setup-$(SWMB_VERSION).exe

TMPFILES:=$(addprefix tmp/,$(TFILES))

.PHONY: all clean ocs check-exe version

all: check-exe $(SOFT)-$(SWLN_VERSION)-$(PATCH).zip

version:
	@echo "Soft    $(SOFT)"
	@echo "Name    $(SWLN_NAME)"
	@echo "Version $(SWLN_VERSION)"
	@echo "Patch   $(PATCH)"
	@echo "SWMB    $(SWMB_VERSION)"
	@echo "Files   $(FILES)"
	@echo "TFiles  $(TFILES)"

clean:
	@rm -rf tmp $(SOFT)-$(SWLN_VERSION)-$(PATCH).zip
	@find . -name '*.bak' -delete

tmp/install.bat: install.bat Makefile
	@mkdir -p tmp
	@sed -e 's/__SWLN_NAME__/$(SWLN_NAME)/; s/__SWLN_VERSION__/$(SWLN_VERSION)/; s/__PATCH__/$(PATCH)/; s/__SWMB_VERSION__/$(SWMB_VERSION)/;' install.bat > tmp/install.bat

tmp/post-install.ps1: post-install.ps1 Makefile
	@mkdir -p tmp
	@sed -e 's/__SWLN_NAME__/$(SWLN_NAME)/; s/__SWLN_VERSION__/$(SWLN_VERSION)/; s/__PATCH__/$(PATCH)/; s/__SWMB_VERSION__/$(SWMB_VERSION)/;' post-install.ps1 > tmp/post-install.ps1

tmp/SWMB-Setup-%.exe: Makefile
	@mkdir -p tmp
	@(cd tmp ; \
		curl -# --remote-name --insecure "https://resinfo-gt.pages.in2p3.fr/swmb/resinfo-swmb/SWMB-Setup-$(SWMB_VERSION).exe" ; \
		)

check-exe: tmp/SWMB-Setup-$(SWMB_VERSION).exe
	@(cd tmp ; \
		file "SWMB-Setup-$(SWMB_VERSION).exe" | grep -q "PE32 executable" || { echo "Error: bad format for binary SWMB-Setup-$(SWMB_VERSION).exe" 1>&2 ; exit 1; } ; \
		which peres >/dev/null && { peres -a "SWMB-Setup-$(SWMB_VERSION).exe" | grep -q "^Product Version:[[:space:]]*$(SWMB_VERSION)" || { echo "Error: bad version for binary SWMB-Setup-$(SWMB_VERSION).exe" 1>&2 ; exit 1; } ; } ; \
		)

%.zip: Makefile $(FILES) $(TMPFILES)
	@rm -f $@
	@zip --quiet -r $@ $(FILES) -x @zipignore.txt
	@(cd tmp ; zip --quiet -r ../$@ $(TFILES) -x @../zipignore.txt)
	@chmod ug+rw,o+r $@
	@du -sh $@
	@echo $$(($$(unzip -t "$@" | wc -l) - 1)) 'files and folders in Zip package'


ocs: all
	@echo ""
	@echo "Name:     $(SOFT)-$(SWLN_VERSION)-$(PATCH)"
	@echo "priority: *2*"
	@echo "Launch:   install.bat"
	@echo "Message:  no"
	@echo ""
	@echo "$(IT_Team)"
	@echo " --- "
	@echo "Install and Update: $(SOFT) v$(SWLN_VERSION) (SWMB v$(SWMB_VERSION))"
	@echo ""

sinclude extend-rules.mk
