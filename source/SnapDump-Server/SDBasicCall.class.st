Class {
	#name : #SDBasicCall,
	#superclass : #ZnJSONRestCall,
	#classVars : [
		'path'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #testing }
SDBasicCall class >> isAbstract [
	^ self = SDBasicCall  
]

{ #category : #accessing }
SDBasicCall class >> path [
	^ path
]

{ #category : #accessing }
SDBasicCall class >> path: aString [
	path := aString asFileReference 
]

{ #category : #accessing }
SDBasicCall >> configurations [
	^ (self storagePath allChildrenMatching: '*.json') collect: [:each | NeoJSONObject fromString: each ]
]

{ #category : #'as yet unclassified' }
SDBasicCall >> storagePath [
	^ self class path "ensureCreateDirectory"
]
