<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="yes"/>
	<xsl:strip-space elements="*"/>

	<xsl:template match="/">
<!-- 		<xsl:text>CREATE CONSTRAINT ON (d:directory) ASSERT d.id IS UNIQUE</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>CREATE CONSTRAINT ON (f:file) ASSERT f.id IS UNIQUE</xsl:text>
		<xsl:text>&#10;</xsl:text>
 -->		
 <xsl:apply-templates/> 
	</xsl:template>

	<xsl:template match="file | directory">
		<xsl:text>MERGE (a</xsl:text>
		<xsl:value-of select="concat('n',normalize-space(./fileuid/text()))"/>
		<xsl:text>:</xsl:text>
 <!-- 				<xsl:value-of select="concat('n',normalize-space(./fileuid/text()))"/>
				 <xsl:value-of select="concat('n',translate(translate(translate(./creationtime[text()],':','_'),'.','_'),'-','_'))"/>			
 -->
		<xsl:choose>
			<xsl:when test="not(../../name[text()])">
				<xsl:if test="../../file">
					<xsl:text>) {file:</xsl:text> 
					<xsl:value-of select="../../name"/>
				</xsl:if>
					<xsl:text>directory {directory:"LTFS", id:"n000"})</xsl:text> 
			</xsl:when>
			<xsl:otherwise>		
			
				<xsl:text>directory {directory:"</xsl:text> 
				<xsl:value-of select="../../name"/>
				<xsl:text>", id:"</xsl:text> 
				<xsl:value-of select="/ltfsindex/directory/name"/>				
				<xsl:value-of select="concat('n',normalize-space(./../../fileuid/text()))"/>
				<xsl:text>"})</xsl:text>
		<!-- <xsl:value-of select="concat('n',translate(translate(translate(./../../creationtime[text()],':','_'),'.','_'),'-','_'))"/> -->

			</xsl:otherwise>	
		</xsl:choose>
		<!-- <xsl:value-of select="concat('n',normalize-space(./../../fileuid/text()))"/> -->
		<xsl:text disable-output-escaping="yes"> MERGE (b</xsl:text> 
		<xsl:value-of select="concat('n',normalize-space(./fileuid/text()))"/>
		<xsl:text>:</xsl:text>
		<xsl:value-of select="name()"/>
		<xsl:text> {</xsl:text>
		<xsl:value-of select="name()"/>
		<xsl:text>:</xsl:text>
		
		<xsl:choose>
			<xsl:when test="not(../../name[text()])">
				<xsl:text>"</xsl:text>
				<xsl:value-of select="./name[text()]"/>
				<xsl:text>", creationtime:"</xsl:text>
				<xsl:value-of select="./creationtime[text()]"/>
				<xsl:text>", modifytime:"</xsl:text>
				<xsl:value-of select="./modifytime[text()]"/>					
				<xsl:text>", type:"LTFStape", id:"</xsl:text>
				<xsl:value-of select="/ltfsindex/directory/name"/>				
				<xsl:value-of select="concat('n',normalize-space(./fileuid/text()))"/>
				<xsl:text>"})</xsl:text>
			</xsl:when>	
			
			<xsl:when test="name()='file'">
				<xsl:text>"</xsl:text>
				<xsl:value-of select="./name[text()]"/>
				<xsl:text>", size:TOINT(</xsl:text>
				<xsl:value-of select="./length[text()]"/>
				<xsl:text>), id:"</xsl:text> 
				<xsl:value-of select="/ltfsindex/directory/name"/>
				<xsl:value-of select="concat('n',normalize-space(./fileuid/text()))"/>
				<xsl:text>"})</xsl:text>
			</xsl:when>
			
			<xsl:when test="name()='directory'">
				<xsl:text>"</xsl:text>
				<xsl:value-of select="./name[text()]"/>
				<xsl:text>", id:"</xsl:text> 
				<xsl:value-of select="/ltfsindex/directory/name"/>				
				<xsl:value-of select="concat('n',normalize-space(./fileuid/text()))"/>
				<xsl:text>"})</xsl:text>
			</xsl:when>	
			
			<xsl:otherwise>	
			</xsl:otherwise>	
		</xsl:choose>
		<!-- <xsl:value-of select="concat('n',translate(translate(translate(./creationtime[text()],':','_'),'.','_'),'-','_'))"/>			 -->
		<xsl:text disable-output-escaping="yes"> MERGE (a</xsl:text>
				<xsl:value-of select="concat('n',normalize-space(./fileuid/text()))"/>
		<xsl:text disable-output-escaping="yes"> )-[:CONTAINS]->(b</xsl:text>
				<xsl:value-of select="concat('n',normalize-space(./fileuid/text()))"/>
		<xsl:text disable-output-escaping="yes">)</xsl:text>
		
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates select="@*|*"/>
	</xsl:template>

	<xsl:template match="*[name='Sony'] | *[name='Edit']  | *[name='Sub']  | *[name='Take']  | *[name='UserData']  | *[name='General'] "/> 
	<xsl:template match="*[name='MEDIAPRO.XML'] | *[name='CUEUP.XML']  | *[name='DISCMETA.XML'] | *[name='General'] "/> 
	<xsl:template match="creator| backuptime | changetime | modifytime | generationnumber | accesstime | readonly | extent | fileoffset"/>
	<xsl:template match="partition | byteoffset | startblock | extentinfo | previousgenerationlocation | location | allowpolicyupdate"/>
	<xsl:template match="volumeuuid | updatetime | highestfileuid | creationtime | name | length | fileuid"/>
	<!-- | length | creationtime -->

</xsl:stylesheet>