Class {
	#name : #SDSnapshot,
	#superclass : #Object,
	#instVars : [
		'id',
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
		'imageBuild'
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
		mapping mapInstVars: #(id className selector exceptionClass operatingSystem systemArchitecture operatingSystemVersion vmVersion imageVersion imageBuild) ].
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
	^ #(id timestamp className selector exceptionClass operatingSystem systemArchitecture operatingSystemVersion vmVersion imageVersion imageBuild)
]

{ #category : #accessing }
SDSnapshot >> buildId [
	^ (SHA256 hashMessage: self fullSignature) hex

]

{ #category : #accessing }
SDSnapshot >> className [
	^ className
]

{ #category : #accessing }
SDSnapshot >> className: aString [ 
	className := aString
]

{ #category : #'as yet unclassified' }
SDSnapshot >> dateAndTimeString [ 
	^ String streamContents: [ :stream |
		stream << self dateString << ' ' << self timeString  ]
]

{ #category : #'as yet unclassified' }
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

{ #category : #signatures }
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
	^ id ifNil: [ 
		id := self buildId ]
]

{ #category : #accessing }
SDSnapshot >> id: anObject [
	id := anObject
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

{ #category : #private }
SDSnapshot >> metaFields [
	^ self basicMetaFields asOrderedCollection
		add: #projectName;
		add: #versionString;
		yourself
]

{ #category : #signatures }
SDSnapshot >> methodSignature [
	^ String streamContents: [ :stream |
		stream 
			<< className 
			<< '>>#'
			<< selector ]
]

{ #category : #actions }
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
	^ project
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
SDSnapshot >> projectName: aString [ 
	"we only use project objects"
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
SDSnapshot >> store [
	^ version store
]

{ #category : #accessing }
SDSnapshot >> systemArchitecture [
	^ systemArchitecture
]

{ #category : #accessing }
SDSnapshot >> systemArchitecture: aString [ 
	systemArchitecture := aString
]

{ #category : #'as yet unclassified' }
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
	^ version
]

{ #category : #accessing }
SDSnapshot >> version: aVersion [
	version := aVersion.
	project := aVersion project
]

{ #category : #accessing }
SDSnapshot >> versionString [
	^ version string
]

{ #category : #accessing }
SDSnapshot >> versionString: aString [ 
	"we only use version object"
]

{ #category : #accessing }
SDSnapshot >> vmVersion [
	^ vmVersion
]

{ #category : #accessing }
SDSnapshot >> vmVersion: aString [ 
	vmVersion := aString
]
