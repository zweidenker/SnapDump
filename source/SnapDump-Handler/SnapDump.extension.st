Extension { #name : #SnapDump }

{ #category : #'*SnapDump-Handler' }
SnapDump class >> beHandler [
	self deprecated: 'handlers are always present now. This call is not necessary anymore'
]

{ #category : #'*SnapDump-Handler' }
SnapDump class >> hackUIManager [
	UIManager compile: 'logError: anError
		SnapDump current handleException: anError.
		super logError: anError'
]

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
