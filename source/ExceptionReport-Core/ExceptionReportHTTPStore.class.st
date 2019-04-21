Class {
	#name : #ExceptionReportHTTPStore,
	#superclass : #ExceptionReportStore,
	#instVars : [
		'uri',
		'username',
		'password',
		'project',
		'version'
	],
	#category : 'ExceptionReport-Core'
}

{ #category : #accessing }
ExceptionReportHTTPStore class >> storeName [
	^ #http
]

{ #category : #'as yet unclassified' }
ExceptionReportHTTPStore >> applyConfig: aConfig [
	uri := aConfig uri.
   username := aConfig username.
   password := aConfig password.
	project := aConfig project.
	version := aConfig version
]

{ #category : #accessing }
ExceptionReportHTTPStore >> client [
	^ ZnClient new
		setBasicAuthenticationUsername: username password: password 
]

{ #category : #accessing }
ExceptionReportHTTPStore >> descriptionFor: exception [
	^ (super descriptionFor: exception)
		at: 'project' put: project;
		at: 'version' put: version;
		yourself
]

{ #category : #testing }
ExceptionReportHTTPStore >> hasSnapshotNamed: dict [
	^ (self client
		url: (self urlFor: dict);
		head;
		response) status = 200
]

{ #category : #accessing }
ExceptionReportHTTPStore >> project: aString [ 
	project := aString
]

{ #category : #'as yet unclassified' }
ExceptionReportHTTPStore >> storeDebugContext: aContext description: dict [
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
ExceptionReportHTTPStore >> uri: anUri [
	uri := anUri asZnUrl 
]

{ #category : #accessing }
ExceptionReportHTTPStore >> urlFor: dict [
	^ uri / (dict at: 'project') asString / (dict at: 'version') asString / (self descriptionString: dict) asString
]

{ #category : #accessing }
ExceptionReportHTTPStore >> username: aUsername password: aPassword [
	username := aUsername.
	password := aPassword
]

{ #category : #accessing }
ExceptionReportHTTPStore >> version: aString [ 
	version := aString
]
