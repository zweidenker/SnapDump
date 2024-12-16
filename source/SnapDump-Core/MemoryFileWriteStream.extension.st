Extension { #name : 'MemoryFileWriteStream' }

{ #category : '*SnapDump-Core' }
MemoryFileWriteStream >> nextBytesPutAll: aCollection [
	^ self stream nextPutAll: aCollection
]
