Class {
	#name : #SDSimpleDialogUI,
	#superclass : #Object,
	#instVars : [
		'username',
		'password',
		'project',
		'model',
		'mode'
	],
	#classInstVars : [
		'username',
		'password',
		'baseUrl'
	],
	#category : #'SnapDump-UI'
}

{ #category : #'as yet unclassified' }
SDSimpleDialogUI class >> baseUrl [
	^ baseUrl ifNil: [ 
		baseUrl := self defaultBaseUrl ]
]

{ #category : #'as yet unclassified' }
SDSimpleDialogUI class >> defaultBaseUrl [
	^ 'https://bugs.2denker.de' asZnUrl 
]

{ #category : #'as yet unclassified' }
SDSimpleDialogUI class >> password [
	^ password
]

{ #category : #'instance creation' }
SDSimpleDialogUI class >> project: aString [ 
	^ self new
		project: aString
]

{ #category : #accessing }
SDSimpleDialogUI class >> username [
	^ username
]

{ #category : #accessing }
SDSimpleDialogUI class >> username: aUsername password: aPassword [ 
	username := aUsername.
	password := aPassword 
]

{ #category : #'as yet unclassified' }
SDSimpleDialogUI >> baseUrl [
	^ self class baseUrl
]

{ #category : #accessing }
SDSimpleDialogUI >> beDeleting [
	mode := self deleteMode 
]

{ #category : #'as yet unclassified' }
SDSimpleDialogUI >> bugsAt: aString [ 
	^ self model select: [ :each | each version = aString ]
]

{ #category : #accessing }
SDSimpleDialogUI >> client [
	^ ZnClient new
		setBasicAuthenticationUsername: self username password: self password
]

{ #category : #accessing }
SDSimpleDialogUI >> debuggerMode [
	 ^ [ :bug | self openDebuggerFor: bug ]
]

{ #category : #public }
SDSimpleDialogUI >> delete: aBug [
	^ self client
		url: (self urlOfBug: aBug);
		delete
]

{ #category : #accessing }
SDSimpleDialogUI >> deleteMode [
	 ^ [ :bug | self delete: bug ]
]

{ #category : #operations }
SDSimpleDialogUI >> get: aZnUrl [ 
	^ self client
		url: aZnUrl;
		get
]

{ #category : #operations }
SDSimpleDialogUI >> getJSON: aZnUrl [ 
	^ NeoJSONObject fromString: (self get: aZnUrl)
]

{ #category : #accessing }
SDSimpleDialogUI >> mode [
	^ mode ifNil: [ 
		mode := self debuggerMode ]
]

{ #category : #accessing }
SDSimpleDialogUI >> model [

	 ^  self getJSON: self projectUrl
]

{ #category : #'instance creation' }
SDSimpleDialogUI >> open [
	| projects versions version bugs |
	project ifNil: [ 
		projects := self projects.
		project :=  projects at: (UIManager default chooseFrom: projects) ].
	versions := self versions.
	(versions size = 0) ifTrue: [ 
		self inform: 'no bugs found' ].
	(versions size = 1) ifTrue: [ 
		 version := versions first ].
	(versions size > 1) ifTrue: [ 
		version := versions at: (UIManager default chooseFrom: self versions) ].
	bugs := self bugsAt: version.
	(bugs size = 1) ifTrue: [  
		self select: bugs first ].
	(bugs size > 1) ifTrue: [ 
		self select: (bugs at: (UIManager default chooseFrom: bugs)) ]
]

{ #category : #'as yet unclassified' }
SDSimpleDialogUI >> openDebuggerFor: jsonObject [
	FLMaterializer materializeFromByteArray: (
		self get: self projectUrl / jsonObject version / jsonObject name )
]

{ #category : #accessing }
SDSimpleDialogUI >> password [
	^ self class password
]

{ #category : #'instance creation' }
SDSimpleDialogUI >> project: aString [
	project := aString
]

{ #category : #'as yet unclassified' }
SDSimpleDialogUI >> projectUrl [
	^ self rootUrl / project
]

{ #category : #'instance creation' }
SDSimpleDialogUI >> projects [
	^ self getJSON: self rootUrl
]

{ #category : #'as yet unclassified' }
SDSimpleDialogUI >> rootUrl [
	^ self baseUrl / #api / #reports
]

{ #category : #enumerating }
SDSimpleDialogUI >> select: aBug [
	self mode value: aBug

]

{ #category : #'as yet unclassified' }
SDSimpleDialogUI >> urlOfBug: jsonObject [
	^ self projectUrl / jsonObject version / jsonObject name
]

{ #category : #accessing }
SDSimpleDialogUI >> username [
	^ self class username
]

{ #category : #'instance creation' }
SDSimpleDialogUI >> username: aUsername password: aPassword [
	username := aUsername.
	password := aPassword 
]

{ #category : #accessing }
SDSimpleDialogUI >> versions [
	^ (self model collect: #version) asSet asSortedCollection 
]
