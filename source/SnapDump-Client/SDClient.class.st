Class {
	#name : #SDClient,
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
	#category : #'SnapDump-Client'
}

{ #category : #'as yet unclassified' }
SDClient class >> baseUrl [
	^ baseUrl ifNil: [ 
		baseUrl := self defaultBaseUrl ]
]

{ #category : #'as yet unclassified' }
SDClient class >> defaultBaseUrl [
	^ 'https://bugs.2denker.de' asZnUrl 
]

{ #category : #'as yet unclassified' }
SDClient class >> password [
	^ password
]

{ #category : #'instance creation' }
SDClient class >> project: aString [ 
	^ self new
		project: aString
]

{ #category : #accessing }
SDClient class >> username [
	^ username
]

{ #category : #accessing }
SDClient class >> username: aUsername password: aPassword [ 
	username := aUsername.
	password := aPassword 
]

{ #category : #'as yet unclassified' }
SDClient >> baseUrl [
	^ self class baseUrl
]

{ #category : #accessing }
SDClient >> beDeleting [
	mode := self deleteMode 
]

{ #category : #'as yet unclassified' }
SDClient >> bugsAt: aString [ 
	^ self model select: [ :each | each version = aString ]
]

{ #category : #accessing }
SDClient >> client [
	^ ZnClient new
		setBasicAuthenticationUsername: self username password: self password
]

{ #category : #accessing }
SDClient >> debuggerMode [
	 ^ [ :bug | self openDebuggerFor: bug ]
]

{ #category : #public }
SDClient >> delete: aBug [
	^ self client
		url: (self urlOfBug: aBug);
		delete
]

{ #category : #accessing }
SDClient >> deleteMode [
	 ^ [ :bug | self delete: bug ]
]

{ #category : #operations }
SDClient >> get: aZnUrl [ 
	^ self client
		url: aZnUrl;
		get
]

{ #category : #operations }
SDClient >> getJSON: aZnUrl [ 
	^ NeoJSONObject fromString: (self get: aZnUrl)
]

{ #category : #accessing }
SDClient >> mode [
	^ mode ifNil: [ 
		mode := self debuggerMode ]
]

{ #category : #accessing }
SDClient >> model [

	 ^  self getJSON: self projectUrl
]

{ #category : #'instance creation' }
SDClient >> open [
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
SDClient >> openDebuggerFor: jsonObject [
	FLMaterializer materializeFromByteArray: (
		self get: self projectUrl / jsonObject version / jsonObject name )
]

{ #category : #accessing }
SDClient >> password [
	^ self class password
]

{ #category : #'instance creation' }
SDClient >> project: aString [
	project := aString
]

{ #category : #'as yet unclassified' }
SDClient >> projectUrl [
	^ self rootUrl / project
]

{ #category : #'instance creation' }
SDClient >> projects [
	^ self getJSON: self rootUrl
]

{ #category : #'as yet unclassified' }
SDClient >> rootUrl [
	^ self baseUrl / #api / #reports
]

{ #category : #enumerating }
SDClient >> select: aBug [
	self mode value: aBug

]

{ #category : #'as yet unclassified' }
SDClient >> urlOfBug: jsonObject [
	^ self projectUrl / jsonObject version / jsonObject name
]

{ #category : #accessing }
SDClient >> username [
	^ self class username
]

{ #category : #'instance creation' }
SDClient >> username: aUsername password: aPassword [
	username := aUsername.
	password := aPassword 
]

{ #category : #accessing }
SDClient >> versions [
	^ (self model collect: #version) asSet asSortedCollection 
]
