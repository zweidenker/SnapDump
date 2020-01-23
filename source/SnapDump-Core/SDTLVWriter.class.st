Class {
	#name : #SDTLVWriter,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'SnapDump-Core'
}

{ #category : #'instance creation' }
SDTLVWriter class >> on: aBinaryWriteStream [

	^ self new 
		stream: aBinaryWriteStream;
		yourself
]

{ #category : #accessing }
SDTLVWriter >> stream [

	^ stream
]

{ #category : #accessing }
SDTLVWriter >> stream: aBinaryWriteStream [

	stream := aBinaryWriteStream
]

{ #category : #api }
SDTLVWriter >> writeType: aTypeNumber with: aBlock [
	| startPosition endPosition size |
	self stream
		"the type of the data"
		nextPutAll: (aTypeNumber asByteArrayOfSize: 1);
		"the length of the data. First filled with 0"
		nextPutAll: (0 asByteArrayOfSize: 4).
	
	startPosition := self stream position.
	aBlock valueWithArguments: (Array with: self stream).
	endPosition := self stream position.
	size := endPosition - startPosition.
	self stream position: startPosition - 4.
	self stream nextPutAll: (size asByteArrayOfSize: 4).
	self stream position: endPosition
]
