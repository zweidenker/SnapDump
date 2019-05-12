Extension { #name : #Context }

{ #category : #'*SnapDump-Core' }
Context >> asSnapshot [ 
	^ SDMemorySnapshot new 
		setContext: self exceptionClassName: 'ContextWithoutException'
]
