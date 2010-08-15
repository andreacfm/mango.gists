<cfscript>
component displayname="testGists" extends="mxunit.framework.TestCase"{
	
	public void function setUp(){
		variables.handler = createObject('component','app.gists.Handler');
	}	

	public void function testHandleGists(){
		var handler = variables.handler;
		var content = "first gist is [gist:123456:one] and another gist is [gist:123456]";
		
		makePublic(handler,'handleGists');
		
		content = handler.handleGists(content);
		
		assertTrue(findNoCase('<script src="http://gist.github.com/123456.js?file=one">',content));
		assertTrue(findNoCase('<script src="http://gist.github.com/123456.js">',content));
	
	}

}
</cfscript>
