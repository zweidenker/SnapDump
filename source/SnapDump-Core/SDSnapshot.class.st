Class {
	#name : #SDSnapshot,
	#superclass : #Object,
	#instVars : [
		'className',
		'selector',
		'exceptionClass',
		'context'
	],
	#category : #'SnapDump-Core'
}

{ #category : #'as yet unclassified' }
SDSnapshot class >> exception: anException [
	^ self new exception: anException
]

{ #category : #accessing }
SDSnapshot >> className [
	^ className
]

{ #category : #accessing }
SDSnapshot >> className: aString [ 
	className := aString
]

{ #category : #accessing }
SDSnapshot >> context [
	^ context
]

{ #category : #accessing }
SDSnapshot >> exception: exception [
	| method |
	method := exception signalerContext sender method.
	className := method classBinding key asString.
	selector :=  (method selector asString copyWithout: $:) .
	exceptionClass := (exception class name).
	context := exception signalerContext 
]

{ #category : #accessing }
SDSnapshot >> exceptionClass [
	^ exceptionClass
]

{ #category : #accessing }
SDSnapshot >> exceptionClass: aString [ 
	exceptionClass := aString
]

{ #category : #accessing }
SDSnapshot >> selector [
	^ selector
]

{ #category : #accessing }
SDSnapshot >> selector: aString [ 
	selector := aString
]
