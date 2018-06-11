<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="yes"/>
<xsl:strip-space elements="*"/>

	<xsl:template match="/">
		<xsl:text>id,directory</xsl:text>
		<xsl:text>&#10;</xsl:text> 
		<xsl:apply-templates/> 
	</xsl:template>

	<xsl:template match="directory">
		<xsl:value-of select="/ltfsindex/directory/name"/>				
		<xsl:value-of select="concat('n',normalize-space(./fileuid/text()))"/>
		<xsl:text>,</xsl:text> 
		<xsl:value-of select="./name"/>
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