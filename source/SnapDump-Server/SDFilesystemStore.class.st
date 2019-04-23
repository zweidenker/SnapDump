Class {
	#name : #SDFilesystemStore,
	#superclass : #SDStore,
	#instVars : [
		'path'
	],
	#category : #'SnapDump-Server-Store'
}

{ #category : #accessing }
SDFilesystemStore class >> storeName [
	^ #file
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> filenameFor: dict [
	^ (self descriptionString: dict) , '.fuel'
]

{ #category : #testing }
SDFilesystemStore >> hasSnapshotNamed: description [
	^ ( path / (self filenameFor: description) ) exists
]

{ #category : #accessing }
SDFilesystemStore >> path: anObject [
	path := anObject asFileReference.
	path ensureCreateDirectory 
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> storeDebugContext: aContext description: dict [
	| stream |
	stream := (path / (self filenameFor: dict) ) binaryWriteStream.
	[ self 
		serializeContext: aContext 
		on: stream ]
		ensure: [ stream close ]
]
