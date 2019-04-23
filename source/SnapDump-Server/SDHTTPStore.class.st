Class {
	#name : #SDHTTPStore,
	#superclass : #SDStore,
	#instVars : [
		'uri',
		'username',
		'password',
		'project',
		'version'
	],
	#category : #'SnapDump-Server-Store'
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
	project := aConfig project.
	version := aConfig version
]

{ #category : #accessing }
SDHTTPStore >> client [
	^ ZnClient new
		setBasicAuthenticationUsername: username password: password 
]

{ #category : #accessing }
SDHTTPStore >> descriptionFor: exception [
	^ (super descriptionFor: exception)
		at: 'project' put: project;
		at: 'version' put: version;
		yourself
]

{ #category : #testing }
SDHTTPStore >> hasSnapshotNamed: dict [
	^ (self client
		url: (self urlFor: dict);
		head;
		response) status = 200
]

{ #category : #accessing }
SDHTTPStore >> project: aString [ 
	project := aString
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> storeDebugContext: aContext description: dict [
	| writeStream |
	writeStream := ByteArray new writeStream.
	
	
	[ self 
		serializeContext: aContext 
		on: writeStream.
		
	self client
		url: (self urlFor: dict);
		entity: (ZnByteArrayEntity bytes: writeStream contents);
		put ]
		on: Error 
		do: [ :err | Transcript show: 'error happened: ', err description ]
]

{ #category : #accessing }
SDHTTPStore >> uri: anUri [
	uri := anUri asZnUrl 
]

{ #category : #accessing }
SDHTTPStore >> urlFor: dict [
	^ uri / (dict at: 'project') asString / (dict at: 'version') asString / (self descriptionString: dict) asString
]

{ #category : #accessing }
SDHTTPStore >> username: aUsername password: aPassword [
	username := aUsername.
	password := aPassword
]

{ #category : #accessing }
SDHTTPStore >> version: aString [ 
	version := aString
]
