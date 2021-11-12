SOFT:=SWMB
VERSION:=$(shell grep '!define VERSION' ./package.nsi | cut -f 2 -d '"')

.PHONY: all help pkg version check clean

all: $(SOFT)-Setup-$(VERSION).exe

help:
	@echo "all    create .exe installer"
	@echo "check  check tweaks"
	@echo "clean  clean setup.exe file"

pkg: $(SOFT)-Setup-$(VERSION).exe

version:
	@echo $(VERSION)

%.exe:
	@mkdir -p tmp
	@sed -e "s/\(ModuleVersion = \)'.*$$/\1'$(VERSION)'/;" Modules/SWMB.psd1 > tmp/SWMB.psd1
	@echo "@{ ModuleVersion = '$(VERSION)' }" > tmp/Version.psd1
	makensis package.nsi

check:
	./check-projectcheck:

clean:
	rm -f SWMB*.exe
