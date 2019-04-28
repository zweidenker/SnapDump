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

{ #category : #testing }
SDHTTPStore >> hasSnapshotNamed: snapshot [
	^ (self client
		url: (self urlFor: snapshot);
		head;
		response) status = 200
]

{ #category : #accessing }
SDHTTPStore >> project: aString [ 
	project := aString
]

{ #category : #'as yet unclassified' }
SDHTTPStore >> store: snapshot [
	| writeStream request |
	writeStream := ByteArray new writeStream.
	[ snapshot writeTo: writeStream .
	request := ZnRequest put: (self urlFor: snapshot).
	snapshot preparePutRequest: request.
	request entity: (ZnByteArrayEntity bytes: writeStream contents).
	self client
		request: request;
		execute
	]
		on: Error 
		do: [ :err | Transcript show: 'error happened: ', err description ]
]

{ #category : #accessing }
SDHTTPStore >> uri: anUri [
	uri := anUri asZnUrl 
]

{ #category : #accessing }
SDHTTPStore >> urlFor: snapshot [
	^ uri / #snaps / snapshot id
]

{ #category : #accessing }
SDHTTPStore >> urlForX: snapshot [
	^ uri / project asString / version asString / (self descriptionString: snapshot) asString
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
