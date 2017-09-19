<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="yes"/>
<xsl:strip-space elements="*"/>

	<xsl:template match="/">
		<xsl:text>ida,idb</xsl:text>
		<xsl:text>&#10;</xsl:text> 
		<xsl:apply-templates/> 
	</xsl:template>

	<xsl:template match="file|directory">
	<xsl:choose>
		<xsl:when test="not(../../name[text()])">
			<xsl:text>n000</xsl:text>
			<xsl:text>,</xsl:text> 
			<xsl:value-of select="/ltfsindex/directory/name"/>				
			<xsl:value-of select="concat('n',normalize-space(./fileuid/text()))"/>
		</xsl:when>
		<xsl:otherwise>		
			<xsl:value-of select="/ltfsindex/directory/name"/>				
			<xsl:value-of select="concat('n',normalize-space(./../../fileuid/text()))"/>
			<xsl:text>,</xsl:text> 
			<xsl:value-of select="/ltfsindex/directory/name"/>				
			<xsl:value-of select="concat('n',normalize-space(./fileuid/text()))"/>
		</xsl:otherwise>	
	</xsl:choose>				
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