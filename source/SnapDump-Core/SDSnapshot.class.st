Class {
	#name : #SDSnapshot,
	#superclass : #Object,
	#instVars : [
		'id',
		'timestamp',
		'store',
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
		'imageBuild'
	],
	#category : #'SnapDump-Core'
}

{ #category : #'as yet unclassified' }
SDSnapshot class >> exception: anException [
	^ self new exception: anException
]

{ #category : #accessing }
SDSnapshot class >> neoJsonMapping: mapper [
	mapper for: self do: [ :mapping |
		mapping mapInstVars: #(id project version className selector exceptionClass operatingSystem systemArchitecture operatingSystemVersion vmVersion imageVersion imageBuild).
		(mapping mapInstVar: #timestamp) valueSchema: DateAndTime ].
	mapper for: DateAndTime customDo: [ :mapping |
		mapping decoder: [ :string | DateAndTime fromString: string ].
		mapping encoder: [ :dateAndTime | dateAndTime printString ] ].

]

{ #category : #converting }
SDSnapshot >> asSnapshot [
	^ self 
]

{ #category : #'as yet unclassified' }
SDSnapshot >> basicMetaFields [
	^ #(id timestamp className selector exceptionClass operatingSystem systemArchitecture operatingSystemVersion vmVersion imageVersion imageBuild)
]

{ #category : #accessing }
SDSnapshot >> className [
	^ className
]

{ #category : #accessing }
SDSnapshot >> className: aString [ 
	className := aString
]

{ #category : #view }
SDSnapshot >> classSelector [
	^ String streamContents: [ :stream |
		stream << className << '>>#' << selector ]
]

{ #category : #'as yet unclassified' }
SDSnapshot >> errorSignature [
	^ String streamContents: [ :stream |
		stream 
			<< className 
			<< '_'
			<< selector 
			<< '_'
			<< exceptionClass  ]
]

{ #category : #accessing }
SDSnapshot >> exceptionClass [
	^ exceptionClass
]

{ #category : #accessing }
SDSnapshot >> exceptionClass: aString [ 
	exceptionClass := aString
]

{ #category : #'as yet unclassified' }
SDSnapshot >> fullSignature [
	^ String streamContents: [ :stream |
		stream 
			<< self projectName asString 
			<< '_'
			<< self versionString asString 
			<< '_'
			<< className 
			<< '_'
			<< selector 
			<< '_'
			<< exceptionClass  ]
]

{ #category : #accessing }
SDSnapshot >> id [ 
	^ id 
]

{ #category : #accessing }
SDSnapshot >> id: anObject [
	id := anObject
]

{ #category : #accessing }
SDSnapshot >> idString [
	^ String streamContents: [ :stream |
		stream 
			<< className << selector << exceptionClass ]
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

{ #category : #'as yet unclassified' }
SDSnapshot >> metaFields [
	^ self basicMetaFields asOrderedCollection
		add: #projectName;
		add: #versionString;
		yourself
]

{ #category : #'as yet unclassified' }
SDSnapshot >> openDebugger [
	FLMaterializer materializeFromByteArray: (
		self store snapshotDumpWithId: id )
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
	^ project value
]

{ #category : #accessing }
SDSnapshot >> project: aProject [
	project := aProject
]

{ #category : #accessing }
SDSnapshot >> projectName [
	^ project name
]

{ #category : #accessing }
SDSnapshot >> projectName: aProjectName versionString: aVersionString [
	project := [
		project := store projectNamed: aProjectName.
		version := project versionWithString: aVersionString.
		project ] 
]

{ #category : #'as yet unclassified' }
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
SDSnapshot >> store [
	^ store
]

{ #category : #accessing }
SDSnapshot >> store: aStore [ 
	store := aStore
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
	^ version
]

{ #category : #accessing }
SDSnapshot >> version: aVersion [
	version := aVersion
]

{ #category : #accessing }
SDSnapshot >> versionString [
	^ version string
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
	(NeoJSONWriter on: stream) 
		prettyPrint: true;
		nextPut: self 
]
