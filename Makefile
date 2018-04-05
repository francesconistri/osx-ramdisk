PREFIX:=/usr/local

install:
	cp ramdisks-service.sh ramdisk.sh $(PREFIX)/bin/
	sudo cp ./com.rj.ramdisks.plist /Library/LaunchDaemons
	sudo launchctl load -w /Library/LaunchDaemons/com.rj.ramdisks.plist
	
uninstall:
	sudo launchctl unload -w /Library/LaunchDaemons/com.rj.ramdisks.plist
	sudo rm -f /Library/LaunchDaemons/com.rj.ramdisks.plist
	$(PREFIX)/ramdisks-service.sh stop
	rm -f $(PREFIX)/ramdisks-service.sh $(PREFIX)/ramdisk.sh

