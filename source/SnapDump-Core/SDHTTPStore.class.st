Class {
	#name : #SDHTTPStore,
	#superclass : #SDStore,
	#instVars : [
		'uri',
		'username',
		'password'
	],
	#category : #'SnapDump-Core-Base'
}

{ #category : #accessing }
SDHTTPStore class >> storeName [
	^ #http
]

{ #category : #initialization }
SDHTTPStore >> applyConfiguration: aConfig [
	uri := aConfig uri.
   username := aConfig username.
   password := aConfig password.

]

{ #category : #accessing }
SDHTTPStore >> client [
	^ ZnClient new
		beOneShot;
		setBasicAuthenticationUsername: username password: password 
]

{ #category : #'services - getting' }
SDHTTPStore >> exceptionsOfVersion: aVersion [ 
	| response |
	response := self client
		url: uri / #projects / aVersion projectName urlEncoded / #versions / aVersion string / #exceptions;
		get;
		response.
	response isSuccess 
		ifTrue: [  
			^ ((NeoJSONReader on: response contents readStream) nextListAs: SDException) do: [ :e |
				e version: aVersion ] ]
		ifFalse: [ NotFound signal: ('Version' , aVersion printString , ' for project ', aVersion projectName printString, ' not found') ]
]

{ #category : #'services - getting' }
SDHTTPStore >> freeSlotsForException: anException [ 
	
		^ self freeSlotsForExceptionId: anException id project: anException projectName version: anException versionString
]

{ #category : #'services - getting' }
SDHTTPStore >> freeSlotsForExceptionId: anExceptionId project: aProjectName version: aVersionString [
	| response |
	
	response := self client
		url: uri / #projects / aProjectName / #versions / aVersionString / #exceptions / anExceptionId / #freeslots;
		get;
		response.
	response isSuccess 
		ifTrue: [  
	^ ((NeoJSONReader on: response contents readStream) next)  ]
		ifFalse: [ NotFound signal ]
]

{ #category : #testing }
SDHTTPStore >> isSetUp [
	^ uri notNil
]

{ #category : #accessing }
SDHTTPStore >> parametersFor: snapshot [

	^ Dictionary new 
			at: #projectName put: snapshot projectName;
			at: #versionName put: snapshot versionString;
			at: #exceptionId put: snapshot exceptionId;
			yourself
]

{ #category : #printing }
SDHTTPStore >> printOn: aStream [
	aStream << uri asString
]

{ #category : #accessing }
SDHTTPStore >> projectNamed: aString [
	^ self projectNamed: aString ifAbsent: [ NotFound signal: 'no project found' ]
]

{ #category : #accessing }
SDHTTPStore >> projectNamed: aString ifAbsent: aBlock [
	| response |
	response := self client
		url: uri / #projects / aString;
		get;
		response.
	^ response isSuccess 
		ifTrue: [
			((NeoJSONReader on: response contents readStream) nextAs: SDProject)
				store: self ]
		ifFalse: aBlock
]

{ #category : #accessing }
SDHTTPStore >> projectNamed: aString ifAbsentPut: aBlock [
	| response |
	response := self client
		url: uri / #projects / aString;
		get;
		response.
	^ response isSuccess 
		ifTrue: [
			((NeoJSONReader on: response contents readStream) nextAs: SDProject)
				store: self ]
		ifFalse: aBlock
]

{ #category : #accessing }
SDHTTPStore >> projects [
	| response |
	response := self client
		url: uri / #projects;
		get;
		response.
	^ ((NeoJSONReader on: response contents readStream) nextListAs: SDProject) do: [ :p |
			p store: self ]
]

{ #category : #'services - removing' }
SDHTTPStore >> removeSnapshot: aSnapshot [ 
	| response |
	response := self client
		url: (self urlForSnapshot: aSnapshot);
		delete;
		response.
	response isSuccess 
		ifFalse: [ NotFound signal ]
]

{ #category : #'services - testing' }
SDHTTPStore >> shouldReportSnapshot: snapshot [
	^ (self freeSlotsForException: snapshot exception) > 0
]

{ #category : #accessing }
SDHTTPStore >> snapshotDumpFor: aSnapshot [ 
	^ self client
		headerAt: 'Accept' put: SDStore mimeTypeFuel;
		url: (self urlForSnapshot: aSnapshot);
		get
]

{ #category : #accessing }
SDHTTPStore >> snapshotStackFor: aSnapshot [ 

	^ self client
		headerAt: 'Accept' put: SDStore mimeTypeStack;
		url: (self urlForSnapshot: aSnapshot);
		get
]

{ #category : #'services - getting' }
SDHTTPStore >> snapshotsOfException: anException [ 
	| response |
	
	response := self client
		url: uri / #projects / anException projectName / #versions / anException versionString / #exceptions / anException id / #snapshots;
		get;
		response.
	response isSuccess 
		ifTrue: [  
	^ ((NeoJSONReader on: response contents readStream) nextListAs: SDSnapshot) do: [ :s |
			s exception: anException ] ]
		ifFalse: [ NotFound signal ]
]

{ #category : #accessing }
SDHTTPStore >> uri: anUri [
	uri := anUri asZnUrl / SDSnapshot apiVersion
]

{ #category : #accessing }
SDHTTPStore >> urlForSnapshot: snapshot [

	^ self urlForSnapshot: snapshot snapshotId  project: snapshot projectName version: snapshot versionString exception:  snapshot exceptionId
]

{ #category : #accessing }
SDHTTPStore >> urlForSnapshot: snapshotId project: projectName version: versionName exception: anExceptionId [
	
	
	^  (uri / #projects / projectName urlEncoded / #versions / versionName urlEncoded/ #exceptions/ anExceptionId /  #snapshots / snapshotId)
	
]

{ #category : #accessing }
SDHTTPStore >> username: aUsername password: aPassword [
	username := aUsername.
	password := aPassword
]

{ #category : #'services - getting' }
SDHTTPStore >> versionsOfProject: aProject [ 
	| response |
	response := self client
		url: uri / #projects / aProject name urlEncoded / #versions;
		get;
		response.
	response isSuccess 
		ifTrue: [  
			^ ((NeoJSONReader on: response contents readStream) nextListAs: SDVersion) do: [ :v |
				v project: aProject ] ]
		ifFalse: [ NotFound signal: (aProject name , ' project not found') ]
]

{ #category : #services }
SDHTTPStore >> writeSnapshot: snapshot [
	| writeStream response |
	writeStream := ByteArray new writeStream.
	(SDSnapshotFileWriter on: writeStream) writeSnapshot: snapshot.
	response := self client
		url: (self urlForSnapshot: snapshot);
		entity: (ZnByteArrayEntity bytes: writeStream contents);
		put.
	Transcript show: 'SnapDump: Error reporting gave response: ', response asString. 
]
