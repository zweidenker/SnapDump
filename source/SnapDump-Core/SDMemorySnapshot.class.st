Class {
	#name : #SDMemorySnapshot,
	#superclass : #SDSnapshot,
	#instVars : [
		'context'
	],
	#category : #'SnapDump-Core'
}

{ #category : #accessing }
SDMemorySnapshot >> buildId [
	^ (SHA256 hashMessage: self fullSignature) hex

]

{ #category : #accessing }
SDMemorySnapshot >> context [
	^ context
]

{ #category : #private }
SDMemorySnapshot >> encodeMetaOn: aSerializer [
	self metaFields do: [ :field |
		aSerializer at: field putAdditionalObject: (self perform: field asSymbol) ]
]

{ #category : #accessing }
SDMemorySnapshot >> exception: exception [
	self 
		setContext: exception signalerContext 
		exceptionClassName: exception class name

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
	self encodeMetaOn: serializer.
	serializer addPostMaterializationAction: [ :materialization | | session |
		session := Processor activeProcess newDebugSessionNamed: 'External stack' startedAt: materialization root.
		Smalltalk tools debugger openOn: session withFullView: true].
	serializer
		serialize: aContext
		on: stream
]

{ #category : #accessing }
SDMemorySnapshot >> setContext: aContext exceptionClassName: exceptionClassName [
	| method |
	context := aContext.
	method := context sender method.
	className := method classBinding key asString.
	selector :=  (method selector asString copyWithout: $:) .
	exceptionClass := exceptionClassName

]

{ #category : #writing }
SDMemorySnapshot >> writeTo: stream [
	self 
		serializeContext: context 
		on: stream 
]
