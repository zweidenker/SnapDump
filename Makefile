docker: SnapDump.image
	docker build -t zweidenker/snap-dump:latest .

SnapDump.image: Pharo.image
	./pharo Pharo.image save SnapDump
	./pharo Pharo.image eval --save "Metacello new repository: 'github://zweidenker/SnapDump/source'; baseline: #SnapDump; load"

Pharo.image:
	curl get.pharo.org/64/70+vm | bash

clean:
	rm -f SnapDump.image SnapDump.changes
	#rm -f pharo pharo-ui SnapDump.image SnapDump.changes
	#rm -rf pharo-vm
all: docker

