<cfoutput>
<cfsetting requesttimeout="9999999">
<h1>QoQ Tests - Various Queries against 1 Million rows</h1>
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
	if( !application.keyExists( 'employees') || !application.keyExists( 'departments') || !application.keyExists( 'colors') ) {
		application.employees = queryNew( 
			'name,age,email,department,isContract,yearsEmployed,sickDaysLeft,hireDate,isActive,empID,favoriteColor',
			'varchar,integer,varchar,varchar,bit,integer,integer,date,bit,varchar,varchar' );

		cfloop( from=1, to=50000, index="i" ) {
			application.employees.addRow(
			[
				[ 'John Doe #i#',28,'John#i#@company.com','Accounting',false,2,4,createDate(2010,1,21),true,'sdf','red' ],
				[ 'Jane Doe #i#',22,'Jane#i#@company.com','Accounting',false,0,8,createDate(2011,2,21),true,'hdfg','blue' ],
				[ 'Bane Doe #i#',28,'Bane#i#@company.com','Accounting',true,3,2,createDate(2012,3,21),true,'sdsfsff','green' ],
				[ 'Tom Smith #i#',25,'Tom#i#@company.com','Accounting',false,6,4,createDate(2013,4,21),false,'HDFG','yellow' ],
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
		
		application.departments = queryNew( 'name,code,slogan,isActive', 'varchar,varchar,varchar,bit', [
			[ 'Account[ing','AC','We count beans',1 ],
			[ 'IT','IT','We fix computers',1 ],
			[ 'HR','HR','We hire and fire',1 ],
			[ 'Executive','EX','We make the big decisions',1 ],
			[ 'Janitorial','JA','We clean up',0 ]
		] );
		
		application.colors = queryNew( 'name,hexcode', 'varchar,varchar', [
			[ 'red','##FF0000' ],
			[ 'blue','##0000FF' ],
			[ 'green','##00FF00' ],
			[ 'yellow','##FFFF00' ],
			[ 'purple','##800080' ],
			[ 'goldenrod','##DAA520' ],
			[ 'chartruice','##7FFF00' ],
			[ 'blood red','##660000' ]
		] );

	}
	variables.employees = application.employees;
	variables.departments = application.departments;
	variables.colors = application.colors;

queries = [

"SELECT name, age, upper( email ) as email, department, isContract, yearsEmployed, sickDaysLeft,
	hireDate, isActive, empID, favoriteColor, yearsEmployed*12 as monthsEmployed
FROM employees
WHERE age > 20
	AND department IN ('Accounting','IT','HR')
	AND isActive = 1
ORDER BY department, isContract, yearsEmployed desc",

"SELECT name, age, upper( email ) as email, department, isContract, isActive, empID, favoriteColor, yearsEmployed*12 as monthsEmployed
FROM employees
where age > 20
AND department = 'HR'
AND isActive = 1
UNION
SELECT name, age, upper( email ) as email, department, isContract, isActive, empID, favoriteColor, yearsEmployed*12 as monthsEmployed
FROM employees
where age > 20
AND department = 'Accounting'
AND isActive = 0
order by department, name, email, age desc",

"SELECT max(age) as maxAge, min(age) as minAge, count(1) as theCount
FROM employees
where department IN ('Accounting','IT')
AND isActive = 1",

"SELECT age, department, isActive, isContract, count(1) as theCount
FROM employees
where age > 20
AND isActive = 1
group by age, department, isActive, isContract
HAVING count(1) > 3
ORDER BY age, department, isActive, isContract",

"SELECT name + department as departmentName
FROM employees",

"SELECT *
FROM employees
where name like '%Harry%'",

"SELECT employees.name, departments.name as department, slogan
FROM employees, departments
WHERE  employees.department = departments.name 
	and employees.isActive = 1
and age > 20
AND department IN ('Accounting','IT','HR')  
order by employees.name",

// Doesn't work on Adobe CF
"SELECT employees.name, departments.name as department, slogan, hexcode
FROM employees, departments, colors
WHERE  employees.department = departments.name 
and employees.favoriteColor = colors.name
and employees.isActive = 1
and age > 20
AND department IN ('Accounting','IT','HR') 
order by employees.name",

// Doesn't work on Adobe CF or Lucee
"SELECT e.name, d.name as department, slogan, hexcode
FROM employees e
inner join departments d on e.department = d.name
inner join colors c on e.favoriteColor = c.name
WHERE e.isActive = 1
and e.age > 20
AND e.department IN ('Accounting','IT','HR')
order by e.name",

"SELECT name, department
FROM employees
WHERE department = 'Accounting'
UNION SELECT name, department
FROM employees
WHERE department = 'It'
UNION SELECT name, department
FROM employees
WHERE department = 'HR'
UNION SELECT name, department
FROM employees
WHERE department = 'Executive'
UNION SELECT name, department
FROM employees
WHERE department = 'Janitorial'
order by department, name"
];

	results = [];

	for( sql in queries ) {
		times = 3;
		try {
			cfloop( from=1, to=times, index="i" ) {
				start = getTickCount();
				options = { dbtype="query" };
				q = queryExecute( 
					sql,
					[],
					options)
				time = getTickCount() - start;
				// Record data the 3rd time, first two are warm-ups
				if( i == times) {
					results.append( {
						sql=sql,
						time=time,
						error=""
					} )
				}
			}
		} catch( any e ) {
			results.append( {
				sql=sql,
				time="N/A",				
				error=e.message
			} )
		}
	}

</cfscript>


	<table border="1" cellpadding="5" cellspacing="0">
		<tr>
			<th>SQL</th>
			<th>Time (ms)</th>
			<th>Error</th>
		</tr>
		<cfloop array="#results#" index="result">
			<tr>
				<td>
					<pre>#encodeForHTML( result.sql )#</pre>
				</td>
				<td>#result.time# ms</td>
				<td>#encodeForHTML( result.error )#</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>