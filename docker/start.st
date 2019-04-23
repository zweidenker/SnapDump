| apiHandler healthHandler metricsHandler prefixHandler server |
Author fullName: 'docker'.

SnapDump
   hackUIManager;
   store: (SDFilesystemStore new path: '/var/lib/snap-dump').

SnapDumpCall path: '/var/lib/snap-dump'.

apiHandler := (SnapDumpServerDelegate new
    uriSpace: (ZnCallHierarchyRestUriSpace new
           rootClass: SnapDumpCall)).
        
healthHandler := ZnTestRunnerDelegate new.

prefixHandler := PrefixMappingDelegate new 
    map: 'api' to: apiHandler;
    map: 'health' to: healthHandler.
    
ZnLogEvent logToTranscript.

server := (ZnServer on: 5555)
   logLevel: 1;
   delegate: prefixHandler;
   start.
