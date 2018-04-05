PREFIX:=/usr/local

install:
	cp ramdisks-service.sh ramdisk.sh $(PREFIX)/bin/
	cp ./RamdisksService.plist /Library/LaunchDaemons
	launchctl load -w /Library/LaunchDaemons/RamdisksService.plist
	
uninstall:
	launchctl unload -w /Library/LaunchDaemons/RamdisksService.plist
	rm -f /Library/LaunchDaemons/RamdisksService.plist
	$(prefix)/ramdisks-service.sh stop
	rm -f ramdisks-service.sh ramdisk.sh

