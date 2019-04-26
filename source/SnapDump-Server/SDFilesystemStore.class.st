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
SDFilesystemStore >> filenameFor: snapshot [
	^ (self descriptionString: snapshot) , '.fuel'
]

{ #category : #testing }
SDFilesystemStore >> hasSnapshotNamed: snapshot [
	^ ( path / (self filenameFor: snapshot) ) exists
]

{ #category : #accessing }
SDFilesystemStore >> path: anObject [
	path := anObject asFileReference.
	path ensureCreateDirectory 
]

{ #category : #'as yet unclassified' }
SDFilesystemStore >> store: snapshot [
	| stream file |
	file := path / (self filenameFor: snapshot).
	stream := file fileSystem  binaryWriteStreamOn: file path.
	[ self 
		serializeContext: snapshot context 
		on: stream ]
		ensure: [ stream close ]
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
