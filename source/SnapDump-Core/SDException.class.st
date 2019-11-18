Class {
	#name : #SDException,
	#superclass : #Object,
	#instVars : [
		'string',
		'version',
		'id',
		'className',
		'selector',
		'exceptionClass'
	],
	#category : #'SnapDump-Core'
}

{ #category : #services }
SDException >> freeSlots [

	^ self store freeSlotsForException: self
]

{ #category : #accessing }
SDException >> id [ 
	
	^ id
]

{ #category : #accessing }
SDException >> id: aString [
	
	id := aString
]

{ #category : #accessing }
SDException >> projectName [

	^ version projectName
]

{ #category : #services }
SDException >> snapshots [ 
	
	^ self store snapshotsWithException: self
]

{ #category : #accessing }
SDException >> store [
	^ version store
]

{ #category : #accessing }
SDException >> version [
	^ version
]

{ #category : #accessing }
SDException >> version: anObject [
	version := anObject
]

{ #category : #accessing }
SDException >> versionString [

	^ version string
]
