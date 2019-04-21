Class {
	#name : #ExceptionReportFilesystemStore,
	#superclass : #ExceptionReportStore,
	#instVars : [
		'path'
	],
	#category : 'ExceptionReport-Core'
}

{ #category : #accessing }
ExceptionReportFilesystemStore class >> storeName [
	^ #file
]

{ #category : #'as yet unclassified' }
ExceptionReportFilesystemStore >> filenameFor: dict [
	^ (self descriptionString: dict) , '.fuel'
]

{ #category : #testing }
ExceptionReportFilesystemStore >> hasSnapshotNamed: description [
	^ ( path / (self filenameFor: description) ) exists
]

{ #category : #accessing }
ExceptionReportFilesystemStore >> path: anObject [
	path := anObject asFileReference.
	path ensureCreateDirectory 
]

{ #category : #'as yet unclassified' }
ExceptionReportFilesystemStore >> storeDebugContext: aContext description: dict [
	| stream |
	stream := (path / (self filenameFor: dict) ) binaryWriteStream.
	[ self 
		serializeContext: aContext 
		on: stream ]
		ensure: [ stream close ]
]
