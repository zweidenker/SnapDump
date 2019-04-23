Class {
	#name : #SDServerDelegate,
	#superclass : #ZnJSONRestServerDelegate,
	#category : #'SnapDump-Server'
}

{ #category : #'error handling' }
SDServerDelegate >> serverError: request exception: exception [
	SnapDump handleException: exception.
	^ super serverError: request exception: exception
]
