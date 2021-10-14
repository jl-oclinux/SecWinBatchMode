
.PHONY: help pkg check clean

help:
	@echo "pkg    create .exe installer"
	@echo "check  check tweaks"

pkg:
	makensis package.nsi

check:
	./check-projectcheck:

clean:
	rm -f SWMB*.exe
