Class {
	#name : #SDBasicHTTPStore,
	#superclass : #SDStore,
	#instVars : [
		'username',
		'uri',
		'password'
	],
	#category : #'SnapDump-Handler'
}

{ #category : #accessing }
SDBasicHTTPStore class >> storeName [
	^ #http
]

{ #category : #initialization }
SDBasicHTTPStore >> applyConfiguration: aConfig [
	uri := aConfig uri.
   username := aConfig username.
   password := aConfig password.

]

{ #category : #accessing }
SDBasicHTTPStore >> client [
	^ ZnClient new
		beOneShot;
		setBasicAuthenticationUsername: username password: password 
]

{ #category : #'services - getting' }
SDBasicHTTPStore >> freeSlotsForException: anException [ 
	
		^ self freeSlotsForExceptionId: anException id project: anException projectName version: anException versionString
]

{ #category : #'services - getting' }
SDBasicHTTPStore >> freeSlotsForExceptionId: anExceptionId project: aProjectName version: aVersionString [
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
SDBasicHTTPStore >> isSetUp [
	^ uri notNil
]

{ #category : #accessing }
SDBasicHTTPStore >> parametersFor: snapshot [

	^ Dictionary new 
			at: #projectName put: snapshot projectName;
			at: #versionName put: snapshot versionString;
			at: #exceptionId put: snapshot exceptionId;
			yourself
]

{ #category : #printing }
SDBasicHTTPStore >> printOn: aStream [
	aStream << uri asString
]

{ #category : #'services - testing' }
SDBasicHTTPStore >> shouldReportSnapshot: snapshot [
	^ (self freeSlotsForException: snapshot exception) > 0
]

{ #category : #accessing }
SDBasicHTTPStore >> uri: anUri [
	uri := anUri asZnUrl / SDSnapshot apiVersion
]

{ #category : #accessing }
SDBasicHTTPStore >> urlForSnapshot: snapshot [

	^ self urlForSnapshot: snapshot snapshotId  project: snapshot projectName version: snapshot versionString exception:  snapshot exceptionId
]

{ #category : #accessing }
SDBasicHTTPStore >> urlForSnapshot: snapshotId project: projectName version: versionName exception: anExceptionId [
	
	
	^  (uri / #projects / projectName urlEncoded / #versions / versionName urlEncoded/ #exceptions/ anExceptionId /  #snapshots / snapshotId)
	
]

{ #category : #accessing }
SDBasicHTTPStore >> username: aUsername password: aPassword [
	username := aUsername.
	password := aPassword
]

{ #category : #services }
SDBasicHTTPStore >> writeSnapshot: snapshot [
	| writeStream response |
	writeStream := ByteArray new writeStream.
	(SDSnapshotFileWriter on: writeStream) writeSnapshot: snapshot.
	response := self client
		url: (self urlForSnapshot: snapshot);
		entity: (ZnByteArrayEntity bytes: writeStream contents);
		put.
	Transcript show: 'SnapDump: Error reporting gave response: ', response asString. 
]
