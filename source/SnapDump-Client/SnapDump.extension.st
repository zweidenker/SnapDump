Extension { #name : #SnapDump }

{ #category : #'*SnapDump-Client' }
SnapDump class >> client [
	^ SDClient new
		store: self store;
		yourself
]

{ #category : #'*SnapDump-Client' }
SnapDump class >> uri: aUri [
	^ self uri: aUri username: nil  password: nil
]
