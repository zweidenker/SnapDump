Class {
	#name : #SDProject,
	#superclass : #Object,
	#instVars : [
		'name',
		'store'
	],
	#category : #'SnapDump-Core'
}

{ #category : #'instance creation' }
SDProject class >> name: aString [ 
	^ self new name: aString 
]

{ #category : #accessing }
SDProject class >> neoJsonMapping: mapper [
	mapper for: self do: [ :mapping |
		mapping mapInstVars: #(name) ]
]

{ #category : #comparing }
SDProject >> = aProject [
	^ name = aProject name
]

{ #category : #comparing }
SDProject >> hash [
	^ name hash
]

{ #category : #accessing }
SDProject >> name [
	^ name
]

{ #category : #accessing }
SDProject >> name: anObject [
	name := anObject
]

{ #category : #printing }
SDProject >> printOn: aStream [
	aStream << name
]

{ #category : #'as yet unclassified' }
SDProject >> removeVersion: aVersion [ 
	self shouldBeImplemented.
]

{ #category : #accessing }
SDProject >> store [
	^ store
]

{ #category : #accessing }
SDProject >> store: anObject [
	store := anObject
]

{ #category : #'as yet unclassified' }
SDProject >> versionAt: aString [ 
	^ self versionAt: aString ifAbsent: [ NotFound signal ]
		
]

{ #category : #'as yet unclassified' }
SDProject >> versionAt: aString ifAbsent: aBlock [
	^ self versions 
		detect: [ :each | each string = aString ]
		ifNone: aBlock
		
]

{ #category : #'as yet unclassified' }
SDProject >> versionAt: aString ifAbsentPut: aBlock [
	^ self versions
		at: aString 
		ifAbsentPut: aBlock
]

{ #category : #'as yet unclassified' }
SDProject >> versions [
	^ store versionsOfProject: self
]
