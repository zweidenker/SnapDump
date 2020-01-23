Class {
	#name : #SDSnapshot,
	#superclass : #Object,
	#instVars : [
		'timestamp',
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
		'exception',
		'stackTrace'
	],
	#category : #'SnapDump-Core'
}

{ #category : #accessing }
SDSnapshot class >> apiVersion [

	"A version description that is used by all parts (handler, server, client) to ensure consistent API calls 
	(for example, avoid pushing snaphots to an incompatible version of snapdump server).
	We use the class side of SDSnapshot as it is accessible from all kind of images (handler, server, client).
	This description is expected to be updated each time 'breaking' changes are introduced on server side.
	It will be used as an URL prefix"
	
	^ 'v2'
]

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
	^ #(projectName versionString  exceptionId timestamp className selector exceptionClass operatingSystem systemArchitecture operatingSystemVersion vmVersion imageVersion imageBuild)
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
SDSnapshot >> dateAndTimeString [ 
	^ String streamContents: [ :stream |
		stream << self dateString << ' ' << self timeString  ]
]

{ #category : #accessing }
SDSnapshot >> dateString [ 
	^ timestamp asDate printFormat: #(1 2 3 $. 1 1)
]

{ #category : #initialization }
SDSnapshot >> ensureVersionModel [

	"Make sure the version model is built from my local properties "
	self exception version: self newVersion.

		 
]

{ #category : #signatures }
SDSnapshot >> errorSignature [
	^ self exception fullSignature
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
SDSnapshot >> exceptionId [ 
	^ exceptionId 
]

{ #category : #accessing }
SDSnapshot >> exceptionId: aString [
	exceptionId := aString
]

{ #category : #initialization }
SDSnapshot >> exportExceptionModel [

	"absorb the exception model properties so that they can be serialized with the snap file "
	exceptionClass := self exception exceptionClassName.
	selector := self exception exceptionSignalerSelector.
	className := self exception exceptionSignalerClassName. 
	exceptionId := self exception id.

]

{ #category : #actions }
SDSnapshot >> fuelBytes [
	^ self store snapshotDumpFor: self
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
	| context |
	context := FLMaterializer materializeFromByteArray: self fuelBytes.
	UIManager default
		debugProcess: Processor activeProcess 
		context: context 
		label: 'External stack' 
		fullView: true
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

{ #category : #initialization }
SDSnapshot >> prepareExport [

	self ensureVersionModel.
	self exportExceptionModel.  
]

{ #category : #accessing }
SDSnapshot >> project [
	^ self exception project
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

{ #category : #initialization }
SDSnapshot >> restoreModel [
		
	"Restore the model from my local 'flat' properties.
	Usefull when building / restoring snapshot object from file "
	exception := SDException new 
		id:  exceptionId;
		exceptionSignalerSelector: selector;
		exceptionSignalerClassName: exceptionClass;
		exceptionClassName: className;
		yourself.
	self ensureVersionModel
		 
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
SDSnapshot >> stackTrace [

	^ stackTrace
]

{ #category : #accessing }
SDSnapshot >> stackTrace: aString [

	stackTrace := aString
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
