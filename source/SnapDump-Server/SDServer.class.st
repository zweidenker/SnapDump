Class {
	#name : #SDServer,
	#superclass : #Object,
	#instVars : [
		'port',
		'server',
		'path',
		'debugMode'
	],
	#classInstVars : [
		'instance',
		'version'
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

{ #category : #accessing }
SDServer class >> repositoryDescription [
	| snapDumpRepo |
	snapDumpRepo := IceRepository registry detect: [ :each | each name = 'SnapDump' ].
	^ snapDumpRepo head description
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
SDServer class >> stop [
	self instance stop
]

{ #category : #accessing }
SDServer class >> version [
	^ version
]

{ #category : #accessing }
SDServer class >> version: aString [
	version := aString
]

{ #category : #accessing }
SDServer >> apiHandler [ 
	^ SDServerDelegate new
		store: (SDFilesystemStore new path: path );
		uriSpace: (OpenAPIUriSpace new
			rootClass: SDOpenAPICall)
]

{ #category : #accessing }
SDServer >> debugMode [

	^ debugMode ifNil: [ false ]
]

{ #category : #accessing }
SDServer >> debugMode: aBoolean [

	debugMode := aBoolean
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
		map: 'api'
			to:
			(ZnPrefixMappingDelegate new
				map: SDSnapshot apiVersion
				to: self apiHandler);
		map: 'health' to: ZnTestRunnerDelegate new
]

{ #category : #accessing }
SDServer >> start [ 
				
	server := (ZnServer on: port)
		delegate: self serverDelegate;
		debugMode: self debugMode;
		start.
]

{ #category : #accessing }
SDServer >> stop [ 
	server stop
]

{ #category : #'accessing - tests' }
SDServer >> znServer [
	"for test purposes"
	
	^ server
]
