Class {
	#name : #SDump,
	#superclass : #Object,
	#instVars : [
		'className',
		'selector',
		'exceptionClass'
	],
	#category : #'SnapDump-Core'
}

{ #category : #accessing }
SDump >> className: aString [ 
	className := aString
]

{ #category : #accessing }
SDump >> exceptionClass [
	^ exceptionClass
]

{ #category : #accessing }
SDump >> exceptionClass: aString [ 
	exceptionClass := aString
]

{ #category : #accessing }
SDump >> selector [
	^ selector
]

{ #category : #accessing }
SDump >> selector: aString [ 
	selector := aString
]
