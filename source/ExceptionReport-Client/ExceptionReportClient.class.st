Class {
	#name : #ExceptionReportClient,
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
	#category : 'ExceptionReport-Client'
}

{ #category : #'as yet unclassified' }
ExceptionReportClient class >> baseUrl [
	^ baseUrl ifNil: [ 
		baseUrl := self defaultBaseUrl ]
]

{ #category : #'as yet unclassified' }
ExceptionReportClient class >> defaultBaseUrl [
	^ 'https://bugs.2denker.de' asZnUrl 
]

{ #category : #'as yet unclassified' }
ExceptionReportClient class >> password [
	^ password
]

{ #category : #'instance creation' }
ExceptionReportClient class >> project: aString [ 
	^ self new
		project: aString
]

{ #category : #accessing }
ExceptionReportClient class >> username [
	^ username
]

{ #category : #accessing }
ExceptionReportClient class >> username: aUsername password: aPassword [ 
	username := aUsername.
	password := aPassword 
]

{ #category : #'as yet unclassified' }
ExceptionReportClient >> baseUrl [
	^ self class baseUrl
]

{ #category : #accessing }
ExceptionReportClient >> beDeleting [
	mode := self deleteMode 
]

{ #category : #'as yet unclassified' }
ExceptionReportClient >> bugsAt: aString [ 
	^ self model select: [ :each | each version = aString ]
]

{ #category : #accessing }
ExceptionReportClient >> client [
	^ ZnClient new
		setBasicAuthenticationUsername: self username password: self password
]

{ #category : #accessing }
ExceptionReportClient >> debuggerMode [
	 ^ [ :bug | self openDebuggerFor: bug ]
]

{ #category : #public }
ExceptionReportClient >> delete: aBug [
	^ self client
		url: (self urlOfBug: aBug);
		delete
]

{ #category : #accessing }
ExceptionReportClient >> deleteMode [
	 ^ [ :bug | self delete: bug ]
]

{ #category : #operations }
ExceptionReportClient >> get: aZnUrl [ 
	^ self client
		url: aZnUrl;
		get
]

{ #category : #operations }
ExceptionReportClient >> getJSON: aZnUrl [ 
	^ NeoJSONObject fromString: (self get: aZnUrl)
]

{ #category : #accessing }
ExceptionReportClient >> mode [
	^ mode ifNil: [ 
		mode := self debuggerMode ]
]

{ #category : #accessing }
ExceptionReportClient >> model [

	 ^  self getJSON: self projectUrl
]

{ #category : #'instance creation' }
ExceptionReportClient >> open [
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
ExceptionReportClient >> openDebuggerFor: jsonObject [
	FLMaterializer materializeFromByteArray: (
		self get: self projectUrl / jsonObject version / jsonObject name )
]

{ #category : #accessing }
ExceptionReportClient >> password [
	^ self class password
]

{ #category : #'instance creation' }
ExceptionReportClient >> project: aString [
	project := aString
]

{ #category : #'as yet unclassified' }
ExceptionReportClient >> projectUrl [
	^ self rootUrl / project
]

{ #category : #'instance creation' }
ExceptionReportClient >> projects [
	^ self getJSON: self rootUrl
]

{ #category : #'as yet unclassified' }
ExceptionReportClient >> rootUrl [
	^ self baseUrl / #api / #reports
]

{ #category : #enumerating }
ExceptionReportClient >> select: aBug [
	self mode value: aBug

]

{ #category : #'as yet unclassified' }
ExceptionReportClient >> urlOfBug: jsonObject [
	^ self projectUrl / jsonObject version / jsonObject name
]

{ #category : #accessing }
ExceptionReportClient >> username [
	^ self class username
]

{ #category : #'instance creation' }
ExceptionReportClient >> username: aUsername password: aPassword [
	username := aUsername.
	password := aPassword 
]

{ #category : #accessing }
ExceptionReportClient >> versions [
	^ (self model collect: #version) asSet asSortedCollection 
]
