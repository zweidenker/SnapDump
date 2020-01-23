Class {
	#name : #SDTLReader,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'SnapDump-Core'
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
	self upToType: aTypeId.
	size := (self stream next: 4) asInteger.
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

	| currentType size |
	currentType := self stream next.
	[(currentType = aTypeId) or: [self stream atEnd]] whileFalse: [ 
			size := (self stream next: 4) asInteger.
			self stream skip: size.
			self stream next.
	 ].
]
