<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output   method="xml" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" 
   doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="yes"/>
	<xsl:strip-space elements="*"/>

	<xsl:template match="/">
		<xsl:element name="graphml" namespace="http://graphml.graphdrawing.org/xmlns">
			<xsl:apply-templates/> 
		</xsl:element>
	</xsl:template>

	<xsl:template match="ltfsindex">
		<xsl:element name="graph">
			<xsl:text>&#10;</xsl:text>
			<xsl:element name="key">
				<xsl:attribute name="id" >
					<xsl:text>f</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="for" >
					<xsl:text>node</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="attr.name" >
					<xsl:text>file</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="attr.type" >
					<xsl:text>string</xsl:text>
				</xsl:attribute>
			</xsl:element>
			<xsl:text>&#10;</xsl:text>
			<xsl:element name="key">
				<xsl:attribute name="id" >
					<xsl:text>d</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="for" >
					<xsl:text>node</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="attr.name" >
					<xsl:text>directory</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="attr.type" >
					<xsl:text>string</xsl:text>
				</xsl:attribute>
			</xsl:element>
			<xsl:text>&#10;</xsl:text>
			<xsl:element name="key">
				<xsl:attribute name="id" >
					<xsl:text>ct</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="for" >
					<xsl:text>node</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="attr.name" >
					<xsl:text>creationtime</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="attr.type" >
					<xsl:text>string</xsl:text>
				</xsl:attribute>
			</xsl:element>
			<xsl:text>&#10;</xsl:text>
			<xsl:element name="key">
				<xsl:attribute name="id" >
					<xsl:text>l</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="for" >
					<xsl:text>node</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="attr.name" >
					<xsl:text>length</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="attr.type" >
					<xsl:text>string</xsl:text>
				</xsl:attribute>
			</xsl:element>
			<xsl:text>&#10;</xsl:text>
			<xsl:element name="key">
				<xsl:attribute name="id" >
					<xsl:text>e1</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="for" >
					<xsl:text>edge</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="attr.name" >
					<xsl:text>contains</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="attr.type" >
					<xsl:text>string</xsl:text>
				</xsl:attribute>
				<xsl:text>&#10;</xsl:text>
			</xsl:element>
			<xsl:text>&#10;</xsl:text>
			<node id="n0">
				<xsl:text>&#10;</xsl:text>
				<data key="labels">:root</data>
				<xsl:text>&#10;</xsl:text>
				<data key="d">LTFS</data>
				<xsl:text>&#10;</xsl:text>
			</node>
			<xsl:apply-templates/>
			<xsl:text>&#10;</xsl:text>
		</xsl:element>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>
	<!--
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/> 
		</xsl:copy>
	</xsl:template>

	<xsl:template match="file | contents | directory | length | creationtime | name">
		<xsl:apply-templates select="@*|node()"/> 
	</xsl:template>
	<xsl:template match="fileuid "/>
	-->
	<!-- 
    <xsl:variable name="text">
      <xsl:apply-templates select="text()"/
    </xsl:variable>
<xsl:attribute name="id">
        <xsl:value-of select="concat('n',normalize-space($text))"/>
      </xsl:attribute>
    -->

	<xsl:template match="file | directory">
		<xsl:text>&#10;</xsl:text>
		<node>
			<xsl:attribute name="id">
				<xsl:value-of select="concat('n',normalize-space(./fileuid/text()))"/>
			</xsl:attribute>
			<xsl:text>&#10;</xsl:text>
			<data>
				<xsl:attribute name="key">
					<xsl:value-of select="'labels'"/>
				</xsl:attribute>
				<xsl:value-of select="concat(':',name())"/>

			</data>
			<xsl:text>&#10;</xsl:text>
			<data>
				<xsl:attribute name="key">
					<xsl:if test="../file">
						<xsl:value-of select="'f'"/>
					</xsl:if>
					<xsl:if test="../directory">
						<xsl:value-of select="'d'"/>
					</xsl:if>

				</xsl:attribute>
				<xsl:value-of select="./name[text()]"/>

			</data>
			<xsl:text>&#10;</xsl:text>
			<data>
				<xsl:attribute name="key">
					<xsl:if test="creationtime">
						<xsl:value-of select="'ct'"/>
					</xsl:if>
				</xsl:attribute>
				<xsl:value-of select="./creationtime[text()]"/>

			</data>

			<xsl:if test="../file">
				<data>
					<xsl:attribute name="key">
						<xsl:if test="length">
							<xsl:value-of select="'l'"/>
						</xsl:if>
					</xsl:attribute>
					<xsl:value-of select="./length[text()]"/>

				</data>
			</xsl:if>
			<xsl:text>&#10;</xsl:text>
		</node>
		<xsl:text>&#10;</xsl:text>
		<edge>
			<xsl:attribute name="source">
				<xsl:if test="./../../fileuid/text()">
					<xsl:value-of select="concat('n',normalize-space(./../../fileuid/text()))"/>
				</xsl:if>
				<xsl:if test="not(./../../fileuid/text())">
					<xsl:value-of select="'n0'"/>
				</xsl:if>
			</xsl:attribute> 
			<xsl:attribute name="target">
				<xsl:value-of select="concat('n',normalize-space(./fileuid/text()))"/>
			</xsl:attribute>
			<xsl:text>&#10;</xsl:text>
			<data>
				<xsl:attribute name="key">

					<xsl:value-of select="'el'"/>

				</xsl:attribute>
				<xsl:value-of select="'contains'"/>
			</data>
			<xsl:text>&#10;</xsl:text>
		</edge>
		<xsl:apply-templates select="@*|*"/>
	</xsl:template>

	<xsl:template match="*[name='Sony'] | *[name='Edit']  | *[name='Sub']  | *[name='Take']  | *[name='UserData']  | *[name='General'] "/> 
	<xsl:template match="*[name='MEDIAPRO.XML'] | *[name='CUEUP.XML']  | *[name='DISCMETA.XML'] | *[name='General'] "/> 
	<xsl:template match="creator| backuptime | changetime | modifytime | generationnumber | accesstime | readonly | extent | fileoffset"/>
	<xsl:template match="partition | byteoffset | startblock | extentinfo | previousgenerationlocation | location | allowpolicyupdate"/>
	<xsl:template match="volumeuuid | updatetime | highestfileuid | creationtime | name | length | fileuid"/>
	<!-- | length | creationtime -->

</xsl:stylesheet>