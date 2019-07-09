Class {
	#name : #SDOpenAPICall,
	#superclass : #OpenAPICall,
	#classVars : [
		'path'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDOpenAPICall >> jsonResponse: data [
	| entity |
	entity := ZnEntity with: (self toJson: data) type: ZnMimeType applicationJson.
	self response: (ZnResponse ok: entity)
]

{ #category : #accessing }
SDOpenAPICall >> projectNamed: aString [
	^ self store 
		projectNamed: aString 
		ifAbsent: [ ZnRespond  signalWith: (ZnResponse notFound: request uri) ]
]

{ #category : #accessing }
SDOpenAPICall >> projectNamed: projectName versionAt: versionString [
	^ (self projectNamed: projectName) 
		versionAt: versionString
		ifAbsent: [ ZnRespond signalWith: (ZnResponse notFound: request uri) ]
	
]

{ #category : #public }
SDOpenAPICall >> snapshotWithId: aString [
	[ ^ self store snapshotWithId: aString ]
		on: NotFound 
		do: [ :err |
			ZnRespond signalWith: (ZnResponse notFound: request url) ]
]

{ #category : #accessing }
SDOpenAPICall >> store [
	^ self delegate store
]

{ #category : #utils }
SDOpenAPICall >> toJson: data [
	^ self delegate toJson: data
]
