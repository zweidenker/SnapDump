Class {
	#name : #SDHTTPStore,
	#superclass : #SDStore,
	#instVars : [
		'username',
		'uri',
		'password'
	],
	#category : #'SnapDump-Client'
}

{ #category : #accessing }
SDHTTPStore class >> storeName [
	^ #http
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> applyConfig: aConfig [
	uri := aConfig uri.
   username := aConfig username.
   password := aConfig password.

]

{ #category : #accessing }
SDHTTPStore >> client [
	^ ZnClient new
		setBasicAuthenticationUsername: username password: password 
]

{ #category : #testing }
SDHTTPStore >> hasSnapshotNamed: snapshotId [
	^ (self client
		url: (self urlFor: snapshotId);
		head;
		response) status = 200
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> projectNamed: aString [
	^ self projectNamed: aString ifAbsent: [ NotFound signal: 'no project found' ]
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> projectNamed: aString ifAbsent: aBlock [
	| response |
	response := ZnClient new
		url: uri / #projects / aString;
		get;
		response.
	^ response isSuccess 
		ifTrue: [
			((NeoJSONReader on: response contents readStream) nextAs: SDProject)
				store: self ]
		ifFalse: aBlock
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> projectNamed: aString ifAbsentPut: aBlock [
	| response |
	response := ZnClient new
		url: uri / #projects / aString;
		get;
		response.
	^ response isSuccess 
		ifTrue: [
			((NeoJSONReader on: response contents readStream) nextAs: SDProject)
				store: self ]
		ifFalse: aBlock
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> projects [
	| response |
	response := ZnClient new
		url: uri / #projects;
		get;
		response.
	^ ((NeoJSONReader on: response contents readStream) nextListAs: SDProject) do: [ :p |
			p store: self ]
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> removeSnapshot: aSnapshot [ 
	| response |
	response := ZnClient new
		url: uri / #snapshots / aSnapshot id;
		delete;
		response.
	response isSuccess ifFalse: [  
		self error: 'deleting of snapshot failed' ]
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> snapshotDumpWithId: aString [ 
	^ ZnClient new
		headerAt: 'Accept' put: 'application/X-SnapDump-Fuel';
		url: uri / #snapshots / aString;
		get
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> snapshotWithId: aString [ 
	^ ZnClient new
		url: uri / #snapshots / aString / #fuel;
		get
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> snapshotsWithVersion: aVersion [ 
	| response |
	response := ZnClient new
		url: uri / #projects / aVersion project name / #versions / aVersion string / #snapshots;
		get;
		response.
	^ ((NeoJSONReader on: response contents readStream) nextListAs: SDSnapshot) do: [ :s |
			s version: aVersion ]
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> store: snapshot [
	| writeStream request response |
	writeStream := ByteArray new writeStream.
	[ snapshot writeTo: writeStream .
	request := ZnRequest put: (self urlFor: snapshot id).
	"snapshot preparePutRequest: request."
	request entity: (ZnByteArrayEntity bytes: writeStream contents).
	response := self client
		request: request;
		put;
		response.
	]
		on: Error 
		do: [ :err | err pass. Transcript show: 'error happened: ', err description ]
]

{ #category : #accessing }
SDHTTPStore >> uri: anUri [
	uri := anUri asZnUrl 
]

{ #category : #accessing }
SDHTTPStore >> urlFor: snapshotId [
	^ uri / #snapshots / snapshotId
]

{ #category : #accessing }
SDHTTPStore >> username: aUsername password: aPassword [
	username := aUsername.
	password := aPassword
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> versionWithString: aString [ 
	self shouldBeImplemented.
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> versionsOfProject: aProject [ 
	| response |
	response := ZnClient new
		url: uri / #projects / aProject name / #versions;
		get;
		response.
	^ ((NeoJSONReader on: response contents readStream) nextListAs: SDVersion) do: [ :v |
			v project: aProject ]
]
