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

{ #category : #accessing }
SDServer >> apiHandler [
	^ ZnPrefixMappingDelegate new 
		map: 'api' 
		to: (SDServerDelegate new
			store: (SDFilesystemStore new path: path );
			uriSpace: (ZnCallHierarchyRestUriSpace new
				rootClass: SDCall)).

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
SDServer >> start [ 
				
	server := (ZnServer on: port)
		delegate: self apiHandler;
		debugMode: true;
		start.
]
