Class {
	#name : #SnapDumpServerDelegate,
	#superclass : #ZnJSONRestServerDelegate,
	#instVars : [
		'store'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #'error handling' }
SnapDumpServerDelegate >> serverError: request exception: exception [
	SnapDump handleException: exception.
	^ super serverError: request exception: exception
]

{ #category : #accessing }
SnapDumpServerDelegate >> store [
	^ store
]

{ #category : #accessing }
SnapDumpServerDelegate >> store: anObject [
	store := anObject
]
