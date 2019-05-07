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
		#action -> [ :config | SnapDump current applyConfig: config ] }
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

{ #category : #'as yet unclassified' }
SnapDump class >> http: aUri [
	^ self current 
		store: (SDHTTPStore new uri: aUri asZnUrl);
		yourself 
]

{ #category : #public }
SnapDump class >> storeException: exception [
	^ self current storeException: exception 
]

{ #category : #'as yet unclassified' }
SnapDump class >> storeSnapshot: aSnapshot [ 
	^ self current storeSnapshot: aSnapshot 
]

{ #category : #'as yet unclassified' }
SnapDump >> applyConfig: aConfig [
	store := (SDStore withName: aConfig store) new.
	store applyConfig: aConfig
]

{ #category : #'as yet unclassified' }
SnapDump >> convertToSnapshot: exception [
	| p |
	p := store projectNamed: project ifAbsentPut: [ (SDProject name: project) store: store ].
	^ exception asSnapshot 
		project: p;
		version: (p versionWithString: version);
		yourself
]

{ #category : #accessing }
SnapDump >> project [
	^ project
]

{ #category : #accessing }
SnapDump >> project: anObject [
	project := anObject
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

{ #category : #'as yet unclassified' }
SnapDump >> storeException: exception [

	^ self storeSnapshot: (self convertToSnapshot: exception)

]

{ #category : #'as yet unclassified' }
SnapDump >> storeSnapshot: snapshot [
	self store ifNotNil: [
		self store storeSnapshot: snapshot ].
	^ snapshot
]

{ #category : #accessing }
SnapDump >> version [
	^ version
]

{ #category : #accessing }
SnapDump >> version: anObject [
	version := anObject
]
