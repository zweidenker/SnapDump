Extension { #name : #Exception }

{ #category : #'*snapdump-core' }
Exception >> asSnapshot [
	^ SDMemorySnapshot fromException: self
]
