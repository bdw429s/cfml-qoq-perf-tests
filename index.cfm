<cfoutput>
<cfsetting requesttimeout="9999999">
<h1>QoQ Tests</h1>
<h2>
	<cfif server.keyExists( 'boxlang' ) >
		BoxLang: #server.boxlang.version#
	<cfelseif server.keyExists( 'lucee' ) >
		Lucee: #server.lucee.version#
	<cfelse>
		Adobe ColdFusion: #server.coldfusion.productversion#
	</cfif>
</h2>
<a href="test.cfm">Various Queries against 1 Million rows</a><br>
<a href="test2.cfm">Same query on different query sizes 20-1Mil</a>
</cfoutput>