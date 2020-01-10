Class {
	#name : #SDSnapshot,
	#superclass : #Object,
	#instVars : [
		'timestamp',
		'project',
		'version',
		'className',
		'selector',
		'exceptionClass',
		'operatingSystem',
		'systemArchitecture',
		'operatingSystemVersion',
		'vmVersion',
		'imageVersion',
		'imageBuild',
		'snapshotId',
		'exceptionId',
		'versionString',
		'projectName',
		'exception'
	],
	#category : #'SnapDump-Core'
}

{ #category : #'as yet unclassified' }
SDSnapshot class >> exception: anException [
	^ self new exception: anException
]

{ #category : #'as yet unclassified' }
SDSnapshot class >> metaSeparator [
	^ 255
]

{ #category : #accessing }
SDSnapshot class >> neoJsonMapping: mapper [
	mapper for: self do: [ :mapping |
		mapping mapAccessors: #( projectName versionString ).
		(mapping mapInstVar: #timestamp) valueSchema: DateAndTime.
		mapping mapInstVars: #(exceptionId snapshotId className selector exceptionClass operatingSystem systemArchitecture operatingSystemVersion vmVersion imageVersion imageBuild) ].
	mapper for: DateAndTime customDo: [ :mapping |
		mapping decoder: [ :string | DateAndTime fromString: string ].
		mapping encoder: [ :dateAndTime | dateAndTime printString ] ].

]

{ #category : #converting }
SDSnapshot >> asSnapshot [
	^ self 
]

{ #category : #private }
SDSnapshot >> basicMetaFields [
	^ #(projectName versionString snapshotId exceptionId timestamp className selector exceptionClass operatingSystem systemArchitecture operatingSystemVersion vmVersion imageVersion imageBuild)
]

{ #category : #private }
SDSnapshot >> buildExceptionId [
	^ (SHA256 hashMessage: self errorSignature) hex

]

{ #category : #private }
SDSnapshot >> buildSnapshotId [
	^ (SHA256 hashMessage: self snapshotSignature) hex

]

{ #category : #accessing }
SDSnapshot >> className [
	^ className
]

{ #category : #accessing }
SDSnapshot >> className: aString [ 
	className := aString
]

{ #category : #accessing }
SDSnapshot >> dateAndTimeString [ 
	^ String streamContents: [ :stream |
		stream << self dateString << ' ' << self timeString  ]
]

{ #category : #accessing }
SDSnapshot >> dateString [ 
	^ timestamp asDate printFormat: #(1 2 3 $. 1 1)
]

{ #category : #private }
SDSnapshot >> encodeMetaOn: aSerializer [
	self metaFields do: [ :field |
		aSerializer at: field putAdditionalObject: (self perform: field asSymbol) ]
]

{ #category : #signatures }
SDSnapshot >> errorSignature [
	^ self exception fullSignature
]

{ #category : #signatures }
SDSnapshot >> errorSignatureOn: stream [

	^  stream 
			<< self projectName asString 
			<< '_'
			<< self versionString asString 
			<< '_'
			<< className 
			<< '_'
			<< selector 
			<< '_'
			<< exceptionClass 
]

{ #category : #accessing }
SDSnapshot >> exception [ 
	
	^ exception 
]

{ #category : #accessing }
SDSnapshot >> exception: aSDException [
	
	exception := aSDException. 

]

{ #category : #accessing }
SDSnapshot >> exceptionClass [
	^ exceptionClass
]

{ #category : #accessing }
SDSnapshot >> exceptionClass: aString [ 
	exceptionClass := aString
]

{ #category : #accessing }
SDSnapshot >> exceptionId [ 
	^ exceptionId 
]

{ #category : #accessing }
SDSnapshot >> exceptionId: aString [
	exceptionId := aString
]

{ #category : #accessing }
SDSnapshot >> imageBuild [
	^ imageBuild
]

{ #category : #accessing }
SDSnapshot >> imageBuild: aString [ 
	imageBuild := aString
]

{ #category : #accessing }
SDSnapshot >> imageVersion [
	^ imageVersion
]

{ #category : #accessing }
SDSnapshot >> imageVersion: aString [ 
	imageVersion := aString
]

{ #category : #initialization }
SDSnapshot >> initialize [
	super initialize.
	timestamp := DateAndTime now
]

{ #category : #initialization }
SDSnapshot >> initializeException [
		
	exception := SDException new 
		id:  exceptionId;
		exceptionSignalerSelector: selector;
		exceptionSignalerClassName: exceptionClass;
		exceptionClassName: className;
		yourself.
	self initializeVersion
		 
]

{ #category : #initialization }
SDSnapshot >> initializeExceptionProperties [

	exceptionClass := self exception exceptionClassName.
	selector := self exception exceptionSignalerSelector.
	className := self exception exceptionSignalerClassName. 

]

{ #category : #initialization }
SDSnapshot >> initializeVersion [
	self version: self newVersion
		 
]

{ #category : #private }
SDSnapshot >> metaFields [
	^ self basicMetaFields asOrderedCollection
]

{ #category : #signatures }
SDSnapshot >> methodSignature [
	^ String streamContents: [ :stream |
		stream 
			<< className 
			<< '>>#'
			<< selector ]
]

{ #category : #initialization }
SDSnapshot >> newVersion [

	| newProject newVersion |
	newProject := (SDProject name: projectName).
	newVersion := (SDVersion string: versionString) project: newProject.
	^ newVersion 
		 
]

{ #category : #actions }
SDSnapshot >> openDebugger [
	FLMaterializer materializeFromByteArray: (
		self store snapshotDumpFor: self )
]

{ #category : #accessing }
SDSnapshot >> operatingSystem [
	^ operatingSystem
]

{ #category : #accessing }
SDSnapshot >> operatingSystem: aString [ 
	operatingSystem := aString
]

{ #category : #accessing }
SDSnapshot >> operatingSystemVersion [
	^ operatingSystemVersion
]

{ #category : #accessing }
SDSnapshot >> operatingSystemVersion: aString [ 
	operatingSystemVersion := aString
]

{ #category : #accessing }
SDSnapshot >> project [
	^ self exception project
]

{ #category : #accessing }
SDSnapshot >> project: aProject [
	project := aProject.
	projectName :=  aProject name
]

{ #category : #accessing }
SDSnapshot >> projectName [
	^ projectName
]

{ #category : #accessing }
SDSnapshot >> projectName: aString [
	
	projectName := aString
]

{ #category : #actions }
SDSnapshot >> remove [
	^ self store removeSnapshot: self 
]

{ #category : #accessing }
SDSnapshot >> selector [
	^ selector
]

{ #category : #accessing }
SDSnapshot >> selector: aString [ 
	selector := aString
]

{ #category : #accessing }
SDSnapshot >> snapshotId [ 
	^ snapshotId ifNil: [ 
		snapshotId := self buildSnapshotId ]
]

{ #category : #accessing }
SDSnapshot >> snapshotId: aString [
	snapshotId := aString
]

{ #category : #signatures }
SDSnapshot >> snapshotSignature [
	^ String streamContents: [ :stream |
		self exception fullSignatureOn: stream.
		stream 
			<< '_'
			<< timestamp printString ]
]

{ #category : #accessing }
SDSnapshot >> store [
	^ self version store
]

{ #category : #accessing }
SDSnapshot >> systemArchitecture [
	^ systemArchitecture
]

{ #category : #accessing }
SDSnapshot >> systemArchitecture: aString [ 
	systemArchitecture := aString
]

{ #category : #accessing }
SDSnapshot >> timeString [ 
	^ timestamp asTime print24
]

{ #category : #accessing }
SDSnapshot >> timestamp [
	^ timestamp
]

{ #category : #accessing }
SDSnapshot >> timestamp: aDateAndTime [ 
	timestamp := aDateAndTime
]

{ #category : #accessing }
SDSnapshot >> validate [
]

{ #category : #accessing }
SDSnapshot >> version [
	
	^ self exception version
]

{ #category : #accessing }
SDSnapshot >> version: aVersion [
	
	self exception version: aVersion.
	self versionString: aVersion string.
	self projectName: aVersion project name.
	self exceptionId: self exception id.
]

{ #category : #accessing }
SDSnapshot >> versionString [
	^ versionString
]

{ #category : #accessing }
SDSnapshot >> versionString: aString [ 
	
	versionString := aString
]

{ #category : #accessing }
SDSnapshot >> vmVersion [
	^ vmVersion
]

{ #category : #accessing }
SDSnapshot >> vmVersion: aString [ 
	vmVersion := aString
]

{ #category : #writing }
SDSnapshot >> writeMetaOn: stream [
	stream nextPutAll: (NeoJSONWriter toString: self) utf8Encoded 
]
