Class {
	#name : #SDServerDelegate,
	#superclass : #ZnJSONRestServerDelegate,
	#instVars : [
		'store'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #'error handling' }
SDServerDelegate >> serverError: request exception: exception [
	| project version |
	project := (SDProject name: 'SnapDump').
	version := (SDVersion string: (SDServer version ifNil: [ 'None' ]))
		project: project.
	[ self store storeSnapshot: (exception asSnapshot
		version: version;
		yourself ) ]
		on: Error do: [ :err | "nothing we can do here" ]	.
	^ super serverError: request exception: exception
]

{ #category : #accessing }
SDServerDelegate >> store [
	^ store
]

{ #category : #accessing }
SDServerDelegate >> store: anObject [
	store := anObject
]
