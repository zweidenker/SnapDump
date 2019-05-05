Class {
	#name : #SnapDump,
	#superclass : #Object,
	#instVars : [
		'store',
		'project',
		'version'
	],
	#classInstVars : [
		'current'
	],
	#category : #'SnapDump-Client'
}

{ #category : #'*SnapDump-Client' }
SnapDump >> projects [
	^ store projects
]
