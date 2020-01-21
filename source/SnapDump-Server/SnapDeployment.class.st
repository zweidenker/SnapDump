Class {
	#name : #SnapDeployment,
	#superclass : #Object,
	#category : #'SnapDump-Server'
}

{ #category : #decoration }
SnapDeployment class >> closeMorphs [
	World submorphs do: #delete
	
]

{ #category : #decoration }
SnapDeployment class >> disableChangesLog [
	ChangesLog reset.
	self 
		removeFromStartup: SmalltalkImage
]

{ #category : #decoration }
SnapDeployment class >> disableEpicea [
	EpMonitor current disable.
	self 
		removeFromStartup: EpLostChangesDetector;
		removeFromStartup: OmDeferrer;
		removeFromStartup: OmSessionStore
		
]

{ #category : #decoration }
SnapDeployment class >> disableFreeType [
	FreeTypeSystemSettings loadFt2Library: false.
	self 
		removeFromStartup: FreeTypeCache;
		removeFromStartup: FreeTypeSettings;
		removeFromStartup: LogicalFont;
		removeFromStartup: StrikeFont
		
	
]

{ #category : #decoration }
SnapDeployment class >> disableIceberg [
	self removeFromStartup: LGitLibrary
	
]

{ #category : #decoration }
SnapDeployment class >> prepare [ 
	self closeMorphs.
	self disableEpicea.
	self disableFreeType.
	self disableIceberg
	
]

{ #category : #decoration }
SnapDeployment class >> removeFromStartup: aClass [
	SessionManager default unregisterClassNamed: aClass name
	
]
