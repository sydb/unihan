<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns="http://www.tei-c.org/ns/1.0"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="#all"
  version="3.0">

  <!--
    ** gaiji_char_encoding_updater.xslt
    **
    ** Written 2021-05-08 by Syd Bauman for the TEI Consortium
    ** with the help of Duncan Paterson.
    ** Available under the terms of CC BY-SA 4.0.
    **
    ** Read in a TEI P5 document that uses the version 3.6.0 or earlier
    ** method of encoding gaiji and write out the same document that
    ** instead uses the version 4.0.0 or later method of encoding gaiji.
    **
    ** Note: This routine does NOT change <charProp> elements that are
    ** in the TEI Examples namespace.
  -->

  <xsl:variable name="myName" select="'gaiji_char_encoding_updater.xslt'" as="xs:string"/>
  <xsl:variable name="myVersion" select="'0.1.0'" as="xs:string"/>
  <xsl:mode on-no-match="shallow-copy"/>
    
  <!--
    Insert <application>, case 0: no <encodingDesc>
    Kinda a nonsensical case, as if there is no <encodingDesc>,
    where is the <charDecl> we are supposed to be working on?
  -->
  <xsl:template match="teiHeader[not(encodingDesc)]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node() except ( revisionDesc | node()[. >> ../revisionDesc] )"/>
      <encodingDesc>
        <appInfo>
          <xsl:call-template name="application"/>
        </appInfo>
      </encodingDesc>
      <xsl:apply-templates select="revisionDesc"/>
      <xsl:apply-templates select="node()[. >> ../revisionDesc]"/>
    </xsl:copy>
  </xsl:template>
  
  <!--
    Insert <application>, case 1: no <appInfo>
  -->
  <xsl:template match="encodingDesc[not(appInfo)]">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
      <appInfo>
        <xsl:call-template name="application"/>
      </appInfo>
    </xsl:copy>
  </xsl:template>
  
  <!--
    Insert <application>, case 2: yes <appInfo>
  -->
  <xsl:template match="appInfo">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
      <xsl:call-template name="application"/>
    </xsl:copy>
  </xsl:template>

  <!--
    Actually do the work: convert <charProp> to either <unicodeProp>,
    <unihanProp>, or <localProp>
  -->
  <xsl:template match="charProp">
    <xsl:variable name="gi" as="xs:string">
      <xsl:choose>
        <xsl:when test="true()">unicodeProp</xsl:when>
        <xsl:when test="true()">unihanProp</xsl:when>
        <xsl:when test="localName">localProp</xsl:when>
        <xsl:otherwise>ERROR</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$gi}">
      <xsl:attribute name="name" select="normalize-space(localName|unicodeName)"/>
      <xsl:attribute name="value" select="normalize-space(value)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template name="application">
    <application ident="{$myName}" version="{$myVersion}" when="{current-dateTime()}">
      <desc>TEI Consortium routine for converting a P5 v. 3.6.0 or earlier
        <gi>charProp</gi> to a version 4.0.0 or later <gi>unicodeProp</gi>,
        <gi>unihanProp</gi>, or <gi>localProp</gi>.</desc>
    </application>
  </xsl:template>

</xsl:stylesheet>
