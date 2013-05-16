<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dri="http://di.tamu.edu/DRI/1.0/">

<xsl:template match="*">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<xsl:apply-templates/>
	</xsl:copy>
</xsl:template>

<xsl:template match="dri:pageMeta">
	<xsl:copy>
		<xsl:copy-of select="@*"/>
		<dri:trail target="http://elibrary.unm.edu/">Library Home</dri:trail>
		<xsl:apply-templates/>
	</xsl:copy>
</xsl:template>

</xsl:stylesheet>
