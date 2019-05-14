Class {
	#name : #SnapDump,
	#superclass : #Object,
	#instVars : [
		'store',
		'project',
		'version'
	],
	#classInstVars : [
		'current'
	],
	#category : #'SnapDump-BasicClient'
}

{ #category : #'as yet unclassified' }
SnapDump class >> configuration [
	<configurationStep>
	^ {  
		#group -> #SnapDump.
		#action -> [ :config | SnapDump current applyConfiguration: config ] }
]

{ #category : #accessing }
SnapDump class >> current [ 
	^ current ifNil: [ 
		current := self new ]
]

{ #category : #'as yet unclassified' }
SnapDump class >> hackUIManager [
	UIManager compile: 'logError: anError
		SnapDump current handleException: anError.
		super logError: anError'
]

{ #category : #public }
SnapDump class >> handleException: exception [
	^ self current handleException: exception 
]

{ #category : #'as yet unclassified' }
SnapDump class >> handleSnapshot: aSnapshot [ 
	^ self current handleSnapshot: aSnapshot 
]

{ #category : #'as yet unclassified' }
SnapDump class >> http: aUri [
	^ self current 
		store: (SDHTTPStore new uri: aUri asZnUrl);
		yourself 
]

{ #category : #'as yet unclassified' }
SnapDump >> applyConfiguration: aConfig [
	store := (SDStore withName: aConfig store) new.
	store applyConfiguration: aConfig
]

{ #category : #'as yet unclassified' }
SnapDump >> handleException: exception [

	^ self handleSnapshot: exception asSnapshot

]

{ #category : #'as yet unclassified' }
SnapDump >> handleSnapshot: snapshot [
	self store ifNotNil: [
		self store storeSnapshot: (snapshot 
			project: project;
			version: version ) ].
	^ snapshot 
]

{ #category : #accessing }
SnapDump >> project [
	^ project
]

{ #category : #'as yet unclassified' }
SnapDump >> projectName: projectName versionString: versionString [
	project := (SDProject name: projectName).
	version := (SDVersion string: versionString) project: project
]

{ #category : #accessing }
SnapDump >> projectNamed: aString [ 
	^ self store projectNamed: aString
]

{ #category : #accessing }
SnapDump >> projectNamed: aString ifAbsent: aBlock [
	^ self store projectNamed: aString ifAbsent: aBlock
]

{ #category : #'as yet unclassified' }
SnapDump >> projects [
	^ store projects
]

{ #category : #searching }
SnapDump >> snapshotWithId: aString [ 
	^ self store snapshotWithId: aString 
]

{ #category : #accessing }
SnapDump >> store [
	^ store
]

{ #category : #accessing }
SnapDump >> store: anObject [
	store := anObject 
]

{ #category : #accessing }
SnapDump >> version [
	^ version
]
