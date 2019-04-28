Class {
	#name : #SDMemorySnapshot,
	#superclass : #SDSnapshot,
	#instVars : [
		'context'
	],
	#category : #'SnapDump-Core'
}

{ #category : #accessing }
SDMemorySnapshot >> context [
	^ context
]

{ #category : #private }
SDMemorySnapshot >> encodeDebugInformationOn: aSerializer [
	| str |
	
	str := String new writeStream. 
	str print: Date today; space; print: Time now.
	aSerializer at: #Timestamp putAdditionalObject: str contents. 
	
	str := String new writeStream. 
	str nextPutAll: 'VM: ';
		nextPutAll: Smalltalk os name asString;
		nextPutAll: ' - ';	
		nextPutAll: Smalltalk os subtype asString;
		nextPutAll: ' - ';
		nextPutAll: Smalltalk os version asString;
		nextPutAll: ' - ';
		nextPutAll: Smalltalk vm version asString.
	aSerializer at: #VM putAdditionalObject: str contents. 
		
	str := String new writeStream. 
	str nextPutAll: 'Image: ';
		nextPutAll:  SystemVersion current version asString;
		nextPutAll: ' [';
		nextPutAll: Smalltalk lastUpdateString asString;
		nextPutAll: ']'.
	aSerializer at: #Image putAdditionalObject: str contents.
]

{ #category : #accessing }
SDMemorySnapshot >> exception: exception [
	| method |
	method := exception signalerContext sender method.
	className := method classBinding key asString.
	selector :=  (method selector asString copyWithout: $:) .
	exceptionClass := (exception class name).
	context := exception signalerContext.
	id := (SHA256 hashMessage: self idString) hex
]

{ #category : #'as yet unclassified' }
SDMemorySnapshot >> serializeContext: aContext on: stream [
	| serializer |
	
	serializer := FLSerializer newDefault.
	self encodeDebugInformationOn: serializer.
	serializer addPostMaterializationAction: [ :materialization | | session |
		session := Processor activeProcess newDebugSessionNamed: 'External stack' startedAt: materialization root.
		Smalltalk tools debugger openOn: session withFullView: true].
	serializer
		serialize: aContext
		on: stream
]

{ #category : #writing }
SDMemorySnapshot >> writeTo: stream [
	self 
		serializeContext: context 
		on: stream 
]
