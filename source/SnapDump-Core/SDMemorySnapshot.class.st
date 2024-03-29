Class {
	#name : #SDMemorySnapshot,
	#superclass : #SDSnapshot,
	#instVars : [
		'context'
	],
	#category : #'SnapDump-Core-Model'
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
SDMemorySnapshot >> serializeContextOn: stream [
	
	FLSerializer 
		serialize: context
		on: stream
]

{ #category : #initialization }
SDMemorySnapshot >> setContext: aContext exceptionClassName: exceptionClassName [
	| method |
	context := aContext.
	self
		stackTrace:
			(String streamContents: [ :stream | context errorReportOn: stream ]).
	method := context home method.
	self
		exception:
			(SDException new
				initializeFromClassName: exceptionClassName 
				receiver: aContext receiver 
				method: method;
				yourself)
]

{ #category : #initialization }
SDMemorySnapshot >> smalltalkException: anException [
	self 
		setContext: anException signalerContext 
		exceptionClassName: anException class name

]
