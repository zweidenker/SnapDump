Class {
	#name : #ExceptionMock,
	#superclass : #Object,
	#instVars : [
		'snapshot'
	],
	#category : #'SnapDump-Core-Tests'
}

{ #category : #accessing }
ExceptionMock class >> snapshot: aSnapshot [
	^ self new
		snapshot: aSnapshot 
]

{ #category : #converting }
ExceptionMock >> asSnapshot [
	^ snapshot
]

{ #category : #accessing }
ExceptionMock >> description [
	^ 'an exception mock'
]

{ #category : #accessing }
ExceptionMock >> snapshot: anObject [
	snapshot := anObject
]
