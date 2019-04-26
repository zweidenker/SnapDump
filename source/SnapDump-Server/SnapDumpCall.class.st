Class {
	#name : #SnapDumpCall,
	#superclass : #ZnJSONRestCall,
	#classVars : [
		'path'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #testing }
SnapDumpCall class >> isAbstract [
	^ self = SnapDumpCall  
]

{ #category : #accessing }
SnapDumpCall class >> path [
	^ path
]

{ #category : #accessing }
SnapDumpCall class >> path: aString [
	path := aString asFileReference 
]

{ #category : #accessing }
SnapDumpCall >> configurations [
	^ (self storagePath allChildrenMatching: '*.json') collect: [:each | NeoJSONObject fromString: each ]
]

{ #category : #'as yet unclassified' }
SnapDumpCall >> storagePath [
	^ self class path "ensureCreateDirectory"
]

{ #category : #accessing }
SnapDumpCall >> store [
	^ self delegate store
]
