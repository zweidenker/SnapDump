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

{ #category : #accessing }
SDProject >> name [
	^ name
]

{ #category : #accessing }
SDProject >> name: anObject [
	name := anObject
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
SDProject >> versions [
	^ store versionsOfProject: self
]
