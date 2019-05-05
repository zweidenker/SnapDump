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
SDOpenAPICall >> store [
	^ self delegate store
]

{ #category : #utils }
SDOpenAPICall >> toJson: data [
	^ self delegate toJson: data
]
