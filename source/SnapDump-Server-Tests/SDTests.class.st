Class {
	#name : #SDTests,
	#superclass : #TestCase,
	#instVars : [
		'rootPath',
		'snapDump'
	],
	#category : #'SnapDump-Server-Tests'
}

{ #category : #running }
SDTests >> filesystemStore [ 
	^ SDFilesystemStore new path: rootPath
]

{ #category : #running }
SDTests >> setUp [ 
	rootPath := FileSystem memory / #snaps.
	snapDump := SnapDump new store: self store. 
	snapDump 
		project: 'TestProject';
		version: '0.1'
]

{ #category : #accessing }
SDTests >> store [
	self subclassResponsibility 
]
