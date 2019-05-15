Extension { #name : #SnapDump }

{ #category : #'*SnapDump-Handler' }
SnapDump class >> beHandler [
	| handler |
	handler := SDHandler new.
	self setCurrent: handler.
	^ handler

]

{ #category : #'*SnapDump-Handler' }
SnapDump class >> handler [
	^ SDHandler new
		store: self current store;
		yourself
]

{ #category : #'*SnapDump-Handler' }
SnapDump class >> setCurrent: anObject [
	current := anObject 
]
