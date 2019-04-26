Extension { #name : #Exception }

{ #category : #'*snapdump-core' }
Exception >> asSnapshot [
	^ SDSnapshot exception: self
]
