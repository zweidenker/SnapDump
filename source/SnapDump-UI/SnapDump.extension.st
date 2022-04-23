Extension { #name : #SnapDump }

{ #category : #'*SnapDump-UI' }
SnapDump class >> ui [

	^ SnapDumpUI new
		  snapDump: self client;
		  open
]
