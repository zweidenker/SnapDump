Class {
	#name : #SDTests,
	#superclass : #TestCase,
	#instVars : [
		'rootPath',
		'snapDump'
	],
	#category : #'SnapDump-Tests'
}

{ #category : #running }
SDTests >> filesystemStore [ 
	^ SDFilesystemStore new path: rootPath
]

{ #category : #running }
SDTests >> setUp [ 
	rootPath := FileSystem memory / #snaps.
	snapDump := SnapDump new store: self store. 

]

{ #category : #accessing }
SDTests >> store [
	self subclassResponsibility 
]
