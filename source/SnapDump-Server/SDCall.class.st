Class {
	#name : #SDCall,
	#superclass : #ZnJSONRestCall,
	#classVars : [
		'path'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #testing }
SDCall class >> isAbstract [
	^ self = SDCall  
]

{ #category : #accessing }
SDCall class >> path [
	^ path
]

{ #category : #accessing }
SDCall class >> path: aString [
	path := aString asFileReference 
]

{ #category : #accessing }
SDCall >> configurations [
	^ (self storagePath allChildrenMatching: '*.json') collect: [:each | NeoJSONObject fromString: each ]
]

{ #category : #'as yet unclassified' }
SDCall >> storagePath [
	^ self class path "ensureCreateDirectory"
]

{ #category : #accessing }
SDCall >> store [
	^ self delegate store
]
