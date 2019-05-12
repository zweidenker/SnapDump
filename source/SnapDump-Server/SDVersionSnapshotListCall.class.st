Class {
	#name : #SDVersionSnapshotListCall,
	#superclass : #SDOpenAPICall,
	#instVars : [
		'projectName',
		'versionString'
	],
	#category : #'SnapDump-Server-REST'
}

{ #category : #accessing }
SDVersionSnapshotListCall class >> parameterProjectName [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'projectName';
		in: #path;
		beString;
		required: true;
		description: 'Name of the project'

]

{ #category : #accessing }
SDVersionSnapshotListCall class >> parameterVersionString [
	<openApiParameter: #( common )>
	^ OAParameter new
		name: 'versionString';
		in: #path;
		beString;
		required: true;
		description: 'Version identitfier'

]

{ #category : #accessing }
SDVersionSnapshotListCall class >> path [
	^ '/projects/{projectName}/versions/{versionString}/snapshots'
]

{ #category : #accessing }
SDVersionSnapshotListCall >> get [
	self jsonResponse: (self projectNamed: projectName versionAt: versionString) snapshots
	
]
