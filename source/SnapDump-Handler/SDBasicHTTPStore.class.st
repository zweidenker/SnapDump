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

{ #category : #'as yet unclassified' }
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

{ #category : #testing }
SDBasicHTTPStore >> hasSnapshotNamed: snapshotId [
	^ (self client
		url: (self urlForSnapshot: snapshotId);
		head;
		response) status = 200
]

{ #category : #testing }
SDBasicHTTPStore >> isSetUp [
	^ uri notNil
]

{ #category : #printing }
SDBasicHTTPStore >> printOn: aStream [
	aStream << uri asString
]

{ #category : #accessing }
SDBasicHTTPStore >> uri: anUri [
	uri := anUri asZnUrl 
]

{ #category : #accessing }
SDBasicHTTPStore >> urlForSnapshot: snapshotId [
	^ uri / #snapshots / snapshotId
]

{ #category : #accessing }
SDBasicHTTPStore >> username: aUsername password: aPassword [
	username := aUsername.
	password := aPassword
]

{ #category : #'as yet unclassified' }
SDBasicHTTPStore >> writeSnapshot: snapshot [
	| writeStream |
	writeStream := ByteArray new writeStream.
	[ snapshot writeTo: writeStream .
	self client
		url: (self urlForSnapshot: snapshot id);
		entity: (ZnByteArrayEntity bytes: writeStream contents);
		put
	]
		on: Error 
		do: [ :err | err pass. Transcript show: 'error happened: ', err description ]
]
