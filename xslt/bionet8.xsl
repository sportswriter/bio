<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">    
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!--  Removes leading and trailing unicode 160 space characters  -->
    
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="term/@name">
        <xsl:attribute name="name">
            <xsl:call-template name="topTailUnicode160">
                <xsl:with-param name="input" select="."></xsl:with-param>
            </xsl:call-template>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="example">
        <example>
            <xsl:call-template name="topTailUnicode160">
                <xsl:with-param name="input" select="."></xsl:with-param>
            </xsl:call-template>
        </example>
    </xsl:template>
    
    <xsl:template match="definition">
        <definition>
            <xsl:call-template name="topTailUnicode160">
                <xsl:with-param name="input" select="."></xsl:with-param>
            </xsl:call-template>
        </definition>
    </xsl:template>
    
    <xsl:template match="intro">
        <intro>
            <xsl:call-template name="topTailUnicode160">
                <xsl:with-param name="input" select="."></xsl:with-param>
            </xsl:call-template>
        </intro>
    </xsl:template>
   
    <!-- Remove leading & trailing spaces - unicode 160   -->
    <xsl:template name="topTailUnicode160">
        <xsl:param name="input"/>
        <xsl:value-of select="replace(.,'^(&#160;+)|(&#160;+)$','')"/>
    </xsl:template>
    
    
</xsl:stylesheet>