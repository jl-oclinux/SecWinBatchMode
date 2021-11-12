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
	makensis package.nsi

check:
	./check-projectcheck:

clean:
	rm -f SWMB*.exe
