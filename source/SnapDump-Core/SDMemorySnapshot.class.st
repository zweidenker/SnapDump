Class {
	#name : #SDMemorySnapshot,
	#superclass : #SDSnapshot,
	#instVars : [
		'context'
	],
	#category : #'SnapDump-Core'
}

{ #category : #'instance-creation' }
SDMemorySnapshot class >> fromException: anException [

	^ self new 
			smalltalkException: anException;
			yourself
]

{ #category : #accessing }
SDMemorySnapshot >> context [
	^ context
]

{ #category : #initialization }
SDMemorySnapshot >> initialize [ 
	super initialize.	
	operatingSystem := Smalltalk os name asString.
	systemArchitecture := Smalltalk os subtype asString.
	operatingSystemVersion :=  Smalltalk os version asString.
	vmVersion := Smalltalk vm version asString.
	imageVersion := SystemVersion current version asString.
	imageBuild := Smalltalk lastUpdateString asString
]

{ #category : #'as yet unclassified' }
SDMemorySnapshot >> serializeContext: aContext on: stream [
	| serializer |
	
	serializer := FLSerializer newDefault.
	serializer addPostMaterializationAction: [ :materialization | | session |
		session := Processor activeProcess newDebugSessionNamed: 'External stack' startedAt: materialization root.
		Smalltalk tools debugger openOn: session withFullView: true].
	serializer
		serialize: aContext
		on: stream
]

{ #category : #initialization }
SDMemorySnapshot >> setContext: aContext exceptionClassName: exceptionClassName [
	| method |
	context := aContext.
	self
		stackTrace:
			(String streamContents: [ :stream | context errorReportOn: stream ]).
	method := context sender method.
	self
		exception:
			(SDException new
				initializeFromClassName: exceptionClassName method: method;
				yourself)
]

{ #category : #initialization }
SDMemorySnapshot >> smalltalkException: anException [
	self 
		setContext: anException signalerContext 
		exceptionClassName: anException class name

]

{ #category : #writing }
SDMemorySnapshot >> writeTo: stream [
	self writeMetaOn: stream.
	stream nextPut: self class metaSeparator.
	self 
		serializeContext: context 
		on: stream.
	stream nextPut: self class metaSeparator.
	stream nextPutAll: (self stackTrace) utf8Encoded 
		 
]
