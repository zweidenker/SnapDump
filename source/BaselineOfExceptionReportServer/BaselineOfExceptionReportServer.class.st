Class {
	#name : #BaselineOfExceptionReportServer,
	#superclass : #BaselineOf,
	#category : 'BaselineOfExceptionReportServer'
}

{ #category : #baselines }
BaselineOfExceptionReportServer >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec package: #'ExceptionReport-Server' with: [
			spec requires: #( 'ExceptionReport' 'ZincHTTPComponents' ) ].
		spec package: #'ExceptionReport-Client'.
		spec 
			baseline: 'ExceptionReport' with: [ 
				 spec 
					repository: 'github://noha/pharo-toolbox/source'];
				
			baseline: 'ZincHTTPComponents' with: [ 
				spec 
					loads: #('REST');
					repository: 'github://zweidenker/zinc/repository'].

		spec 
			group: 'default' with: #( #'ExceptionReport-Server' );
			group: 'client' with: #( #'ExceptionReport-Client' ) ].

]
