Class {
	#name : #SnapDumpServer,
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
SnapDumpServer class >> instance [ 
	^ instance ifNil: [ 
		instance := self new ]
]

{ #category : #'as yet unclassified' }
SnapDumpServer class >> port: aNumber path: aFileReference [
	^ self instance 
		port: aNumber;
		path: aFileReference asFileReference;
		yourself
]

{ #category : #accessing }
SnapDumpServer >> apiHandler [
	^ ZnPrefixMappingDelegate new 
		map: 'api' 
		to: (SDServerDelegate new
			store: (SDFilesystemStore new path: path );
			uriSpace: (ZnCallHierarchyRestUriSpace new
				rootClass: SDCall)).

]

{ #category : #accessing }
SnapDumpServer >> path: anObject [
	path := anObject
]

{ #category : #accessing }
SnapDumpServer >> port: aNumber [
	port := aNumber
]

{ #category : #accessing }
SnapDumpServer >> start [ 
				
	server := (ZnServer on: port)
		delegate: self apiHandler;
		debugMode: true;
		start.
]
