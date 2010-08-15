<cfcomponent extends="BasePlugin"> 
 
    <cffunction name="init" access="public" output="false" returntype="any"> 
        <cfargument name="mainManager" type="any" required="true" /> 
        <cfargument name="preferences" type="any" required="true" /> 
         
        <cfset setManager(arguments.mainManager) /> 
        <cfset setPreferencesManager(arguments.preferences) /> 
			                    
        <cfreturn this/>     
	</cffunction> 
 
    <cffunction name="setup" hint="This is run when a plugin is activated" access="public" output="false" returntype="any"> 
        <cfreturn "Plugin activated." /> 
    </cffunction> 
     
    <cffunction name="unsetup" hint="This is run when a plugin is de-activated" access="public" output="false" returntype="any"> 
        <cfreturn /> 
    </cffunction> 
 
    <cffunction name="handleEvent" hint="Asynchronous event handling" access="public" output="false" returntype="any"> 
        <cfargument name="event" type="any" required="true" />         
        <cfreturn /> 
    </cffunction> 
 
    <cffunction name="processEvent" hint="Synchronous event handling" access="public" output="false" returntype="any"> 
        <cfargument name="event" type="any" required="true" /> 
		
		<cfset var ev = arguments.event />
		<cfset var eventname = ev.name />
		
		<cfswitch expression="#eventname#">
			
			<cfcase value="beforePostContentEnd">
				
				<cfset var currentpost = event.getData().context.currentpost>
				<cfset var body = currentpost.getContent() />
				<cfset body = handleGists(body)>				
				<cfset currentpost.setContent(body)>
			
			</cfcase>
		
		</cfswitch>	
					
        <cfreturn arguments.event /> 
    </cffunction> 
	
	<!--- Private --->
	
	<cffunction name="handleGists" access="private" returntype="string">
		<cfargument name="content" required="true" type="string">

		<cfset var js = "">		
		<cfset var match = refindnocase("\[.*?\]",content,1,true)>
		
		<cfloop condition="#match.len[1] gt 0#">
			<cfset var item = mid(content,match.pos[1],match.len[1])>
			
			<!--- is a gist ? --->
			<cfif refindnocase('\[gist:',item,1)>
				
				<cfset var gist = rereplaceNoCase(item,'\[|\]','','All')>
				<cfset var gistlen = listLen(gist,':')>
				
				<!--- is well formed ? --->
				<cfif gistlen gte 2>
					<cfset var id = listGetAt(gist,2,':')>
					<cfset var filename = gistlen eq 3 ? listGetAt(gist,3,':') : "">
					
					<cfsavecontent variable="js">
					<cfoutput><script src="http://gist.github.com/#id#.js<cfif len(filename)>?file=#urlEncodedFormat(filename)#</cfif>"></script></cfoutput>
					</cfsavecontent>
					
					<cfset content = replaceNoCase(content,item,trim(js))>
					
				</cfif>
			
			</cfif>		
	
			<cfset var pos = match.pos[1] + match.len[1]>
			<cfset match = refindnocase("\[.*?\]",content,pos,true)>	
		</cfloop>
		
		<cfreturn content>
	</cffunction>
	
	 
</cfcomponent>