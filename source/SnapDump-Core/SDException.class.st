Class {
	#name : #SDException,
	#superclass : #Object,
	#instVars : [
		'string',
		'version',
		'id',
		'exceptionClassName',
		'exceptionSignalerClassName',
		'exceptionSignalerSelector'
	],
	#category : #'SnapDump-Core'
}

{ #category : #'instance-creation' }
SDException class >> id: aString [
	^ self new id: aString; yourself
]

{ #category : #accessing }
SDException class >> neoJsonMapping: mapper [
	mapper for: self do: [ :mapping |
		mapping mapInstVars: #(id exceptionSignalerClassName exceptionClassName exceptionSignalerSelector) ]
]

{ #category : #private }
SDException >> buildId [
	^ (SHA256 hashMessage: self fullSignature) hex
]

{ #category : #'accessing - exception properties' }
SDException >> exceptionClassName [

	^ exceptionClassName 
]

{ #category : #'accessing - exception properties' }
SDException >> exceptionClassName: aString [

	exceptionClassName := aString
]

{ #category : #'accessing - exception properties' }
SDException >> exceptionSignalerClassName [ 
	^ exceptionSignalerClassName
]

{ #category : #'accessing - exception properties' }
SDException >> exceptionSignalerClassName: aString [
	exceptionSignalerClassName := aString
]

{ #category : #'accessing - exception properties' }
SDException >> exceptionSignalerSelector [ 
	^ exceptionSignalerSelector 
]

{ #category : #'accessing - exception properties' }
SDException >> exceptionSignalerSelector: aString [
	exceptionSignalerSelector := aString
]

{ #category : #services }
SDException >> freeSlots [

	^ self store freeSlotsForException: self
]

{ #category : #signatures }
SDException >> fullSignature [
	^ String streamContents: [ :stream |
		self fullSignatureOn: stream  ]
]

{ #category : #signatures }
SDException >> fullSignatureOn: stream [

	stream 
			<< self projectName  
			<< '_'
			<< self versionString  
			<< '_'.
	self signatureOn: stream
]

{ #category : #accessing }
SDException >> id [ 
	
	^ id ifNil: [ id :=  self buildId ]
]

{ #category : #accessing }
SDException >> id: aString [
	
	id := aString
]

{ #category : #'accessing - exception properties' }
SDException >> initializeExceptionProperties [

	| snapshot |
	snapshot := self snapshots anyOne.
	exceptionClassName := snapshot exceptionClass.
	exceptionSignalerClassName := snapshot className.
	exceptionSignalerSelector := snapshot selector
]

{ #category : #initialization }
SDException >> initializeFromClassName: aName method: aSmalltalkMethod [

	exceptionSignalerClassName := aSmalltalkMethod classBinding key asString.
	exceptionSignalerSelector :=  (aSmalltalkMethod selector asString copyWithout: $:) .
	exceptionClassName := aName
]

{ #category : #accessing }
SDException >> project [

	^ version project
]

{ #category : #accessing }
SDException >> projectName [

	^ version projectName
]

{ #category : #accessing }
SDException >> selector [ 
	^ exceptionSignalerSelector
]

{ #category : #signatures }
SDException >> signalerSignature [
	^ String streamContents: [ :stream |
		self signalerSignatureOn: stream  ]
]

{ #category : #signatures }
SDException >> signalerSignatureOn: stream [
	
		stream 
			<< self exceptionSignalerClassName  
			<< '>>#'
			<< self exceptionSignalerSelector 
]

{ #category : #signatures }
SDException >> signature [
	^ String streamContents: [ :stream |
		self signatureOn: stream  ]
]

{ #category : #signatures }
SDException >> signatureOn: stream [

	stream 
			<< self exceptionClassName 
			<< ': '.
	self signalerSignatureOn: stream
]

{ #category : #services }
SDException >> snapshots [ 
	
	^ self store snapshotsOfException: self
]

{ #category : #accessing }
SDException >> store [
	^ version store
]

{ #category : #accessing }
SDException >> version [
	^ version
]

{ #category : #accessing }
SDException >> version: anObject [
	version := anObject
]

{ #category : #accessing }
SDException >> versionString [

	^ version string
]
