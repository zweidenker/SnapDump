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
	SnapDump storeException: exception.
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
