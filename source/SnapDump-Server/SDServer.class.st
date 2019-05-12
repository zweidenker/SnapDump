Class {
	#name : #SDServer,
	#superclass : #Object,
	#instVars : [
		'port',
		'server',
		'path'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'SnapDump-Server'
}

{ #category : #accessing }
SDServer class >> instance [ 
	^ instance ifNil: [ 
		instance := self new ]
]

{ #category : #'as yet unclassified' }
SDServer class >> port: aNumber path: aFileReference [
	^ self instance 
		port: aNumber;
		path: aFileReference asFileReference;
		yourself
]

{ #category : #'as yet unclassified' }
SDServer class >> startOnPort: aNumber path: aFileReference [
	^ self instance 
		port: aNumber;
		path: aFileReference asFileReference;
		start;
		yourself
]

{ #category : #accessing }
SDServer >> apiHandler [ 
	^ SDServerDelegate new
		store: (SDFilesystemStore new path: path );
		uriSpace: (OpenAPIUriSpace new
			rootClass: SDOpenAPICall)
]

{ #category : #accessing }
SDServer >> path: anObject [
	path := anObject
]

{ #category : #accessing }
SDServer >> port: aNumber [
	port := aNumber
]

{ #category : #accessing }
SDServer >> serverDelegate [
	^ ZnPrefixMappingDelegate new 
		map: 'api' to: self apiHandler;
		map: 'health' to: ZnTestRunnerDelegate new.

]

{ #category : #accessing }
SDServer >> start [ 
				
	server := (ZnServer on: port)
		delegate: self serverDelegate;
		start.
]
