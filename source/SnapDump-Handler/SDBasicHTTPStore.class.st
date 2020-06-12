Class {
	#name : #SDBasicHTTPStore,
	#superclass : #SDStore,
	#instVars : [
		'username',
		'uri',
		'password'
	],
	#category : #'SnapDump-Handler'
}

{ #category : #testing }
SDBasicHTTPStore class >> storeName [ 

	#basicHttp
]
