<cfoutput>
<cfsetting requesttimeout="9999999">
<h1>QoQ Tests - Same query on different query sizes 20-1Mil</h1>
<h2>
	<cfif server.keyExists( 'boxlang' ) >
		BoxLang: #server.boxlang.version#
	<cfelseif server.keyExists( 'lucee' ) >
		Lucee: #server.lucee.version#
	<cfelse>
		Adobe ColdFusion: #server.coldfusion.productversion#
	</cfif>
</h2>
<cfscript>
	nullValue = () => {};
	
	employees = queryNew( 
		'name,age,email,department,isContract,yearsEmployed,sickDaysLeft,hireDate,isActive,empID,favoriteColor',
		'varchar,integer,varchar,varchar,bit,integer,integer,date,bit,varchar,varchar' );	
	
	results = [];
	i = 0;
	
	cfloop( from=1, to=53, index="i" ) {


		cfloop( from=1, to=i^2, index="k" ) {
			i++;
			employees.addRow(
			[
				[ 'John Doe #i#',28,'John#i#@company.com','Acounting',false,2,4,createDate(2010,1,21),true,'sdf','red' ],
				[ 'Jane Doe #i#',22,'Jane#i#@company.com','Acounting',false,0,8,createDate(2011,2,21),true,'hdfg','blue' ],
				[ 'Bane Doe #i#',28,'Bane#i#@company.com','Acounting',true,3,2,createDate(2012,3,21),true,'sdsfsff','green' ],
				[ 'Tom Smith #i#',25,'Tom#i#@company.com','Acounting',false,6,4,createDate(2013,4,21),false,'HDFG','yellow' ],
				[ 'Harry Johnson #i#',38,'Harry#i#@company.com','IT',false,8,6,createDate(2014,5,21),true,'4ge','purple' ],
				[ 'Jason Wood #i#',37,'Jason#i#@company.com','IT',false,19,4,createDate(2015,6,21),true,'ShrtDF','Red' ],
				[ 'Doris Calhoun #i#',67,'Doris#i#@company.com','IT',true,3,6,createDate(2016,7,21),true,'sgsdg','Blue' ],
				[ 'Mary Root #i#',17,'Mary#i#@company.com','IT',false,8,2,createDate(2017,8,21),true,'','Green' ],
				[ 'Aurthur Duff #i#',23,'Aurthur#i#@company.com','IT',false,4,0,createDate(2018,9,21),true,nullValue(),'Yellow' ],
				[ 'Luis Hake #i#',29,'Luis#i#@company.com','IT',true,9,5,createDate(2019,10,21),true,nullValue(),'Purple' ],
				[ 'Gavin Bezos #i#',46,'Gavin#i#@company.com','HR',false,2,5,createDate(2020,11,21),false,nullValue(),'RED' ],
				[ 'Nancy Garmon #i#',57,'Nancy#i#@company.com','HR',false,14,9,createDate(2005,12,21),true,nullValue(),'BLUE' ],
				[ 'Tom Zuckerburg #i#',27,'Tom#i#@company.com','HR',true,16,10,createDate(2006,1,21),true,nullValue(),'GREEN' ],
				[ 'Richard Gates #i#',62,'Richard#i#@company.com','Executive',false,11,1,createDate(2007,2,21),true,nullValue(),'YELLOW' ],
				[ 'Amy Merryweather #i#',58,'Amy#i#@company.com','Executive',false,12,2,createDate(2008,3,21),true,nullValue(),'PURPLE' ],
				[ 'Sue Davenport #i#',33,'Sue#i#@company.com','Executive',false,12,3,createDate(2008,3,23),false,nullValue(),'green' ],
				[ 'Ted Doe #i#',24,'Ted#i#@company.com','IT',false,12,3,createDate(2008,3,23),false,'123345','goldenrod' ],
				[ 'Brad McMath #i#',78,'Brad#i#@company.com','Acconting',false,12,3,createDate(2005,3,23),false,'789012','chartruice' ],
				[ 'Teddy Rover #i#',36,'Ted#i#@company.com','Janitorial',false,12,3,createDate(2002,3,23),false,'myempid','red' ],
				[ 'Billy Boppy #i#',28,'Bopster#i#@company.com','IT',false,12,3,createDate(2018,3,23),false,'anotherempid','blood red' ]
			] );
		}
sql = "
SELECT age, name+department as nameDepartment, isActive, isContract, count(1) as _count
FROM employees
where age > 20
	AND isActive = 1
group by name, age, department, isActive, isContract
HAVING count(1) > 3
ORDER BY name, age, department, isActive, isContract
			";
		start = getTickCount();
		q = queryExecute( 
			sql,
			[],
			{ dbtype="query" })
		time = getTickCount() - start;

		results.append( {
			time=time,
			rows=employees.recordCount
			
		} );
	}

</cfscript>
<pre>#encodeForHTML( sql )#</pre>
	<table border="1">
		<tr>
			<th>Rows</th>
			<th>Time (ms)</th>
		</tr>
		<cfloop array="#results#" index="result">
			<tr>
				<td>#numberFormat( result.rows )#</td>
				<td>#result.time# ms</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>