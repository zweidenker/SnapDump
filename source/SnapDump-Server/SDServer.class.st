Class {
	#name : #SDServer,
	#superclass : #Object,
	#classInstVars : [
		'port'
	],
	#category : #'SnapDump-Server-Server'
}

{ #category : #accessing }
SDServer class >> port: aNumber [
	port := aNumber 
]
