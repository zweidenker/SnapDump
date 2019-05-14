Extension { #name : #SnapDump }

{ #category : #'*SnapDump-Client' }
SnapDump class >> client [
	^ SDClient new
		store: self current store;
		yourself
]
