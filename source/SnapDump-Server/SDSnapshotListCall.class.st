Class {
	#name : #SDSnapshotListCall,
	#superclass : #SDOpenAPICall,
	#instVars : [
		'projectName',
		'versionString'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDSnapshotListCall class >> parameterProjectName [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'projectName';
		in: #path;
		beString;
		required: true;
		description: 'Name of the project'

]

{ #category : #accessing }
SDSnapshotListCall class >> parameterVersionString [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'versionString';
		in: #path;
		beString;
		required: true;
		description: 'Version identitfier'

]

{ #category : #accessing }
SDSnapshotListCall class >> path [
	^ '/projects/{projectName}/versions/{versionString}/snapshots'
]

{ #category : #accessing }
SDSnapshotListCall >> get [
	self jsonResponse: (
	(self store 
		projectNamed: projectName) 
			versionWithString: versionString) signatures
	
]
