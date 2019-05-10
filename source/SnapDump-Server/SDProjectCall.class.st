Class {
	#name : #SDProjectCall,
	#superclass : #SDOpenAPICall,
	#instVars : [
		'projectName'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDProjectCall class >> parameterProjectName [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'projectName';
		in: #path;
		beString;
		required: true;
		description: 'Name of the project'

]

{ #category : #accessing }
SDProjectCall class >> path [
	^ '/projects/{projectName}'
]

{ #category : #public }
SDProjectCall >> get [
	self jsonResponse: (self store projectNamed: projectName ifAbsent: [ SDProject name: projectName ]). 
	
]
