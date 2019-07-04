Extension { #name : #SnapDump }

{ #category : #'*SnapDump-Client' }
SnapDump class >> client [
	^ SDClient new
		store: self current store;
		yourself
]

{ #category : #'*SnapDump-Client' }
SnapDump class >> path: aPathString [
	^ self current 
		store: (SDFilesystemStore new path: aPathString asFileReference);
		yourself 
]

{ #category : #'*SnapDump-Client' }
SnapDump class >> uri: aUri [
	^ self current 
		store: (SDHTTPStore new uri: aUri asZnUrl);
		yourself 
]
