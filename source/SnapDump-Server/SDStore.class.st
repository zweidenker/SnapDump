Class {
	#name : #SDStore,
	#superclass : #Object,
	#instVars : [
		'nameStrategy'
	],
	#category : #'SnapDump-Server-Store'
}

{ #category : #lookup }
SDStore class >> withName: aString [
	^ self subclasses detect: [ :each | each storeName = aString ]
]

{ #category : #'as yet unclassified' }
SDStore >> createDebugContextFrom: exception [
	^ exception signalerContext 
]

{ #category : #'instance creation' }
SDStore >> descriptionFor: exception [
	| method |
	method := exception signalerContext sender method.
	^ { 
		'class' -> method classBinding key asString.
		'selector' -> (method selector asString copyWithout: $:) .
		'exceptionClass' -> (exception class name) } asDictionary 
]

{ #category : #'as yet unclassified' }
SDStore >> descriptionString: dict [
	^ (String streamContents: [:stream |
			stream 
				nextPutAll: (dict at: 'class');
				nextPut: $-;
				nextPutAll: (dict at: 'selector');
				nextPut: $-;
				nextPutAll: (dict at: 'exceptionClass') ])
]

{ #category : #private }
SDStore >> encodeDebugInformationOn: aSerializer [
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

{ #category : #testing }
SDStore >> hasSnapshotNamed: aString [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SDStore >> serializeContext: aContext on: stream [
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

{ #category : #'as yet unclassified' }
SDStore >> storeException: exception [
	| description |
	description := self descriptionFor: exception.
	(self hasSnapshotNamed: description)
		ifFalse: [ 
			self 
				storeDebugContext: (self createDebugContextFrom: exception)
				description: description ]
]
