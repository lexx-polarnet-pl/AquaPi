<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <!-- <xsl:import href="/usr/share/xml/docbook/stylesheet/nwalsh/xhtml/docbook.xsl"/> -->
   <xsl:import href="/usr/share/xml/docbook/stylesheet/nwalsh/xhtml/chunk.xsl"/> 
   <xsl:param name="toc.max.depth">2</xsl:param>
   <xsl:param name="section.autolabel" select="1"></xsl:param>
   <xsl:param name="section.label.includes.component.label" select="1"></xsl:param>
   
   <xsl:param name="html.stylesheet" select="'static/aquapi.css'"/>
   <xsl:param name="admon.graphics.extension">.png</xsl:param>
   <xsl:param name="admon.graphics.path">static/</xsl:param>
   <xsl:param name="admon.graphics" select="1"></xsl:param>
   <!-- <xsl:param name="admon.style">
     <xsl:value-of select="concat('margin-', $direction.align.start,            ': 0.5in; margin-', $direction.align.end, ': 0.5in;')"></xsl:value-of>
   </xsl:param> -->
   <xsl:param name="use.id.as.filename" select="1"></xsl:param>
   <!-- <xsl:template name="user.header.content">
     <a href="/">Back to main page</a> 
   </xsl:template> -->
</xsl:stylesheet>
