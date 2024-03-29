Extension { #name : #SnapDump }

{ #category : #'*SnapDump-Handler' }
SnapDump class >> handleException: exception [
	^ self handler handleException: exception 
]

{ #category : #'*SnapDump-Handler' }
SnapDump class >> handleSnapshot: aSnapshot [ 
	^ self handler handleSnapshot: aSnapshot 
]

{ #category : #'*SnapDump-Handler' }
SnapDump class >> handler [
	^ handler ifNil: [  
		handler := SDHandler new
		store: self store;
		yourself ]
]
