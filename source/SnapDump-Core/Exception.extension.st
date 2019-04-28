Extension { #name : #Exception }

{ #category : #'*snapdump-core' }
Exception >> asSnapshot [
	^ SDMemorySnapshot exception: self
]
