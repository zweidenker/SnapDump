Extension { #name : #SnapDump }

{ #category : #'*SnapDump-Handler' }
SnapDump class >> handler [
	^ SDHandler new
		store: self current store;
		yourself
]
