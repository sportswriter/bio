<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!--  Shift dynamicProperties and measurementType so they become narrower terms of their parent terms  -->
    
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>
    
    <!--  Copy the dynamicProperties terms below the dynamicProperties term, within Record-level terms  -->
    <xsl:template match="term[contains(@name,'dynamicProperties')]/example">
        <xsl:variable name="dyno" select="/doc/section[@name='dynamicProperties']"></xsl:variable>
        <xsl:for-each select="$dyno">
            <xsl:copy-of select="./*"></xsl:copy-of>
        </xsl:for-each>
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
   
    <xsl:template match="term[contains(@name,'measurementType')]/example">
        <xsl:variable name="measure" select="/doc/section[@name='measurementType']"></xsl:variable>
        <xsl:for-each select="$measure">
            <xsl:copy-of select="./*"></xsl:copy-of>
        </xsl:for-each>
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!--  Don't copy the dynamicProperties or measurementType section  -->
    <xsl:template match="section[@name='dynamicProperties']"></xsl:template>
    <xsl:template match="section[@name='measurementType']"></xsl:template>
    
    
</xsl:stylesheet>