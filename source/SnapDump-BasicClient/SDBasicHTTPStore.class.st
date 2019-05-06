Class {
	#name : #SDBasicHTTPStore,
	#superclass : #SDStore,
	#instVars : [
		'username',
		'uri',
		'password'
	],
	#category : #'SnapDump-BasicClient'
}

{ #category : #accessing }
SDBasicHTTPStore class >> storeName [
	^ #http
]

{ #category : #'as yet unclassified' }
SDBasicHTTPStore >> applyConfig: aConfig [
	uri := aConfig uri.
   username := aConfig username.
   password := aConfig password
]

{ #category : #accessing }
SDBasicHTTPStore >> client [
	^ ZnClient new
		setBasicAuthenticationUsername: username password: password 
]

{ #category : #testing }
SDBasicHTTPStore >> hasSnapshotNamed: snapshotId [
	^ (self client
		url: (self urlFor: snapshotId);
		head;
		response) status = 200
]

{ #category : #'as yet unclassified' }
SDBasicHTTPStore >> store: snapshot [
	| writeStream request |
	writeStream := ByteArray new writeStream.
	[ snapshot writeTo: writeStream .
	request := ZnRequest put: (self urlFor: snapshot id).
	snapshot preparePutRequest: request.
	request entity: (ZnByteArrayEntity bytes: writeStream contents).
	self client
		request: request;
		put
	]
		on: Error 
		do: [ :err | err pass. Transcript show: 'error happened: ', err description ]
]

{ #category : #accessing }
SDBasicHTTPStore >> uri: anUri [
	uri := anUri asZnUrl 
]

{ #category : #accessing }
SDBasicHTTPStore >> urlFor: snapshotId [
	^ uri / #snapshots / snapshotId
]

{ #category : #accessing }
SDBasicHTTPStore >> username: aUsername password: aPassword [
	username := aUsername.
	password := aPassword
]
