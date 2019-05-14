Extension { #name : #SnapDump }

{ #category : #'*SnapDump-UI' }
SnapDump class >> ui [ 
	^ SnapDumpUI new 
		snapDump: (SDClient new store: self current store);
		openWithSpec
]
