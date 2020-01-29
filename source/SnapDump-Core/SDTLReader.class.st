Class {
	#name : #SDTLReader,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'SnapDump-Core-Base'
}

{ #category : #'instance creation' }
SDTLReader class >> on: aBinaryReadStream [

	^ self new 
		stream: aBinaryReadStream;
		yourself
]

{ #category : #api }
SDTLReader >> readType: aTypeId [

	| size |
	size := self upToType: aTypeId.
	^ self stream next:  size
]

{ #category : #acessing }
SDTLReader >> stream [ 
	
	^ stream
]

{ #category : #acessing }
SDTLReader >> stream: aBinaryReadStream [
	
	stream := aBinaryReadStream
]

{ #category : #api }
SDTLReader >> upToType: aTypeId [
	"position stream to the beginning of the requested type data.
	answers data size"

	| currentType size |
	currentType := self stream next.
	[(currentType = aTypeId) or: [self stream atEnd]] whileFalse: [ 
			size := (self stream next: 4) asInteger.
			self stream skip: size.
			currentType := self stream next.
	 ].
	^ (self stream next: 4) asInteger.
]
