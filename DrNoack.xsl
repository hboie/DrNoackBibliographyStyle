<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:b="http://schemas.openxmlformats.org/officeDocument/2006/bibliography" xmlns:t="http://www.microsoft.com/temp">
	<xsl:output method="html" encoding="us-ascii"/>
	
	
	
	<xsl:template match="*" mode="outputHtml2">
			<xsl:apply-templates mode="outputHtml"/>		
	</xsl:template>

	<xsl:template name="StringFormatDot">
		<xsl:param name="format" />
		<xsl:param name="parameters" />

    <xsl:variable name="prop_EndChars">
      <xsl:call-template name="templ_prop_EndChars"/>
    </xsl:variable>

    <xsl:choose>
			<xsl:when test="$format = ''"></xsl:when>
			<xsl:when test="substring($format, 1, 2) = '%%'">
				<xsl:text>%</xsl:text>
				<xsl:call-template name="StringFormatDot">
					<xsl:with-param name="format" select="substring($format, 3)" />
					<xsl:with-param name="parameters" select="$parameters" />
				</xsl:call-template>
				<xsl:if test="string-length($format)=2">
					<xsl:call-template name="templ_prop_Dot"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="substring($format, 1, 1) = '%'">
				<xsl:variable name="pos" select="substring($format, 2, 1)" />
				<xsl:apply-templates select="msxsl:node-set($parameters)/t:params/t:param[position() = $pos]" mode="outputHtml2"/>
				<xsl:call-template name="StringFormatDot">
					<xsl:with-param name="format" select="substring($format, 3)" />
					<xsl:with-param name="parameters" select="$parameters" />
				</xsl:call-template>
				<xsl:if test="string-length($format)=2">
					<xsl:variable name="temp2">
						<xsl:call-template name="handleSpaces">
							<xsl:with-param name="field" select="msxsl:node-set($parameters)/t:params/t:param[position() = $pos]"/>
						</xsl:call-template>
					</xsl:variable>				
					<xsl:variable name="lastChar">
						<xsl:value-of select="substring($temp2, string-length($temp2))"/>
					</xsl:variable>
					<xsl:if test="not(contains($prop_EndChars, $lastChar))">
						<xsl:call-template name="templ_prop_Dot"/>
					</xsl:if>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring($format, 1, 1)" />
				<xsl:call-template name="StringFormatDot">
					<xsl:with-param name="format" select="substring($format, 2)" />
					<xsl:with-param name="parameters" select="$parameters" />
				</xsl:call-template>
				<xsl:if test="string-length($format)=1">
					<xsl:if test="not(contains($prop_EndChars, $format))">
						<xsl:call-template name="templ_prop_Dot"/>
					</xsl:if>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	

	<xsl:template name="StringFormat">
		<xsl:param name="format" />
		<xsl:param name="parameters" />
		<xsl:choose>
			<xsl:when test="$format = ''"></xsl:when>
			<xsl:when test="substring($format, 1, 2) = '%%'">
				<xsl:text>%</xsl:text>
				<xsl:call-template name="StringFormat">
					<xsl:with-param name="format" select="substring($format, 3)" />
					<xsl:with-param name="parameters" select="$parameters" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="substring($format, 1, 1) = '%'">
				<xsl:variable name="pos" select="substring($format, 2, 1)" />
				<xsl:apply-templates select="msxsl:node-set($parameters)/t:params/t:param[position() = $pos]" mode="outputHtml2"/>
				<xsl:call-template name="StringFormat">
					<xsl:with-param name="format" select="substring($format, 3)" />
					<xsl:with-param name="parameters" select="$parameters" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring($format, 1, 1)" />
				<xsl:call-template name="StringFormat">
					<xsl:with-param name="format" select="substring($format, 2)" />
					<xsl:with-param name="parameters" select="$parameters" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	


	




  <xsl:template name="localLCID">
    <xsl:param name="LCID"/>

    <xsl:variable name="_LCID1">
      <xsl:choose>
        <xsl:when test="$LCID!='0' and $LCID!=''">
          <xsl:value-of select="$LCID"/>
        </xsl:when>
        <xsl:when test="/b:Citation">
          <xsl:value-of select="/*/b:Locals/b:DefaultLCID"/>
        </xsl:when>
        <xsl:when test="b:LCID">
          <xsl:value-of select="b:LCID"/>
        </xsl:when>
        <xsl:when test="../b:LCID">
          <xsl:value-of select="../b:LCID"/>
        </xsl:when>
        <xsl:when test="../../b:LCID">
          <xsl:value-of select="../../b:LCID"/>
        </xsl:when>
        <xsl:when test="../../../b:LCID">
          <xsl:value-of select="../../../b:LCID"/>
        </xsl:when>
        <xsl:when test="../../../../b:LCID">
          <xsl:value-of select="../../../../b:LCID"/>
        </xsl:when>
        <xsl:when test="../../../../b:LCID">
          <xsl:value-of select="../../../../b:LCID"/>
        </xsl:when>
        <xsl:when test="../../../../../b:LCID">
          <xsl:value-of select="../../../../../b:LCID"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/*/b:Locals/b:DefaultLCID"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$_LCID1!='0' and string-length($_LCID1)>0">
        <xsl:value-of select="$_LCID1"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="/*/b:Locals/b:DefaultLCID"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  
  <xsl:template name="templ_prop_NoItalics" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:NoItalics"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_TitleOpen" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:TitleOpen"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_TitleClose" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:TitleClose"/>
  </xsl:template>  

  
  <xsl:template name="templ_prop_MLA_CitationLong_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:CitationLong/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_CitationLong_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:CitationLong/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_CitationLong_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:CitationLong/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_CitationLong_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:CitationLong/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_CitationShort_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:CitationShort/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_CitationShort_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:CitationShort/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_CitationShort_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:CitationShort/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_CitationShort_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:CitationShort/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_CitationLong_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:CitationLong/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_CitationLong_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:CitationLong/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_CitationLong_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:CitationLong/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_CitationLong_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:CitationLong/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_CitationShort_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:CitationShort/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_CitationShort_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:CitationShort/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_CitationShort_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:CitationShort/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_CitationShort_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:CitationShort/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_CitationLong_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:CitationLong/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_CitationLong_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:CitationLong/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_CitationLong_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:CitationLong/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_CitationLong_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:CitationLong/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_CitationShort_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:CitationShort/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_CitationShort_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:CitationShort/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_CitationShort_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:CitationShort/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_CitationShort_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:CitationShort/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Gost_CitationLong_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:CitationLong/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Gost_CitationLong_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:CitationLong/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Gost_CitationLong_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:CitationLong/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Gost_CitationLong_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:CitationLong/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Gost_CitationShort_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:CitationShort/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Gost_CitationShort_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:CitationShort/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Gost_CitationShort_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:CitationShort/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Gost_CitationShort_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:CitationShort/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_CitationLong_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:CitationLong/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_CitationLong_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:CitationLong/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_CitationLong_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:CitationLong/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_CitationLong_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:CitationLong/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_CitationShort_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:CitationShort/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_CitationShort_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:CitationShort/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_CitationShort_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:CitationShort/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_CitationShort_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:CitationShort/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ChapterInCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ChapterInCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ChapterCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ChapterCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ChapterInUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ChapterInUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ChapterUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ChapterUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_InterviewByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:InterviewByUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ByUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_InNameUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:InNameUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_AccessedCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:AccessedCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_AccessedUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:AccessedUnCap"/>
  </xsl:template>

  <xsl:template name="templ_str_VolumesAfterShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:VolumesAfterShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_OnlineCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:OnlineCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_OnlineUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:OnlineUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_InCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:InCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_InNameCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
  </xsl:template>

  
  <xsl:template name="templ_str_WithUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:WithUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_VersionShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:VersionShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_InterviewCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:InterviewCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_InterviewWithCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:InterviewWithCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_InterviewByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:InterviewByCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ByCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_AndUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:AndUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_AndOthersUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:AndOthersUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_MotionPictureCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:MotionPictureCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_PatentCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PatentCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_EditionShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:EditionShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_RetrievedFromCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:RetrievedFromCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_RetrievedCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:RetrievedCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_FromCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:FromCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_FromUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:FromUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_NoDateShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:NoDateShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_NumberShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:NumberShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_NumberShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:NumberShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_PatentNumberShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PatentNumberShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_PagesCountinousShort" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PagesCountinousShort"/>
  </xsl:template>

  
  <xsl:template name="templ_str_PageShort" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PageShort"/>
  </xsl:template>

  
  <xsl:template name="templ_str_SineNomineShort" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:SineNomineShort"/>
  </xsl:template>

  
  <xsl:template name="templ_str_SineLocoShort" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:SineLocoShort"/>
  </xsl:template>

  
  <xsl:template name="templ_str_SineLocoSineNomineShort" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:SineLocoSineNomineShort"/>
  </xsl:template>

  
  <xsl:template name="templ_str_VolumeOfShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:VolumeOfShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_VolumesOfShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:VolumesOfShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_VolumeShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:VolumeShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_VolumeShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:VolumeShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_VolumesShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:VolumesShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_VolumesShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:VolumesShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_AuthorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:AuthorShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_BookAuthorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:BookAuthorShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ArtistShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ArtistShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_WriterCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:WriterCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_WritersCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:WritersCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_WriterShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:WriterShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ConductedByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ConductedByCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ConductedByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ConductedByUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ConductorCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ConductorCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ConductorsCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ConductorsCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ConductorShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ConductorShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ConductorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ConductorShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ConductorsShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ConductorsShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ConductorsShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ConductorsShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_CounselShortUnCapIso" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CounselShortUnCapIso"/>
  </xsl:template>

  
  <xsl:template name="templ_str_CounselShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CounselShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_DirectedByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:DirectedByCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_DirectedByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:DirectedByUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_DirectorCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:DirectorCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_DirectorsCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:DirectorsCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_DirectorShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:DirectorShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_DirectorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:DirectorShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_DirectorsShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:DirectorsShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_DirectorsShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:DirectorsShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_EditedByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:EditedByCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_EditedByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:EditedByUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_EditorCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:EditorCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_EditorsCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:EditorsCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_EditorShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:EditorShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_EditorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:EditorShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_EditorsShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:EditorsShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_EditorsShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:EditorsShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_IntervieweeShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:IntervieweeShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_InterviewerCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:InterviewerCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_InterviewersCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:InterviewersCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_InventorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:InventorShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_PerformedByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PerformedByCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_PerformedByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PerformedByUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_PerformerCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PerformerCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_PerformersCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PerformersCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_PerformerShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PerformerShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_PerformerShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PerformerShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_PerformersShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PerformersShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_PerformersShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:PerformersShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ProducedByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ProducedByCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ProducedByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ProducedByUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ProducerCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ProducerCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ProducersCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ProducersCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ProductionCompanyShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ProductionCompanyShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ProducerShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ProducerShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ProducersShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ProducersShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ProducerShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ProducerShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_TranslatedByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:TranslatedByCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_TranslatedByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:TranslatedByUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_TranslatorCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:TranslatorCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_TranslatorsCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:TranslatorsCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_TranslatorShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:TranslatorShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_TranslatorShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:TranslatorShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_TranslatorsShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:TranslatorsShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_TranslatorsShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:TranslatorsShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ComposerCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ComposerCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ComposersCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ComposersCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ComposerShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ComposerShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ComposersShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ComposersShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_ComposerShortUnCapIso" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:ComposerShortUnCapIso"/>
  </xsl:template>

  
  <xsl:template name="templ_str_CompiledByCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CompiledByCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_CompiledByUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CompiledByUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_CompilerCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CompilerCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_CompilersCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CompilersCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_CompilerShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CompilerShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_CompilerShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CompilerShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_CompilersShortCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CompilersShortCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_CompilersShortUnCap" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CompilersShortUnCap"/>
  </xsl:template>

  
  <xsl:template name="templ_str_CompilerShortUnCapIso" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Strings/b:CompilerShortUnCapIso"/>
  </xsl:template>


  

  
  <xsl:template name="templ_prop_Culture" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/@Culture"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Direction" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Properties/b:Direction"/>
  </xsl:template>


  

  
  <xsl:template name="templ_prop_EndChars" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:EndChars"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_NormalizeSpace" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>no</xsl:text>
    
  </xsl:template>

  
  <xsl:template name="templ_prop_Space" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:Space"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_NonBreakingSpace" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:NonBreakingSpace"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ListSeparator" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:ListSeparator"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Dot" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:Dot"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_DotInitial" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:DotInitial"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_GroupSeparator" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:GroupSeparator"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_EnumSeparator" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:EnumSeparator"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Equal" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:Equal"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Enum" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:Enum"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_OpenQuote" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:OpenQuote"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_CloseQuote" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:CloseQuote"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_OpenBracket" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:OpenBracket"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_CloseBracket" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:CloseBracket"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_FromToDash" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:FromToDash"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_OpenLink" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:OpenLink"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_CloseLink" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:CloseLink"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_AuthorsSeparator" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:AuthorsSeparator"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_NoAndBeforeLastAuthor" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:NoAndBeforeLastAuthor"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_SimpleAuthor_F" >
  <xsl:text>%F</xsl:text>
  
  </xsl:template>

  
  <xsl:template name="templ_prop_SimpleAuthor_M" >
  <xsl:text>%M</xsl:text>
  
  </xsl:template>

  
  <xsl:template name="templ_prop_SimpleAuthor_L" >
  <xsl:text>%L</xsl:text>
  
  </xsl:template>

  
  <xsl:template name="templ_prop_SimpleDate_D" >
  <xsl:text>%D</xsl:text>
  
  </xsl:template>

  
  <xsl:template name="templ_prop_SimpleDate_M" >
  <xsl:text>%M</xsl:text>
  
  </xsl:template>

  
  <xsl:template name="templ_prop_SimpleDate_Y" >
  <xsl:text>%Y</xsl:text>
  
  </xsl:template>


    <xsl:template name="templ_prop_SimpleDate_DMY" >
  <xsl:text>%D.%M.%Y</xsl:text>
  
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_SameAuthor" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:SameAuthor"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_MainAuthor_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:MainAuthor/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_MainAuthor_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:MainAuthor/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_MainAuthor_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:MainAuthor/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_MainAuthor_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:MainAuthor/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_OtherAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:OtherAuthors/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_OtherAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:OtherAuthors/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_OtherAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:OtherAuthors/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_OtherAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:OtherAuthors/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_SecondaryAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:SecondaryAuthors/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_SecondaryAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:SecondaryAuthors/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_SecondaryAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:SecondaryAuthors/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_SecondaryAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:SecondaryAuthors/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_Date_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:Date/b:DMY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_Date_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:Date/b:DM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_Date_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:Date/b:MY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_MLA_Date_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:MLA/b:Date/b:DY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_MainAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:MainAuthors/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_MainAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:MainAuthors/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_MainAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:MainAuthors/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_MainAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:MainAuthors/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_SecondaryAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:SecondaryAuthors/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_SecondaryAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:SecondaryAuthors/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_SecondaryAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:SecondaryAuthors/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_SecondaryAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:SecondaryAuthors/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_BeforeLastAuthor" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:BeforeLastAuthor"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_GeneralOpen" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:GeneralOpen"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_GeneralClose" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:GeneralClose"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_SecondaryOpen" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:SecondaryOpen"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_SecondaryClose" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:SecondaryClose"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Hyphens" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:Hyphens"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_Date_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:Date/b:DMY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_Date_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:Date/b:DM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_Date_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:Date/b:MY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_Date_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:Date/b:DY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_DateAccessed_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:DateAccessed/b:DMY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_DateAccessed_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:DateAccessed/b:DM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_DateAccessed_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:DateAccessed/b:MY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_DateAccessed_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:DateAccessed/b:DY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_DateCourt_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:DateCourt/b:DMY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_DateCourt_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:DateCourt/b:DM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_DateCourt_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:DateCourt/b:MY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_APA_DateCourt_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:APA/b:DateCourt/b:DY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_SameAuthor" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:SameAuthor"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_MainAuthor_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:MainAuthor/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_MainAuthor_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:MainAuthor/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_MainAuthor_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:MainAuthor/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_MainAuthor_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:MainAuthor/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_OtherAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:OtherAuthors/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_OtherAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:OtherAuthors/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_OtherAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:OtherAuthors/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_OtherAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:OtherAuthors/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_SecondaryAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:SecondaryAuthors/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_SecondaryAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:SecondaryAuthors/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_SecondaryAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:SecondaryAuthors/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_SecondaryAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:SecondaryAuthors/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_Date_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:Date/b:DMY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_Date_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:Date/b:DM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_Date_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:Date/b:MY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Chicago_Date_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Chicago/b:Date/b:DY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_MainAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:MainAuthors/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_MainAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:MainAuthors/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_MainAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:MainAuthors/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_MainAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:MainAuthors/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_SecondaryAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:SecondaryAuthors/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_SecondaryAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:SecondaryAuthors/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_SecondaryAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:SecondaryAuthors/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_SecondaryAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:SecondaryAuthors/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_SameAuthor" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:SameAuthor"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_GeneralOpen" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:GeneralOpen"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_GeneralClose" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:GeneralClose"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_Date_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:Date/b:DMY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_Date_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:Date/b:DM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_Date_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:Date/b:MY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_Date_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:Date/b:DY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_DateAccessed_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:DateAccessed/b:DMY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_DateAccessed_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:DateAccessed/b:DM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_DateAccessed_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:DateAccessed/b:MY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_ISO690_DateAccessed_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:ISO690/b:DateAccessed/b:DY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Gost_Authors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:Authors/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Gost_Authors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:Authors/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Gost_Authors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:Authors/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Gost_Authors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:Authors/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Gost_Date_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:Date/b:DMY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Gost_Date_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:Date/b:DM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Gost_Date_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:Date/b:MY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Gost_Date_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:Date/b:DY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Gost_GeneralOpen" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:GeneralOpen"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Gost_GeneralClose" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:GeneralClose"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Gost_OneSlash" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:OneSlash"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_Gost_TwoSlash" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:Gost/b:TwoSlash"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_SIST_MainAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:MainAuthors/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_SIST_MainAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:MainAuthors/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_SIST_MainAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:MainAuthors/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_SIST_MainAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:MainAuthors/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_SIST_SecondaryAuthors_FML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:SecondaryAuthors/b:FML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_SIST_SecondaryAuthors_FM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:SecondaryAuthors/b:FM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_SIST_SecondaryAuthors_ML" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:SecondaryAuthors/b:ML"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_SIST_SecondaryAuthors_FL" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:SecondaryAuthors/b:FL"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_SIST_SameAuthor" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:SameAuthor"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_SIST_GeneralOpen" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:GeneralOpen"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_SIST_GeneralClose" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:GeneralClose"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_SIST_Date_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:Date/b:DMY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_SIST_Date_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:Date/b:DM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_SIST_Date_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:Date/b:MY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_SIST_Date_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:Date/b:DY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_SIST_DateAccessed_DMY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:DateAccessed/b:DMY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_SIST_DateAccessed_DM" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:DateAccessed/b:DM"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_SIST_DateAccessed_MY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:DateAccessed/b:MY"/>
  </xsl:template>

  
  <xsl:template name="templ_prop_SIST_DateAccessed_DY" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:SIST/b:DateAccessed/b:DY"/>
  </xsl:template>

  <xsl:template name="templ_prop_NoCommaBeforeAnd" >
    <xsl:param name="LCID" />
    <xsl:variable name="_LCID">
      <xsl:call-template name="localLCID">
        <xsl:with-param name="LCID" select="$LCID"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="/*/b:Locals/b:Local[@LCID=$_LCID]/b:General/b:NoCommaBeforeAnd"/>
  </xsl:template>

  <xsl:template match="/">

		<xsl:choose>
			<xsl:when test="b:Version">
				<xsl:text>2023.05.25</xsl:text>
			</xsl:when>


			<xsl:when test="b:XslVersion">
				<xsl:text>3</xsl:text>
			</xsl:when>

      <xsl:when test="b:StyleNameLocalized">
        <xsl:choose>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1033'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1025'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1037'">
            <xsl:text>שיקגו</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1041'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='2052'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1028'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1042'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1036'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1040'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='3082'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1043'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1031'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1046'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1049'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1035'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1032'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1081'">
            <xsl:text>शिकागो</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1054'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1057'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1086'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1066'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1053'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1069'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1027'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1030'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1110'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1044'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1061'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1062'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1063'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1045'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='2070'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1029'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1055'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1038'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1048'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1058'">
            <xsl:text>Чикаго</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1026'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1050'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1087'">
            <xsl:text>Чикаго мәнерлер нұсқауы</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='2074'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='3098'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1051'">
            <xsl:text>DrNoack</xsl:text>
          </xsl:when>
          <xsl:when test="b:StyleNameLocalized/b:Lcid='1060'">
            <xsl:text>Slog DrNoack</xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:when>


      <xsl:when test="b:GetImportantFields">
				<b:ImportantFields>
					<xsl:choose>
						<xsl:when test="b:GetImportantFields/b:SourceType='Book'">
							<b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:City</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Publisher</xsl:text></b:ImportantField>

						</xsl:when>

						<xsl:when test="b:GetImportantFields/b:SourceType='BookSection'">
							<b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Author/b:BookAuthor/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:BookTitle</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Pages</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:City</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Publisher</xsl:text></b:ImportantField>
						</xsl:when>

						<xsl:when test="b:GetImportantFields/b:SourceType='JournalArticle'">
							<b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:JournalName</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Pages</xsl:text></b:ImportantField>
						</xsl:when>

						<xsl:when test="b:GetImportantFields/b:SourceType='ArticleInAPeriodical'">
							<b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:PeriodicalTitle</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Month</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Day</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Pages</xsl:text></b:ImportantField>
						</xsl:when>

						<xsl:when test="b:GetImportantFields/b:SourceType='ConferenceProceedings'">
							<b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Pages</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:ConferenceName</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:City</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Publisher</xsl:text></b:ImportantField>
						</xsl:when>

						<xsl:when test="b:GetImportantFields/b:SourceType='Report'">
							<b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Publisher</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:City</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:ThesisType</xsl:text></b:ImportantField>
						</xsl:when>

						<xsl:when test="b:GetImportantFields/b:SourceType='SoundRecording'">
							<b:ImportantField><xsl:text>b:Author/b:Composer/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Author/b:Conductor/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Author/b:Performer/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
						</xsl:when>

						<xsl:when test="b:GetImportantFields/b:SourceType='Performance'">
							<b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Author/b:Writer/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Author/b:Performer/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Theater</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:City</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Month</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Day</xsl:text></b:ImportantField>
						</xsl:when>

						<xsl:when test="b:GetImportantFields/b:SourceType='Art'">
							<b:ImportantField><xsl:text>b:Author/b:Artist/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Institution</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:PublicationTitle</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:City</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
						</xsl:when>

						<xsl:when test="b:GetImportantFields/b:SourceType='DocumentFromInternetSite'">
							<b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:InternetSiteTitle</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Month</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Day</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:YearAccessed</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:MonthAccessed</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:DayAccessed</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:URL</xsl:text></b:ImportantField>
						</xsl:when>

						<xsl:when test="b:GetImportantFields/b:SourceType='InternetSite'">
							<b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Month</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Day</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:YearAccessed</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:MonthAccessed</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:DayAccessed</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:URL</xsl:text></b:ImportantField>
						</xsl:when>

						<xsl:when test="b:GetImportantFields/b:SourceType='Film'">
							<b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Author/b:Performer/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Author/b:Director/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
						</xsl:when>

						<xsl:when test="b:GetImportantFields/b:SourceType='Interview'">
							<b:ImportantField><xsl:text>b:Author/b:Interviewee/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Author/b:Interviewer/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Month</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Day</xsl:text></b:ImportantField>
						</xsl:when>

						<xsl:when test="b:GetImportantFields/b:SourceType='Patent'">
							<b:ImportantField><xsl:text>b:Author/b:Inventor/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Month</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Day</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:CountryRegion</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:PatentNumber</xsl:text></b:ImportantField>
						</xsl:when>

						<xsl:when test="b:GetImportantFields/b:SourceType='ElectronicSource'">
							<b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:City</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Month</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Day</xsl:text></b:ImportantField>
						</xsl:when>

						<xsl:when test="b:GetImportantFields/b:SourceType='Case'">
							<b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:CaseNumber</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Court</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Month</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Day</xsl:text></b:ImportantField>
						</xsl:when>

						<xsl:when test="b:GetImportantFields/b:SourceType='Misc'">
							<b:ImportantField><xsl:text>b:Author/b:Author/b:NameList</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Title</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:PublicationTitle</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Year</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Month</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Day</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:City</xsl:text></b:ImportantField>
							<b:ImportantField><xsl:text>b:Publisher</xsl:text></b:ImportantField>
						</xsl:when>

					</xsl:choose>
				</b:ImportantFields>
			</xsl:when>
			
			<xsl:when test="b:Citation">

				<xsl:variable name="ListPopulatedWithMain">
						<xsl:call-template name="populateMain">
							<xsl:with-param name="Type">b:Citation</xsl:with-param>
						</xsl:call-template>
				</xsl:variable>

			
			
				<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" xmlns="http://www.w3.org/TR/REC-html40">
					<head>
					</head>
					<body>
			            <xsl:variable name="LCID">
			              <xsl:choose>
			                <xsl:when test="b:LCID='0' or b:LCID='' or not(b:LCID)">
			                  <xsl:value-of select="/*/b:Locals/b:DefaultLCID"/>
			                </xsl:when>
			                <xsl:otherwise>
			                  <xsl:value-of select="b:LCID"/>
			                </xsl:otherwise>
			              </xsl:choose>
			            </xsl:variable>

			            <xsl:element name="p">

						<xsl:attribute name="lang">
							<xsl:value-of select="/*/b:Locals/b:Local[@LCID=$LCID]/@Culture"/>
						</xsl:attribute>

						<xsl:attribute name="dir">
							<xsl:value-of select="/*/b:Locals/b:Local[@LCID=$LCID]/b:Properties/b:Direction"/>
						</xsl:attribute>

						<xsl:variable name="type">
							<xsl:value-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:SourceType"/>
						</xsl:variable>

						<xsl:variable name="title0">
							<xsl:choose>
								<xsl:when test="string-length(msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:ShortTitle)>0">
									<xsl:value-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:ShortTitle" />
								</xsl:when>

								<xsl:otherwise>
									<xsl:value-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:Title" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="year0">
							<xsl:choose>
								<xsl:when test = "string-length(msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:Year) > 0">
									<xsl:value-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:Year" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="templ_str_NoDateShortUnCap"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>						

						<xsl:variable name="yearSimple">
							<xsl:value-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:Year" />
						</xsl:variable>						

						<xsl:variable name="authorMain">
							<xsl:copy-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:Author/b:Main"/>
						</xsl:variable>

						<xsl:variable name = "minAuthors">
							<xsl:choose>
								<xsl:when test = "msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:MinAuthors > 1">
									<xsl:value-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:MinAuthors" />
								</xsl:when>
								<xsl:otherwise>			
									<xsl:text>1</xsl:text>
								</xsl:otherwise>			
							</xsl:choose>
						</xsl:variable>
						
						<xsl:variable name="author0">
							<xsl:choose>
								<xsl:when test="string-length(msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:Author/b:Main/b:Corporate) > 0">
									<xsl:value-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:Author/b:Main/b:Corporate" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="cAuthors">
										<xsl:value-of select="count(msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:Author/b:Main/b:NameList/b:Person)" />
									</xsl:variable>
									<xsl:for-each select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:Author/b:Main/b:NameList/b:Person">
										
										<xsl:choose>
											<xsl:when test="$cAuthors > 3 and position() > $minAuthors">
											</xsl:when>

											<xsl:otherwise>
												<xsl:call-template name="formatNameCore">
													<xsl:with-param name="FML">
														<xsl:choose>
															<xsl:when test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:NonUniqueLastName">
																<xsl:call-template name="templ_prop_Chicago_CitationLong_FML"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:call-template name="templ_prop_Chicago_CitationShort_FML"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:with-param>
													<xsl:with-param name="FM">
														<xsl:choose>
															<xsl:when test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:NonUniqueLastName">
																<xsl:call-template name="templ_prop_Chicago_CitationLong_FM"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:call-template name="templ_prop_Chicago_CitationShort_FM"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:with-param>
													<xsl:with-param name="ML">
														<xsl:choose>
															<xsl:when test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:NonUniqueLastName">
																<xsl:call-template name="templ_prop_Chicago_CitationLong_ML"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:call-template name="templ_prop_Chicago_CitationShort_ML"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:with-param>
													<xsl:with-param name="FL">
														<xsl:choose>
															<xsl:when test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:NonUniqueLastName">
																<xsl:call-template name="templ_prop_Chicago_CitationLong_FL"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:call-template name="templ_prop_Chicago_CitationShort_FL"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:with-param>
													<xsl:with-param name="upperLast">no</xsl:with-param>
													<xsl:with-param name="withDot">no</xsl:with-param>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
										
										<xsl:choose>
											<xsl:when test = "$cAuthors > 3 and position() = $minAuthors">
                        <xsl:variable name="noCommaBeforeAnd">
                          <xsl:call-template name="templ_prop_NoCommaBeforeAnd" />
                        </xsl:variable>
                        <xsl:choose>
                          <xsl:when test="$noCommaBeforeAnd != 'yes'">
                            <xsl:call-template name="templ_prop_ListSeparator"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:call-template name="templ_prop_Space"/>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:call-template name="templ_str_AndOthersUnCap"/>
											</xsl:when>
											<xsl:when test = "$cAuthors > 3 and position() > $minAuthors">
											</xsl:when>
											<xsl:when test="($cAuthors - 1 = position() and ($cAuthors = 2 or $cAuthors = 3)) or ($cAuthors > 3 and position() = 2)">
												<xsl:variable name="noAndBeforeLastAuthor">
											        <xsl:call-template name="templ_prop_NoAndBeforeLastAuthor"/>
												</xsl:variable>

										        <xsl:if test="$noAndBeforeLastAuthor != 'yes'">
													<xsl:call-template name="templ_prop_Space"/>
											        <xsl:call-template name="templ_str_AndUnCap"/>
											        <xsl:call-template name="templ_prop_Space"/>
											    </xsl:if>
										        <xsl:if test="$noAndBeforeLastAuthor = 'yes'">
											        <xsl:call-template name="templ_prop_AuthorsSeparator"/>
										        </xsl:if>
											</xsl:when>
											<xsl:when test="$cAuthors > position() and 3 > position() ">
										        <xsl:call-template name="templ_prop_AuthorsSeparator"/>
											</xsl:when>
										</xsl:choose>
		
									</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="title">
							<xsl:choose>
								<xsl:when test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:NoTitle">
								</xsl:when>
								
								<xsl:otherwise>
									<xsl:value-of select="$title0" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="year">
							<xsl:choose>
								<xsl:when test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:NoYear">
								</xsl:when>
								
								<xsl:otherwise>
									<xsl:value-of select="$year0" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>						

						<xsl:variable name="author">
							<xsl:choose>
								<xsl:when test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:NoAuthor">
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$author0" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

					    <xsl:variable name="prop_APA_Hyphens">
					      <xsl:call-template name="templ_prop_Hyphens"/>
					    </xsl:variable>

						<xsl:variable name="volume" select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Volume"/>

						<xsl:variable name="volVolume">
							<xsl:if test="string-length($volume) > 0">
								<xsl:call-template name="StringFormat">
									<xsl:with-param name="format">
									  <xsl:choose>
										<xsl:when test="not(string-length($volume)=string-length(translate($volume, ',', '')))">
										  <xsl:call-template name="templ_str_VolumesShortUnCap"/>
										</xsl:when>
										<xsl:when test="string-length($volume)=string-length(translate($volume, $prop_APA_Hyphens, ''))">
										  <xsl:call-template name="templ_str_VolumeShortUnCap"/>
										</xsl:when>
										<xsl:otherwise>
										  <xsl:call-template name="templ_str_VolumesShortUnCap"/>
										</xsl:otherwise>
									  </xsl:choose>
									</xsl:with-param>
									<xsl:with-param name="parameters">
										<t:params>
											<t:param>
												<xsl:value-of select="$volume"/>
											</t:param>
										</t:params>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
						</xsl:variable>


						<xsl:variable name="pages" select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Pages"/>

						<xsl:variable name="displayAuthor">
							<xsl:value-of select="$author" />
						</xsl:variable>

						<xsl:variable name="displayTitle">
							<xsl:choose>
								<xsl:when test="string-length($displayAuthor) = 0">
									<xsl:value-of select="$title" />
								</xsl:when>
								<xsl:when test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:RepeatedAuthor">
									<xsl:value-of select="$title" />
								</xsl:when>
							</xsl:choose>
						</xsl:variable>

						
						<xsl:if test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:FirstAuthor">
							<xsl:call-template name="templ_prop_OpenBracket"/>
						</xsl:if>
					
						<xsl:if test="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:PagePrefix">
							<xsl:value-of select="/b:Citation/b:PagePrefix"/>
						</xsl:if>

						<xsl:value-of select="$displayAuthor" />

						<xsl:if test="string-length($displayTitle) > 0">
							<xsl:if test="string-length($displayAuthor) > 0">
								<xsl:call-template name="templ_prop_ListSeparator"/>
							</xsl:if>
							<xsl:if test="string-length($displayTitle)>0">
								<xsl:value-of select="$displayTitle"/>
							</xsl:if>
						</xsl:if>

						<xsl:if test="string-length($author0) = 0 and string-length($title0) = 0 and string-length($yearSimple) = 0">
							<xsl:value-of select="msxsl:node-set($ListPopulatedWithMain)/b:Citation/b:Source/b:Tag"/>
						</xsl:if>
						
						<xsl:if test="string-length($year) > 0 and not(string-length($author0) = 0 and string-length($title0) = 0 and string-length($yearSimple) = 0)">
							<xsl:if test="string-length($displayAuthor) > 0 or string-length($displayTitle) > 0">
								<xsl:call-template name="templ_prop_Space"/>
							</xsl:if>
							<xsl:value-of select="$year"/>
						</xsl:if>

						<xsl:if test="string-length($volume) > 0 or string-length($pages) > 0">
							<xsl:if test="string-length($displayAuthor) > 0 or string-length($displayTitle) > 0 or string-length($year) > 0">
								<xsl:call-template name="templ_prop_ListSeparator"/>
							</xsl:if>

							<xsl:choose>
								<xsl:when test="string-length($volume) > 0 and string-length($pages) > 0">
									<xsl:value-of select="$volume"/>
									<xsl:call-template name="templ_prop_Enum"/>
									<xsl:value-of select="$pages"/>
								</xsl:when>
								<xsl:when test="string-length($volVolume) > 0">
									<xsl:value-of select="$volVolume"/>
								</xsl:when>
								<xsl:when test="string-length($pages) > 0">
									<xsl:value-of select="$pages"/>
								</xsl:when>
							</xsl:choose>
						</xsl:if>

						<xsl:if test="/b:Citation/b:PageSuffix">
							<xsl:value-of select="/b:Citation/b:PageSuffix"/>
						</xsl:if>
						
						<xsl:if test="/b:Citation/b:LastAuthor">
							<xsl:call-template name="templ_prop_CloseBracket"/>
						</xsl:if>
						<xsl:if test="not(/b:Citation/b:LastAuthor)">
							<xsl:call-template name="templ_prop_ListSeparator"/>
						</xsl:if>
					

						</xsl:element>
					</body>
				</html>
			</xsl:when>
			<xsl:when test="b:Bibliography">


			
				<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" xmlns="http://www.w3.org/TR/REC-html40">
					<head>
						
						<style>
							p.MsoBibliography, li.MsoBibliography, div.MsoBibliography
						</style>
					</head>
					<body>

					
					
						<xsl:variable name="ListPopulatedWithMain">
								<xsl:call-template name="populateMain">
									<xsl:with-param name="Type">b:Bibliography</xsl:with-param>
								</xsl:call-template>
						</xsl:variable>
														
						<xsl:variable name="sList">
							<xsl:call-template name="sortedList">
								<xsl:with-param name="sourceRoot"><xsl:copy-of select="$ListPopulatedWithMain"/></xsl:with-param>
							</xsl:call-template>
						</xsl:variable>



						<xsl:variable name="dups">
							<xsl:for-each select="msxsl:node-set($sList)/b:Bibliography/b:Source">
								<b:author>
									<xsl:call-template name="formatMain"/>
								</b:author>
							</xsl:for-each>
						</xsl:variable>
						
						<xsl:for-each select="msxsl:node-set($sList)/b:Bibliography/b:Source">

							<xsl:variable name="LCID">
								<xsl:choose>
									<xsl:when test="b:LCID='0' or b:LCID='' or not(b:LCID)">
										<xsl:value-of select="/*/b:Locals/b:DefaultLCID"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="b:LCID"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<xsl:variable name="dir">
								<xsl:value-of select="/*/b:Locals/b:Local[@LCID=$LCID]/b:Properties/b:Direction"/>
							</xsl:variable>

							<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
							<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>

							<xsl:element name="p">
								<xsl:attribute name="lang">
									<xsl:value-of select="/*/b:Locals/b:Local[@LCID=$LCID]/@Culture"/>
								</xsl:attribute>
								<xsl:attribute name="dir">
									<xsl:value-of select="$dir"/>
								</xsl:attribute>
								<xsl:attribute name="class">
									<xsl:value-of select="'MsoBibliography'"/>
								</xsl:attribute>
								<xsl:attribute name="style">
									<xsl:choose>
										<xsl:when test="translate($dir,$uppercase,$lowercase)='rtl'">
											<xsl:value-of select="'margin-right:.5in;text-indent:-.5in'"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="'margin-left:.5in;text-indent:-.5in'"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>

								<xsl:variable name="cEditors">
									<xsl:value-of select="count(b:Author/b:Editor/b:NameList/b:Person)"/>
								</xsl:variable>

								<xsl:variable name="cTranslators">
									<xsl:value-of select="count(b:Author/b:Translator/b:NameList/b:Person)"/>
								</xsl:variable>

								<xsl:variable name="cComposers">
									<xsl:value-of select="count(b:Author/b:Composer/b:NameList/b:Person)"/>
								</xsl:variable>

								<xsl:variable name="cCompilers">
									<xsl:value-of select="count(b:Author/b:Compiler/b:NameList/b:Person)"/>
								</xsl:variable>

								<xsl:variable name="cPerformers">
									<xsl:value-of select="count(b:Author/b:Performer/b:NameList/b:Person)"/>
								</xsl:variable>

								<xsl:variable name="cDirectors">
									<xsl:value-of select="count(b:Author/b:Director/b:NameList/b:Person)"/>
								</xsl:variable>

								<xsl:variable name="cProducers">
									<xsl:value-of select="count(b:Author/b:ProducerName/b:NameList/b:Person)"/>
								</xsl:variable>

								<xsl:variable name="cConductors">
									<xsl:value-of select="count(b:Author/b:Conductor/b:NameList/b:Person)"/>
								</xsl:variable>





								<xsl:variable name="actIndex" select="position()"/>
								<xsl:variable name="lastIndex" select="position() - 1"/>

								<xsl:variable name="actAuthor">
									<xsl:value-of select="msxsl:node-set($dups)/b:author[$actIndex]"/>
								</xsl:variable>

								<xsl:variable name="lastAuthor">
									<xsl:value-of select="msxsl:node-set($dups)/b:author[$lastIndex]"/>
								</xsl:variable>

								<xsl:variable name="authorMain">
									<xsl:choose>
										<xsl:when test="position()=1">
											<xsl:call-template name="formatMain"/>
										</xsl:when>
										<xsl:when test="$actAuthor=$lastAuthor and string-length($actAuthor)>0 ">
											<xsl:call-template name="templ_prop_Chicago_SameAuthor"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="formatMain"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>

								<xsl:variable name="author">
									<xsl:call-template name="formatAuthor"/>
								</xsl:variable>





								<xsl:variable name="compiler">
									<xsl:call-template name="formatCompiler"/>
								</xsl:variable>

								<xsl:variable name="compilerLF">
									<xsl:call-template name="formatCompilerLF"/>
								</xsl:variable>

								<xsl:variable name="editor">
									<xsl:call-template name="formatEditor"/>
								</xsl:variable>

								<xsl:variable name="editorLF">
									<xsl:call-template name="formatEditorLF"/>
								</xsl:variable>

								<xsl:variable name="translator">
									<xsl:call-template name="formatTranslator"/>
								</xsl:variable>

								<xsl:variable name="translatorLF">
									<xsl:call-template name="formatTranslatorLF"/>
								</xsl:variable>

								<xsl:variable name="performer">
									<xsl:call-template name="formatPerformer"/>
								</xsl:variable>

								<xsl:variable name="intervieweeLF">
									<xsl:call-template name="formatIntervieweeLF"/>
								</xsl:variable>

								<xsl:variable name="producerName">
									<xsl:call-template name="formatProducerName"/>
								</xsl:variable>

								<xsl:variable name="interviewer">
									<xsl:call-template name="formatInterviewer"/>
								</xsl:variable>

								<xsl:variable name="interviewerLF">
									<xsl:call-template name="formatInterviewerLF"/>
								</xsl:variable>

								<xsl:variable name="writer">
									<xsl:call-template name="formatWriter"/>
								</xsl:variable>

								<xsl:variable name="writerLF">
									<xsl:call-template name="formatWriterLF"/>
								</xsl:variable>

								<xsl:variable name="director">
									<xsl:call-template name="formatDirector"/>
								</xsl:variable>

								<xsl:variable name="inventorLF">
									<xsl:call-template name="formatInventorLF"/>
								</xsl:variable>

								<xsl:variable name="bookAuthor">
									<xsl:call-template name="formatBookAuthor"/>
								</xsl:variable>

								<xsl:variable name="sectionAuthor">
									<xsl:call-template name="formatAuthor"/>
								</xsl:variable>

								<xsl:variable name="performerLF">
									<xsl:call-template name="formatPerformerLF"/>
								</xsl:variable>

								<xsl:variable name="conductorLF">
									<xsl:call-template name="formatConductorLF"/>
								</xsl:variable>

								<xsl:variable name="conductor">
									<xsl:call-template name="formatConductor"/>
								</xsl:variable>

								<xsl:variable name="composerLF">
									<xsl:call-template name="formatComposerLF"/>
								</xsl:variable>

								<xsl:variable name="composer">
									<xsl:call-template name="formatComposer"/>
								</xsl:variable>

								<xsl:variable name="artist">
									<xsl:call-template name="formatArtistLF"/>
								</xsl:variable>

								<xsl:variable name="writerLFDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$writerLF"/>
									</xsl:call-template>
								</xsl:variable>




								<xsl:variable name="date">
									<xsl:call-template name="formatDate"/>
								</xsl:variable>

								<xsl:variable name="dateDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$date"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="dateAccessed">
									<xsl:call-template name="formatDateAccessed"/>
								</xsl:variable>

								<xsl:variable name="dateAccessedDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$dateAccessed"/>
									</xsl:call-template>
								</xsl:variable>

								                  <xsl:variable name="enclosedDate">
                  <xsl:if test="string-length(b:Year)>0">
                    <xsl:call-template name="templ_prop_APA_GeneralOpen"/>

				<xsl:value-of select="b:Year"/>
                    <xsl:call-template name="templ_prop_APA_GeneralClose"/>
                  </xsl:if>
                </xsl:variable>

								<xsl:variable name="tempCPY">
									<xsl:call-template name="templateCPY"/>
								</xsl:variable>

								<xsl:variable name="tempRICPY">
									<xsl:call-template name="templateRICPY"/>
								</xsl:variable>

								<xsl:variable name="tempCPDMY">
									<xsl:call-template name="templateCPDMY"/>
								</xsl:variable>

								<xsl:variable name="tempDEP">
									<xsl:call-template name="templateDEP"/>
								</xsl:variable>

								<xsl:variable name="tempRYM">
									<xsl:call-template name="templateRYM"/>
								</xsl:variable>

								<xsl:variable name="tempTC">
									<xsl:call-template name="templateTC"/>
								</xsl:variable>

								<xsl:variable name="tempIC">
									<xsl:call-template name="templateIC"/>
								</xsl:variable>

								<xsl:variable name="tempDY">
									<xsl:call-template name="templateDY"/>
								</xsl:variable>

								<xsl:variable name="tempCPD">
									<xsl:call-template name="templateCPD"/>
								</xsl:variable>

								<xsl:variable name="tempSC">
									<xsl:call-template name="templateSC"/>
								</xsl:variable>

								<xsl:variable name="tempCP">
									<xsl:call-template name="templateCP"/>
								</xsl:variable>

								<xsl:variable name="tempCCD">
									<xsl:call-template name="templateCCD"/>
								</xsl:variable>

								<xsl:variable name="tempVIYP">
									<xsl:call-template name="templateVIYP"/>
								</xsl:variable>

								<xsl:variable name="tempDaU">
									<xsl:variable name="temporaryDaU">
										<xsl:call-template name="templateDACURL"/>
									</xsl:variable>

									<xsl:call-template name="appendFieldNoHandleSpaces_Dot">
										<xsl:with-param name="field" select="$temporaryDaU"/>
									</xsl:call-template>		
								</xsl:variable>







								<xsl:variable name="titleDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:Title"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="albumTitleDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:AlbumTitle"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="pagesDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:Pages"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="bookTitleDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:BookTitle"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="conferenceNameDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:ConferenceName"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="broadcasterDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:Broadcaster"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="interviewTitle">
									<xsl:call-template name="handleSpaces">
										<xsl:with-param name="field" select="b:Title"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="publisher">
									<xsl:call-template name="handleSpaces">
										<xsl:with-param name="field" select="b:Publisher"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="interviewTitleDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:Title"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="publicationTitle">
									<xsl:call-template name="handleSpaces">
										<xsl:with-param name="field" select="b:PublicationTitle"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="publicationTitleDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:PublicationTitle"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="URL">
									<xsl:value-of select="b:URL"/>
								</xsl:variable>

								<xsl:variable name="cityDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:City"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="institutionDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:Institution"/>
									</xsl:call-template>
								</xsl:variable>
								
								<xsl:variable name="courtDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:Court"/>
									</xsl:call-template>
								</xsl:variable>
								
								<xsl:variable name="thesisTypeDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:ThesisType"/>
									</xsl:call-template>
								</xsl:variable>
								
								<xsl:variable name="journalNameDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:JournalName"/>
									</xsl:call-template>
								</xsl:variable>
								
								<xsl:variable name="journalName">
									<xsl:call-template name="handleSpaces">
										<xsl:with-param name="field" select="b:JournalName"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="internetSiteTitleDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:InternetSiteTitle"/>
									</xsl:call-template>
								</xsl:variable>
								
								<xsl:variable name="mediumDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:Medium"/>
									</xsl:call-template>
								</xsl:variable>
								
								<xsl:variable name="issueDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:Issue"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="numberVolumesDot">
									<xsl:if test="string-length(b:NumberVolumes) > 0">
										<xsl:call-template name="appendField_Dot">
											<xsl:with-param name="field">
												<xsl:call-template name="StringFormat">
													<xsl:with-param name="format">
														<xsl:call-template name="templ_str_VolumesAfterShortUnCap"/>
													</xsl:with-param>
													<xsl:with-param name="parameters">
														<t:params>
															<t:param>
																<xsl:value-of select="b:NumberVolumes"/>
															</t:param>
														</t:params>
													</xsl:with-param>
												</xsl:call-template>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="str_NumberShortUnCap">
									<xsl:call-template name="templ_str_NumberShortUnCap"/>
								</xsl:variable>

								<xsl:variable name="noIssueDot">
								  <xsl:if test="string-length(b:Issue) > 0">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field">
											<xsl:call-template name="StringFormat">
								  				<xsl:with-param name="format" select="$str_NumberShortUnCap"/>
								  				<xsl:with-param name="parameters">
								  					<t:params>
								  						<t:param>
															<xsl:value-of select="b:Issue"/>
														</t:param>
								  					</t:params>
								  				</xsl:with-param>
											</xsl:call-template>
										</xsl:with-param>								
									</xsl:call-template>
								  </xsl:if>
								</xsl:variable>
								
								<xsl:variable name="productionCompanyDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:ProductionCompany"/>
									</xsl:call-template>
								</xsl:variable>
								
								<xsl:variable name="editionDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:Edition"/>
									</xsl:call-template>
								</xsl:variable>
								
								<xsl:variable name="broadcastTitle">
									<xsl:call-template name="handleSpaces">
										<xsl:with-param name="field" select="b:BroadcastTitle"/>
									</xsl:call-template>
								</xsl:variable>
								
								<xsl:variable name="versionDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:Version"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="broadcastTitleDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:BroadcastTitle"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="periodicalTitleDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="b:PeriodicalTitle"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="periodicalTitle">
									<xsl:call-template name="handleSpaces">
										<xsl:with-param name="field" select="b:PeriodicalTitle"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="productionCompany">
									<xsl:call-template name="handleSpaces">
										<xsl:with-param name="field" select="b:ProductionCompany"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="caseNumber">
									<xsl:call-template name="handleSpaces">
										<xsl:with-param name="field" select="b:CaseNumber"/>
									</xsl:call-template>
								</xsl:variable>
								
								<xsl:variable name="broadcaster">
									<xsl:call-template name="handleSpaces">
										<xsl:with-param name="field" select="b:Broadcaster"/>
									</xsl:call-template>
								</xsl:variable>
								
								<xsl:variable name="volume">
									<xsl:call-template name="handleSpaces">
										<xsl:with-param name="field" select="b:Volume"/>
									</xsl:call-template>
								</xsl:variable>
								
								


								<xsl:variable name="prefixVersionDot">
									<xsl:if test="string-length($versionDot)>0">
										<xsl:call-template name="templ_str_VersionShortCap"/>
										<xsl:call-template name="templ_prop_Space"/>
										<xsl:value-of select="$versionDot"/>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="prefixEditorDot">
									<xsl:if test="string-length($editor)>0">
										<xsl:if test="$cEditors > 1">
											
											<xsl:call-template name="templ_str_EditorShortCap"/>
										</xsl:if>
										<xsl:if test="$cEditors = 1">
											<xsl:call-template name="templ_str_EditorShortCap"/>
										</xsl:if>
										<xsl:call-template name="templ_prop_Space"/>
										<xsl:call-template name="appendField_Dot">
											<xsl:with-param name="field" select="$editor"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="prefixTranslatorDot">
									<xsl:if test="string-length($translator)>0">
										<xsl:if test="$cTranslators > 1">
											<xsl:call-template name="templ_str_TranslatorsShortCap"/>
										</xsl:if>
										<xsl:if test="$cTranslators = 1">
											<xsl:call-template name="templ_str_TranslatorShortCap"/>
										</xsl:if>
										<xsl:call-template name="templ_prop_Space"/>
										<xsl:call-template name="appendField_Dot">
											<xsl:with-param name="field" select="$translator"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="prefixDirectorDot">
									<xsl:if test="string-length($director)>0">
										<xsl:if test="$cDirectors > 1">
											<xsl:call-template name="templ_str_DirectorsShortCap"/>
										</xsl:if>
										<xsl:if test="$cDirectors = 1">
											<xsl:call-template name="templ_str_DirectorShortCap"/>
										</xsl:if>
										<xsl:call-template name="templ_prop_Space"/>
										<xsl:call-template name="appendField_Dot">
											<xsl:with-param name="field" select="$director"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="prefixPerformerDot">
									<xsl:if test="string-length($performer)>0">
										<xsl:if test="$cPerformers > 1">
											
											<xsl:call-template name="templ_str_PerformerShortCap"/>
										</xsl:if>
										<xsl:if test="$cPerformers = 1">
											<xsl:call-template name="templ_str_PerformerShortCap"/>
										</xsl:if>
										<xsl:call-template name="templ_prop_Space"/>
										<xsl:call-template name="appendField_Dot">
											<xsl:with-param name="field" select="$performer"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="sufixEditorLFDot">
									<xsl:if test="string-length($editorLF)>0">
										<xsl:value-of select="$editorLF"/>
										<xsl:call-template name="templ_prop_ListSeparator"/>
										<xsl:if test="$cEditors > 1">
											<xsl:call-template name="templ_str_EditorsShortUnCap"/>
										</xsl:if>
										<xsl:if test="$cEditors = 1">
											<xsl:call-template name="templ_str_EditorShortUnCap"/>
										</xsl:if>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="prefixConductorDot">
									<xsl:if test="string-length($conductor)>0">
										<xsl:if test="$cConductors > 1">
											<xsl:call-template name="templ_str_ConductorsShortCap"/>
										</xsl:if>
										<xsl:if test="$cConductors = 1">
											<xsl:call-template name="templ_str_ConductorShortCap"/>
										</xsl:if>
										<xsl:call-template name="templ_prop_Space"/>
										<xsl:call-template name="appendField_Dot">
											<xsl:with-param name="field" select="$conductor"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="prefixComposerDot">
									<xsl:if test="string-length($composer)>0">
										<xsl:if test="$cComposers > 1">
											<xsl:call-template name="templ_str_ComposersShortCap"/>
										</xsl:if>
										<xsl:if test="$cComposers = 1">
											<xsl:call-template name="templ_str_ComposerShortCap"/>
										</xsl:if>
										<xsl:call-template name="templ_prop_Space"/>
										<xsl:call-template name="appendField_Dot">
											<xsl:with-param name="field" select="$composer"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="prefixCompilerDot">
									<xsl:if test="string-length($compiler)>0">
										<xsl:if test="$cCompilers > 1">
											<xsl:call-template name="templ_str_CompilersShortCap"/>
										</xsl:if>
										<xsl:if test="$cCompilers = 1">
											<xsl:call-template name="templ_str_CompilerShortCap"/>
										</xsl:if>
										<xsl:call-template name="templ_prop_Space"/>
										<xsl:call-template name="appendField_Dot">
											<xsl:with-param name="field" select="$compiler"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="sufixCompilerLFDot">
									<xsl:if test="string-length($compilerLF)>0">
										<xsl:value-of select="$compilerLF"/>
										<xsl:call-template name="templ_prop_ListSeparator"/>
										<xsl:if test="$cCompilers > 1">
											<xsl:call-template name="templ_str_CompilersShortUnCap"/>
										</xsl:if>
										<xsl:if test="$cCompilers = 1">
											<xsl:call-template name="templ_str_CompilerShortUnCap"/>
										</xsl:if>
									</xsl:if>
								</xsl:variable>
						
						    <xsl:variable name="prop_APA_Hyphens">
						      <xsl:call-template name="templ_prop_Hyphens"/>
						    </xsl:variable>


								<xsl:variable name="prefixVolume">
									<xsl:if test="string-length($volume)>0">
										<xsl:call-template name="StringFormat">
												<xsl:with-param name="format">
											  <xsl:choose>
												<xsl:when test="not(string-length($volume)=string-length(translate($volume, ',', '')))">
												  <xsl:call-template name="templ_str_VolumesShortCap"/>
												</xsl:when>
												<xsl:when test="string-length($volume)=string-length(translate($volume, $prop_APA_Hyphens, ''))">
												  <xsl:call-template name="templ_str_VolumeShortCap"/>
												</xsl:when>
												<xsl:otherwise>
												  <xsl:call-template name="templ_str_VolumesShortCap"/>
												</xsl:otherwise>
											  </xsl:choose>
												</xsl:with-param>
												<xsl:with-param name="parameters">
													<t:params>
														<t:param>
														<xsl:value-of select="$volume"/>
													</t:param>
													</t:params>
												</xsl:with-param>
										</xsl:call-template>	
									</xsl:if>
								</xsl:variable>
						    
								<xsl:variable name="prefixVolumeDot">
									<xsl:if test="string-length($prefixVolume)>0">
										<xsl:call-template name="appendField_Dot">
											<xsl:with-param name="field">
												<xsl:value-of select="$prefixVolume" />
											</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

				                <xsl:variable name="i_volumeBookTitle">
		                      	  <xsl:value-of select="$prefixVolume"/>

			                      <xsl:if test="(string-length($bookTitleDot)>0 or string-length(b:ChapterNumber) > 0) and string-length($prefixVolumeDot)>0">
  			                        <xsl:call-template name="templ_prop_ListSeparator"/>
				                  </xsl:if>
				                  
								<xsl:call-template name="StringFormat">
									<xsl:with-param name="format">
			                    		<xsl:if test="(string-length($bookTitleDot)>0 or string-length(b:ChapterNumber) > 0) and string-length($prefixVolumeDot)>0">
											<xsl:choose>
												<xsl:when test = "string-length(b:BookTitle) > 0 and string-length(b:ChapterNumber) > 0">
					                        		<xsl:call-template name="templ_str_ChapterInUnCap"/>
												</xsl:when>
												<xsl:when test = "string-length(b:BookTitle)">
					                        		<xsl:call-template name="templ_str_InNameUnCap"/>
												</xsl:when>
												<xsl:when test = "string-length(b:ChapterNumber) > 0">
					                        		<xsl:call-template name="templ_str_ChapterUnCap"/>
												</xsl:when>
											</xsl:choose>
										</xsl:if>
			                    		<xsl:if test="not((string-length($bookTitleDot)>0 or string-length(b:ChapterNumber) > 0) and string-length($prefixVolumeDot)>0)">
											<xsl:choose>
												<xsl:when test = "string-length(b:BookTitle) > 0 and string-length(b:ChapterNumber) > 0">
					                        		<xsl:call-template name="templ_str_ChapterInCap"/>
												</xsl:when>
												<xsl:when test = "string-length(b:BookTitle)">
					                        		<xsl:call-template name="templ_str_InNameCap"/>
												</xsl:when>
												<xsl:when test = "string-length(b:ChapterNumber) > 0">
					                        		<xsl:call-template name="templ_str_ChapterCap"/>
												</xsl:when>
											</xsl:choose>
										</xsl:if>
									</xsl:with-param>

									<xsl:with-param name="parameters">
										<t:params>
											<xsl:if test = "string-length(b:ChapterNumber) > 0">
												<t:param>
													<xsl:value-of select="b:ChapterNumber"/>
												</t:param>
											</xsl:if>																						
											<xsl:if test = "string-length(b:BookTitle)">
												<t:param>
											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
														<xsl:value-of select="b:BookTitle"/>
												     </xsl:with-param>
												    </xsl:call-template>
												</t:param>
											</xsl:if>
										</t:params>
									</xsl:with-param>
								</xsl:call-template>
				                </xsl:variable>

				                <xsl:variable name="i_volumeBookTitleDot">
			                      	<xsl:if test="string-length($i_volumeBookTitle)>0">
				                      	<xsl:copy-of select="$i_volumeBookTitle"/>
										<xsl:call-template name="need_Dot">
											<xsl:with-param name="field" select ="$i_volumeBookTitle"/>
										</xsl:call-template>
				                  	</xsl:if>
				                </xsl:variable>

								<xsl:variable name="theCapShortPrefixVolumeDot">
									<xsl:if test="string-length($volume)>0">
										<xsl:call-template name="appendField_Dot">
											<xsl:with-param name="field">
												<xsl:call-template name="StringFormat">
  													<xsl:with-param name="format">
													  <xsl:choose>
														<xsl:when test="not(string-length($volume)=string-length(translate($volume, ',', '')))">
														  <xsl:call-template name="templ_str_VolumesShortCap"/>
														</xsl:when>
														<xsl:when test="string-length($volume)=string-length(translate($volume, $prop_APA_Hyphens, ''))">
														  <xsl:call-template name="templ_str_VolumeShortCap"/>
														</xsl:when>
														<xsl:otherwise>
														  <xsl:call-template name="templ_str_VolumesShortCap"/>
														</xsl:otherwise>
													  </xsl:choose>
  													</xsl:with-param>
  													<xsl:with-param name="parameters">
  														<t:params>
  															<t:param>
																<xsl:value-of select="$volume"/>
															</t:param>
  														</t:params>
  													</xsl:with-param>
												</xsl:call-template>	
											</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="sufixTranslatorLFDot">
									<xsl:if test="string-length($translatorLF)>0">
										<xsl:value-of select="$translatorLF"/>
										<xsl:call-template name="templ_prop_ListSeparator"/>
										<xsl:if test="$cTranslators > 1">
											<xsl:call-template name="templ_str_TranslatorsShortUnCap"/>
										</xsl:if>
										<xsl:if test="$cTranslators = 1">
											<xsl:call-template name="templ_str_TranslatorShortUnCap"/>
										</xsl:if>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="caseNoDot">
									<xsl:value-of select="$caseNumber"/>
								</xsl:variable>

								<xsl:variable name="existProd">
									<xsl:if test="string-length(normalize-space($producerName))>0">
											<xsl:text>N</xsl:text>
									</xsl:if>
									<xsl:if test="string-length(normalize-space(b:ProductionCompany))">
											<xsl:text>C</xsl:text>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="prodDot">
									<xsl:if test="string-length($producerName)>0">
										<xsl:call-template name="appendField_Dot">
											<xsl:with-param name="field" select="$producerName"/>
										</xsl:call-template>
									</xsl:if>

									<xsl:if test="string-length($producerName)=0 and string-length($productionCompany)">
										<xsl:call-template name="appendField_Dot">
											<xsl:with-param name="field" select="$productionCompany"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="prod">
									<xsl:if test="string-length($producerName)>0">
										<xsl:value-of select="$producerName"/>
									</xsl:if>

									<xsl:if test="string-length($producerName)=0 and string-length($productionCompany)">
										<xsl:value-of select="$productionCompany"/>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="prefixProdDot">
									<xsl:if test="string-length($producerName)>0 or string-length($productionCompany)>0">
										<xsl:if test="$cProducers > 1">
											<xsl:call-template name="templ_str_ProducersShortCap"/>
											<xsl:call-template name="templ_prop_Space"/>
										</xsl:if>
										<xsl:if test="$cProducers = 1">
											<xsl:call-template name="templ_str_ProducerShortCap"/>
											<xsl:call-template name="templ_prop_Space"/>
										</xsl:if>

										<xsl:value-of select="$prodDot"/>
									</xsl:if>
								</xsl:variable>



								<xsl:variable name="authorDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$author"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="sectionAuthorDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$sectionAuthor"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="bookAuthorDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$bookAuthor"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="performerLFDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$performerLF"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="artistDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$artist"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="interviewerDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$interviewer"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="intervieweeLFDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$intervieweeLF"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="conductorLFDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$conductorLF"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="inventorLFDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$inventorLF"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="producerNameDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$producerName"/>
									</xsl:call-template>
								</xsl:variable>


								<xsl:variable name="writerDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$writer"/>
									</xsl:call-template>
								</xsl:variable>

								<xsl:variable name="composerLFDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$composerLF"/>
									</xsl:call-template>
								</xsl:variable>


								<xsl:variable name="theAuthorSufix">
									<xsl:choose>
										<xsl:when test="string-length($author)>0">
											<xsl:value-of select="$authorMain"/>
										</xsl:when>
										<xsl:when test="string-length($editorLF)>0 and (b:SourceType='Book' or b:SourceType='Misc' or b:SourceType='ArticleInAPeriodical' or b:SourceType='ConferenceProceedings' or b:SourceType='InternetSite' or b:SourceType='DocumentFromInternetSite')">
											<xsl:value-of select="$editorLF"/>
											<xsl:call-template name="templ_prop_ListSeparator"/>
											<xsl:if test="$cEditors=1">
												<xsl:call-template name="templ_str_EditorShortUnCap"/>
											</xsl:if>
											<xsl:if test="$cEditors>1">
												<xsl:call-template name="templ_str_EditorsShortUnCap"/>
											</xsl:if>
										</xsl:when>
										<xsl:when test="string-length($compilerLF)>0 and (b:SourceType='Misc')">
											<xsl:value-of select="$compilerLF"/>
											<xsl:call-template name="templ_prop_ListSeparator"/>
											<xsl:if test="$cCompilers=1">
												<xsl:call-template name="templ_str_CompilerShortUnCap"/>
											</xsl:if>
											<xsl:if test="$cCompilers>1">
												<xsl:call-template name="templ_str_CompilersShortUnCap"/>
											</xsl:if>
										</xsl:when>
										<xsl:when test="string-length($translatorLF)>0 and (b:SourceType='Book' or b:SourceType='Misc')">
											<xsl:value-of select="$translatorLF"/>
											<xsl:call-template name="templ_prop_ListSeparator"/>
											<xsl:if test="$cTranslators=1">
												<xsl:call-template name="templ_str_TranslatorShortUnCap"/>
											</xsl:if>
											<xsl:if test="$cTranslators>1">
												<xsl:call-template name="templ_str_TranslatorsShortUnCap"/>
											</xsl:if>
										</xsl:when>
									</xsl:choose>
								</xsl:variable>

								<xsl:variable name="theAuthorSufixDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$theAuthorSufix"/>
									</xsl:call-template>
								</xsl:variable>


                <xsl:variable name="str_ByUnCap">
                  <xsl:call-template name="templ_str_ByUnCap"/>
                </xsl:variable>

                <xsl:variable name="theUnCapLongByAuthor">
					<xsl:if test="string-length($bookAuthor)>0">
						<xsl:call-template name="StringFormat">
								<xsl:with-param name="format" select="$str_ByUnCap"/>
								<xsl:with-param name="parameters">
									<t:params>
										<t:param>
										<xsl:value-of select="$bookAuthor"/>
									</t:param>
									</t:params>
								</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
				</xsl:variable>

                <xsl:variable name="str_ByCap">
                  <xsl:call-template name="templ_str_ByCap"/>
                </xsl:variable>

                <xsl:variable name="theCapLongByAuthor">
					<xsl:if test="string-length($bookAuthor)>0">
						<xsl:call-template name="StringFormat">
								<xsl:with-param name="format" select="$str_ByCap"/>
								<xsl:with-param name="parameters">
									<t:params>
										<t:param>
										<xsl:value-of select="$bookAuthor"/>
									</t:param>
									</t:params>
								</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
				</xsl:variable>
                
                <xsl:variable name="str_EditedByCap">
                  <xsl:call-template name="templ_str_EditedByCap"/>
                </xsl:variable>

                <xsl:variable name="theCapLongPrefixEditor">
									<xsl:if test="string-length($editor)>0 and string-length($author)>0">
										<xsl:call-template name="StringFormat">
	  										<xsl:with-param name="format" select="$str_EditedByCap"/>
	  										<xsl:with-param name="parameters">
	  											<t:params>
	  												<t:param>
														<xsl:value-of select="$editor"/>
													</t:param>
	  											</t:params>
	  										</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="theCapLongPrefixEditorDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$theCapLongPrefixEditor"/>
									</xsl:call-template>
								</xsl:variable>

                <xsl:variable name="str_CompiledByCap">
                  <xsl:call-template name="templ_str_CompiledByCap"/>
                </xsl:variable>

                <xsl:variable name="theCapLongPrefixCompiler">
									<xsl:if test="string-length($compiler)>0 and (string-length($author)>0 or string-length($editor)>0)">
										<xsl:call-template name="StringFormat">
	  										<xsl:with-param name="format" select="$str_CompiledByCap"/>
	  										<xsl:with-param name="parameters">
	  											<t:params>
	  												<t:param>
														<xsl:value-of select="$compiler"/>
													</t:param>
	  											</t:params>
	  										</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="theCapLongPrefixCompilerDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$theCapLongPrefixCompiler"/>
									</xsl:call-template>
								</xsl:variable>
                
                <xsl:variable name="str_TranslatedByCap">
                  <xsl:call-template name="templ_str_TranslatedByCap"/>
                </xsl:variable>

                <xsl:variable name="theCapLongPrefixTranslator">
									<xsl:if test="string-length($translator)>0 and (string-length($author)>0 or string-length($editor)>0 or string-length($compiler)>0)">
										<xsl:call-template name="StringFormat">
	  										<xsl:with-param name="format" select="$str_TranslatedByCap"/>
	  										<xsl:with-param name="parameters">
	  											<t:params>
	  												<t:param>
														<xsl:value-of select="$translator"/>
													</t:param>
	  											</t:params>
	  										</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="theCapLongPrefixTranslatorDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$theCapLongPrefixTranslator"/>
									</xsl:call-template>
								</xsl:variable>

                <xsl:variable name="theCapLongPrefixEditedBy">
									<xsl:if test="string-length($editor)>0">
										<xsl:call-template name="StringFormat">
	  										<xsl:with-param name="format" select="$str_EditedByCap"/>
	  										<xsl:with-param name="parameters">
	  											<t:params>
	  												<t:param>
														<xsl:value-of select="$editor"/>
													</t:param>
	  											</t:params>
	  										</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="theCapLongPrefixEditedByDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$theCapLongPrefixEditedBy"/>
									</xsl:call-template>
								</xsl:variable>

                <xsl:variable name="str_EditedByUnCap">
                  <xsl:call-template name="templ_str_EditedByUnCap"/>
                </xsl:variable>


                <xsl:variable name="theUnCapLongPrefixEditedBy">
									<xsl:if test="string-length($editor)>0">
										<xsl:call-template name="StringFormat">
	  										<xsl:with-param name="format" select="$str_EditedByUnCap"/>
	  										<xsl:with-param name="parameters">
	  											<t:params>
	  												<t:param>
														<xsl:value-of select="$editor"/>
													</t:param>
	  											</t:params>
	  										</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="theUnCapLongPrefixEditedByDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$theUnCapLongPrefixEditedBy"/>
									</xsl:call-template>
								</xsl:variable>

                <xsl:variable name="theCapLongPrefixTranslatedBy">
									<xsl:if test="string-length($translator)>0">
										<xsl:call-template name="StringFormat">
	  										<xsl:with-param name="format" select="$str_TranslatedByCap"/>
	  										<xsl:with-param name="parameters">
	  											<t:params>
	  												<t:param>
														<xsl:value-of select="$translator"/>
													</t:param>
	  											</t:params>
	  										</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="theCapLongPrefixTranslatedByDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$theCapLongPrefixTranslatedBy"/>
									</xsl:call-template>
								</xsl:variable>

                <xsl:variable name="str_TranslatedByUnCap">
                  <xsl:call-template name="templ_str_TranslatedByUnCap"/>
                </xsl:variable>


                <xsl:variable name="theUnCapLongPrefixTranslatedBy">
									<xsl:if test="string-length($translator)>0">
										<xsl:call-template name="StringFormat">
	  										<xsl:with-param name="format" select="$str_TranslatedByUnCap"/>
	  										<xsl:with-param name="parameters">
	  											<t:params>
	  												<t:param>
														<xsl:value-of select="$translator"/>
													</t:param>
	  											</t:params>
	  										</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="theUnCapLongPrefixTranslatedByDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$theUnCapLongPrefixTranslatedBy"/>
									</xsl:call-template>
								</xsl:variable>





								<xsl:variable name="theCPAuthorSufix">
									<xsl:choose>
										<xsl:when test="string-length($author)>0">
											<xsl:value-of select="$authorMain"/>
										</xsl:when>
										<xsl:when test="string-length($editorLF)>0">
											<xsl:value-of select="$editorLF"/>
											<xsl:call-template name="templ_prop_ListSeparator"/>
											<xsl:if test="$cEditors=1">
												<xsl:call-template name="templ_str_EditorShortUnCap"/>
											</xsl:if>
											<xsl:if test="$cEditors>1">
												<xsl:call-template name="templ_str_EditorsShortUnCap"/>
											</xsl:if>
										</xsl:when>
									</xsl:choose>
								</xsl:variable>

								<xsl:variable name="theCPAuthorSufixDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$theCPAuthorSufix"/>
									</xsl:call-template>
								</xsl:variable>

                <xsl:variable name="theCPCapLongPrefixEditor">
									<xsl:if test="string-length($editor)>0 and string-length($author)>0">
										<xsl:call-template name="StringFormat">
	  										<xsl:with-param name="format" select="$str_EditedByCap"/>
	  										<xsl:with-param name="parameters">
	  											<t:params>
	  												<t:param>
														<xsl:value-of select="$editor"/>
													</t:param>
	  											</t:params>
	  										</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="theCPCapLongPrefixEditorDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$theCapLongPrefixEditor"/>
									</xsl:call-template>
								</xsl:variable>

                <xsl:variable name="str_DirectedByCap">
                  <xsl:call-template name="templ_str_DirectedByCap"/>
                </xsl:variable>

                <xsl:variable name="theCapLongPrefixDirectedBy">
									<xsl:if test="string-length($director)>0">
										<xsl:call-template name="StringFormat">
	  										<xsl:with-param name="format" select="$str_DirectedByCap"/>
	  										<xsl:with-param name="parameters">
	  											<t:params>
	  												<t:param>
														<xsl:value-of select="$director"/>
													</t:param>
	  											</t:params>
	  										</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="theCapLongPrefixDirectedByDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$theCapLongPrefixDirectedBy"/>
									</xsl:call-template>
								</xsl:variable>

                <xsl:variable name="str_PerformedByCap">
                  <xsl:call-template name="templ_str_PerformedByCap"/>
                </xsl:variable>

                <xsl:variable name="theCapLongPrefixPerformedBy">
									<xsl:if test="string-length($performer)>0">
										<xsl:call-template name="StringFormat">
	  										<xsl:with-param name="format" select="$str_PerformedByCap"/>
	  										<xsl:with-param name="parameters">
	  											<t:params>
	  												<t:param>
														<xsl:value-of select="$performer"/>
													</t:param>
	  											</t:params>
	  										</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="theCapLongPrefixPerformedByDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$theCapLongPrefixPerformedBy"/>
									</xsl:call-template>
								</xsl:variable>

                <xsl:variable name="str_ProducedByCap">
                  <xsl:call-template name="templ_str_ProducedByCap"/>
                </xsl:variable>

                <xsl:variable name="theCapLongPrefixProducedBy">
									<xsl:if test="string-length($prod)>0">
										<xsl:call-template name="StringFormat">
	  										<xsl:with-param name="format" select="$str_ProducedByCap"/>
	  										<xsl:with-param name="parameters">
	  											<t:params>
	  												<t:param>
														<xsl:value-of select="$prod"/>
													</t:param>
	  											</t:params>
	  										</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
								</xsl:variable>

								<xsl:variable name="theCapLongPrefixProducedByDot">
									<xsl:call-template name="appendField_Dot">
										<xsl:with-param name="field" select="$theCapLongPrefixProducedBy"/>
									</xsl:call-template>
								</xsl:variable>





								<xsl:choose>
									<xsl:when test="b:SourceType='Book'">
									
										<xsl:if test="string-length($theAuthorSufixDot)>0">
											<xsl:value-of select="$theAuthorSufixDot"/>
										</xsl:if>
										
										<xsl:if test="string-length($titleDot)>0">
											<xsl:if test="string-length($theAuthorSufixDot)>0">
												<xsl:call-template name="templ_prop_Space"/>
											</xsl:if>

									        <xsl:call-template name = "ApplyItalicTitleNS">
									         <xsl:with-param name = "data">
											<xsl:value-of select="$titleDot"/>
										     </xsl:with-param>
										    </xsl:call-template>
										</xsl:if>
										
										<xsl:if test="string-length($editionDot)>0">
											<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0">
												<xsl:call-template name="templ_prop_Space"/>
											</xsl:if>

											<xsl:value-of select="$editionDot"/>
										</xsl:if>

										<xsl:if test="string-length($theCapLongPrefixEditorDot)>0">
											<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($editionDot)>0">
												<xsl:call-template name="templ_prop_Space"/>
											</xsl:if>

											<xsl:value-of select="$theCapLongPrefixEditorDot"/>
										</xsl:if>
									
										<xsl:if test="string-length($theCapLongPrefixTranslatorDot)>0">
											<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($theCapLongPrefixEditorDot)>0 or string-length($editionDot)>0">
												<xsl:call-template name="templ_prop_Space"/>
											</xsl:if>

											<xsl:value-of select="$theCapLongPrefixTranslatorDot"/>
										</xsl:if>
									
										<xsl:if test="string-length($theCapShortPrefixVolumeDot)>0">
											<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($theCapLongPrefixEditorDot)>0 or string-length($theCapLongPrefixTranslatorDot)>0 or string-length($editionDot)>0">
												<xsl:call-template name="templ_prop_Space"/>
											</xsl:if>

											<xsl:value-of select="$theCapShortPrefixVolumeDot"/>
										</xsl:if>

										<xsl:if test="string-length($numberVolumesDot)>0">
											<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($theCapLongPrefixEditorDot)>0 or string-length($theCapLongPrefixTranslatorDot)>0 or string-length($theCapShortPrefixVolumeDot)>0 or string-length($editionDot)>0">
												<xsl:call-template name="templ_prop_Space"/>
											</xsl:if>

											<xsl:value-of select="$numberVolumesDot"/>
										</xsl:if>

										<xsl:if test="string-length($tempCPY)>0">
											<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($theCapLongPrefixEditorDot)>0 or string-length($theCapLongPrefixTranslatorDot)>0 or string-length($theCapShortPrefixVolumeDot)>0 or string-length($editionDot)>0 or string-length($numberVolumesDot)>0">
												<xsl:call-template name="templ_prop_Space"/>
											</xsl:if>

											<xsl:value-of select="$tempCPY"/>
										</xsl:if>
									
									</xsl:when>


									<xsl:when test="b:SourceType='ConferenceProceedings'">
									
										<xsl:if test="string-length($theCPAuthorSufixDot)>0">
											<xsl:value-of select="$theCPAuthorSufixDot"/>
										</xsl:if>
										
										<xsl:if test="string-length($titleDot)>0">
											<xsl:if test="string-length($theCPAuthorSufixDot)>0">
												<xsl:call-template name="templ_prop_Space"/>
											</xsl:if>

											<xsl:call-template name="templ_prop_OpenQuote"/>
											<xsl:value-of select="$titleDot"/>
											<xsl:call-template name="templ_prop_CloseQuote"/>
										</xsl:if>
										
										<xsl:if test="string-length($theCPCapLongPrefixEditorDot)>0">
											<xsl:if test="string-length($theCPAuthorSufixDot)>0 or string-length($titleDot)>0">
												<xsl:call-template name="templ_prop_Space"/>
											</xsl:if>

											<xsl:value-of select="$theCPCapLongPrefixEditorDot"/>
										</xsl:if>
									
									
										<xsl:if test="string-length($conferenceNameDot)>0">
											<xsl:if test="string-length($theCPAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($theCPCapLongPrefixEditorDot)>0">
												<xsl:call-template name="templ_prop_Space"/>
											</xsl:if>

									        <xsl:call-template name = "ApplyItalicTitleNS">
									         <xsl:with-param name = "data">
											<xsl:value-of select="$conferenceNameDot"/>
										     </xsl:with-param>
										    </xsl:call-template>
										</xsl:if>

										<xsl:if test="string-length($tempCPY)>0">
											<xsl:if test="string-length($theCPAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($theCPCapLongPrefixEditorDot)>0 or string-length($conferenceNameDot)>0">
												<xsl:call-template name="templ_prop_Space"/>
											</xsl:if>

											<xsl:value-of select="$tempCPY"/>
										</xsl:if>
									
										<xsl:if test="string-length($pagesDot)>0">
											<xsl:if test="string-length($theCPAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($theCPCapLongPrefixEditorDot)>0 or string-length($conferenceNameDot)>0 or string-length($tempCPY)>0">
												<xsl:call-template name="templ_prop_Space"/>
											</xsl:if>

											<xsl:value-of select="$pagesDot"/>
										</xsl:if>

									</xsl:when>



									
									<xsl:when test="b:SourceType='BookSection'">
<!--												<xsl:if test="string-length($sectionAuthorDot)>0">
													<xsl:value-of select="$sectionAuthorDot"/>
												</xsl:if> -->

												<xsl:if test="string-length($sectionAuthor)>0">
													<xsl:value-of select="$sectionAuthor"/>
												</xsl:if>

												<xsl:choose>
													<xsl:when test = "string-length($volume)>0">
														<xsl:if test="string-length($titleDot)>0">
															<xsl:if test="string-length($sectionAuthorDot)>0">
																<xsl:call-template name="templ_prop_Space"/>
															</xsl:if>

													        <xsl:call-template name = "ApplyItalicTitleNS">
													         <xsl:with-param name = "data">
																<xsl:value-of select="$titleDot"/>
														     </xsl:with-param>
														    </xsl:call-template>
															<xsl:if test="string-length($sectionAuthorDot)>0 or string-length($titleDot)>0 or string-length($bookAuthorDot)>0">
																<xsl:call-template name="templ_prop_Space"/>
															</xsl:if>
														</xsl:if>
													</xsl:when>
													
													<xsl:otherwise>
														<xsl:if test="string-length($titleDot)>0">
<!--															<xsl:if test="string-length($sectionAuthorDot)>0"> 
																<xsl:call-template name="templ_prop_Space"/>
															</xsl:if> -->

                        <xsl:if test="string-length($enclosedDate)>0">
                          <xsl:call-template name="templ_prop_Space"/>
                          <xsl:value-of select="$enclosedDate"/>
                        </xsl:if>

			<xsl:call-template name="templ_prop_Space"/>
			
															<xsl:call-template name="templ_prop_OpenQuote"/>
															
															<xsl:value-of select="$titleDot"/>
															
															<xsl:call-template name="templ_prop_CloseQuote"/>
														</xsl:if>
    <xsl:text>,</xsl:text>
														<xsl:if test="string-length($sectionAuthorDot)>0 or string-length($titleDot)>0 or string-length($bookAuthorDot)>0">
															<xsl:call-template name="templ_prop_Space"/>
														</xsl:if>
														
													</xsl:otherwise>
												</xsl:choose>

        <xsl:text>in:</xsl:text>
															<xsl:call-template name="templ_prop_Space"/>
															<xsl:value-of select="$theAuthorSufix"/>
															<xsl:call-template name="templ_prop_Space"/>
															<xsl:call-template name = "ApplyItalicTitleNS">
																					         <xsl:with-param name = "data">
																								<xsl:value-of select="b:BookTitle"/>
																						     </xsl:with-param>
																						    </xsl:call-template>



												<xsl:call-template name='PrintSpaceAndList'>
													<xsl:with-param name="list">
														<Items>
<!--															<CopyItem>

																<xsl:choose>
																	<xsl:when test = "string-length($volume)>0">
																		<xsl:if test="string-length($i_volumeBookTitleDot)>0">
																			<xsl:copy-of select="$i_volumeBookTitle"/>
																		</xsl:if>
																	</xsl:when>
																	
																	<xsl:otherwise>
																		<xsl:call-template name="StringFormat">
																			<xsl:with-param name="format">
																				<xsl:choose>
																					<xsl:when test = "string-length(b:BookTitle) > 0 and string-length(b:ChapterNumber) > 0">
														                        		<xsl:call-template name="templ_str_ChapterInCap"/>
																					</xsl:when>
																					<xsl:when test = "string-length(b:BookTitle)">
														                        		<xsl:call-template name="templ_str_InNameCap"/>
																					</xsl:when>
																					<xsl:when test = "string-length(b:ChapterNumber) > 0">
														                        		<xsl:call-template name="templ_str_ChapterCap"/>
																					</xsl:when>
																				</xsl:choose>
																			</xsl:with-param>

																			<xsl:with-param name="parameters">
																				<t:params>
																					<xsl:if test = "string-length(b:ChapterNumber) > 0">
																						<t:param>
																							<xsl:value-of select="b:ChapterNumber"/>
																						</t:param>
																					</xsl:if>																						
																					<xsl:if test = "string-length(b:BookTitle)">
																						<t:param>
																					        <xsl:call-template name = "ApplyItalicTitleNS">
																					         <xsl:with-param name = "data">
																								<xsl:value-of select="b:BookTitle"/>
																						     </xsl:with-param>
																						    </xsl:call-template>
																						</t:param>
																					</xsl:if>
																				</t:params>
																			</xsl:with-param>
																		</xsl:call-template>
																	</xsl:otherwise>
																</xsl:choose>
															</CopyItem>
															<TextItem>
																<xsl:choose>
																	<xsl:when test = "string-length(b:ChapterNumber)=0 and string-length($volume)=0 and string-length($bookTitleDot)=0">
																		<xsl:value-of select="$theCapLongByAuthor"/>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="$theUnCapLongByAuthor"/>
																	</xsl:otherwise>
																</xsl:choose>
															</TextItem>
															<TextItem>
																<xsl:choose>
																	<xsl:when test = "string-length(b:ChapterNumber)=0 and string-length($volume)=0 and string-length($bookTitleDot)=0 and string-length($theCapLongByAuthor)=0">
																		<xsl:value-of select="$theCapLongPrefixEditedBy"/>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="$theUnCapLongPrefixEditedBy"/>
																	</xsl:otherwise>
																</xsl:choose>
															</TextItem>
															<TextItem>
																<xsl:choose>
																	<xsl:when test = "string-length(b:ChapterNumber)=0 and string-length($volume)=0 and string-length($bookTitleDot)=0 and string-length($theCapLongByAuthor)=0 and string-length($theCapLongPrefixEditedBy)=0">
																		<xsl:value-of select="$theUnCapLongPrefixTranslatedBy"/>
																	</xsl:when>
																	<xsl:otherwise>
																		<xsl:value-of select="$theUnCapLongPrefixTranslatedBy"/>
																	</xsl:otherwise>
																</xsl:choose>
															</TextItem> -->
															<TextItem>
    <xsl:text>, S. </xsl:text>
																<xsl:value-of select="b:Pages"/>
															</TextItem>
														</Items>
													</xsl:with-param>
												</xsl:call-template>

												<xsl:if test="string-length($tempCPY)>0">
													<xsl:if test="string-length($sectionAuthorDot)>0 or string-length($titleDot)>0 or string-length($bookAuthorDot)>0 or string-length($bookTitleDot)>0 or string-length($prefixEditorDot)>0 or string-length($prefixTranslatorDot)>0 or string-length($volume)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$tempCPY"/>
												</xsl:if>
									</xsl:when>
									

									<xsl:when test="b:SourceType='JournalArticle'">

												<xsl:if test="string-length($authorDot)>0">
													<xsl:value-of select="$authorDot"/>
												</xsl:if>

												<xsl:if test="string-length($authorDot)=0 and string-length($sufixEditorLFDot)>0">
													<xsl:value-of select="$sufixEditorLFDot"/>
												</xsl:if>

												<xsl:if test="string-length($titleDot)>0">
													<xsl:if test="string-length($authorDot)>0 or string-length($sufixEditorLFDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:call-template name="templ_prop_OpenQuote"/>
													
													<xsl:value-of select="$titleDot"/>
													
													<xsl:call-template name="templ_prop_CloseQuote"/>
												</xsl:if>

												<xsl:if test="string-length($theCPCapLongPrefixEditorDot)>0 and string-length($authorDot)>0">
													<xsl:if test="string-length($authorDot)>0 or string-length($titleDot)>0 or string-length($sufixEditorLFDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$theCPCapLongPrefixEditorDot"/>
												</xsl:if>

												<xsl:if test="string-length($journalName)>0">
													<xsl:if test="string-length($authorDot)>0 or string-length($titleDot)>0 or string-length($sufixEditorLFDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
													<xsl:if test="string-length($tempVIYP)>0">
														<xsl:value-of select="$journalName"/>
													</xsl:if>
													<xsl:if test="string-length($tempVIYP)=0">
														<xsl:value-of select="$journalNameDot"/>
													</xsl:if>
    										       </xsl:with-param>
    										      </xsl:call-template>
												</xsl:if>
											
												<xsl:if test="string-length($tempVIYP)>0">
													<xsl:if test="string-length($journalName)=0 and (string-length($authorDot)>0 or string-length($titleDot)>0 or string-length($journalName)>0 or string-length($sufixEditorLFDot)>0)">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$tempVIYP"/>
												</xsl:if>
												
									</xsl:when>

									<xsl:when test="b:SourceType='Report'">

										<xsl:choose>
										
											<xsl:when test="string-length($publisher)>0">


												<xsl:if test="string-length($authorDot)>0">
													<xsl:value-of select="$authorDot"/>
												</xsl:if>

												<xsl:if test="string-length($titleDot)>0">
													<xsl:if test="string-length($authorDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
													<xsl:value-of select="$titleDot"/>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>

												<xsl:if test="string-length($tempRICPY)>0">
													<xsl:if test="string-length($authorDot)>0 or string-length($titleDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$tempRICPY"/>
												</xsl:if>

											</xsl:when>


										
											<xsl:otherwise>
<!--												<xsl:if test="string-length($authorDot)>0">
													<xsl:value-of select="$authorDot"/>
												</xsl:if> -->

												<xsl:if test="string-length($author)>0">
													<xsl:value-of select="$author"/>
												</xsl:if>

												
                        <xsl:if test="string-length($enclosedDate)>0">
                          <xsl:call-template name="templ_prop_Space"/>
                          <xsl:value-of select="$enclosedDate"/>
                        </xsl:if>

			<xsl:call-template name="templ_prop_Space"/>
												
												<xsl:if test="string-length($titleDot)>0">
													<xsl:if test="string-length($authorDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:call-template name="templ_prop_OpenQuote"/>
													
													<xsl:value-of select="$titleDot"/>
													
													<xsl:call-template name="templ_prop_CloseQuote"/>
												</xsl:if>
											
<!--												<xsl:if test="string-length($tempRICPY)>0">
													<xsl:if test="string-length($authorDot)>0 or string-length($titleDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$tempRICPY"/>
												</xsl:if> -->

											</xsl:otherwise>


										</xsl:choose>
									</xsl:when>
									
									

									<xsl:when test="b:SourceType='SoundRecording'">



										<xsl:choose>
										
											<xsl:when test="string-length($performerLF)>0">

												<xsl:value-of select="$performerLFDot"/>

												<xsl:if test="string-length($titleDot)>0 and string-length($albumTitleDot)>0">
													<xsl:call-template name="templ_prop_Space"/>

													<xsl:call-template name="templ_prop_OpenQuote"/>
													<xsl:value-of select="$titleDot"/>
													<xsl:call-template name="templ_prop_CloseQuote"/>
												</xsl:if>

												<xsl:if test="string-length($titleDot)>0 and string-length($albumTitleDot)=0">
													<xsl:call-template name="templ_prop_Space"/>
			
											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
													<xsl:value-of select="$titleDot"/>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>

												<xsl:if test="string-length($albumTitleDot)>0">
													<xsl:call-template name="templ_prop_Space"/>

											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
													<xsl:value-of select="$albumTitleDot"/>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>

												<xsl:if test="string-length($prefixConductorDot)>0">
													<xsl:call-template name="templ_prop_Space"/>

													<xsl:value-of select="$prefixConductorDot"/>
												</xsl:if>

												<xsl:if test="string-length($prefixComposerDot)>0">
													<xsl:call-template name="templ_prop_Space"/>

													<xsl:value-of select="$prefixComposerDot"/>
												</xsl:if>

												<xsl:if test="string-length($tempRYM)>0">
													<xsl:call-template name="templ_prop_Space"/>

													<xsl:value-of select="$tempRYM"/>
												</xsl:if>

											</xsl:when>

										
											<xsl:when test="string-length($conductorLFDot)>0">

												<xsl:value-of select="$conductorLFDot"/>

												<xsl:if test="string-length($titleDot)>0 and string-length($albumTitleDot)>0">
													<xsl:call-template name="templ_prop_Space"/>

													<xsl:call-template name="templ_prop_OpenQuote"/>
													<xsl:value-of select="$titleDot"/>
													<xsl:call-template name="templ_prop_CloseQuote"/>
												</xsl:if>

												<xsl:if test="string-length($titleDot)>0 and string-length($albumTitleDot)=0">
													<xsl:call-template name="templ_prop_Space"/>
			
											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
													<xsl:value-of select="$titleDot"/>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>

												<xsl:if test="string-length($albumTitleDot)>0">
													<xsl:call-template name="templ_prop_Space"/>

											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
													<xsl:value-of select="$albumTitleDot"/>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>

												<xsl:if test="string-length($prefixComposerDot)>0">
													<xsl:call-template name="templ_prop_Space"/>

													<xsl:value-of select="$prefixComposerDot"/>
												</xsl:if>

												<xsl:if test="string-length($tempRYM)>0">
													<xsl:call-template name="templ_prop_Space"/>

													<xsl:value-of select="$tempRYM"/>
												</xsl:if>

											</xsl:when>

										
											<xsl:otherwise>

												<xsl:if test="string-length($composerLFDot)>0">
													<xsl:value-of select="$composerLFDot"/>
												</xsl:if>

											
												<xsl:if test="string-length($titleDot)>0 and string-length($albumTitleDot)>0">
													<xsl:if test="string-length($composerLFDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:call-template name="templ_prop_OpenQuote"/>
													<xsl:value-of select="$titleDot"/>
													<xsl:call-template name="templ_prop_CloseQuote"/>
												</xsl:if>

												<xsl:if test="string-length($titleDot)>0 and string-length($albumTitleDot)=0">
													<xsl:if test="string-length($composerLFDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>
			
											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
													<xsl:value-of select="$titleDot"/>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>

												<xsl:if test="string-length($albumTitleDot)>0">
													<xsl:if test="string-length($composerLFDot)>0 or string-length($titleDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
													<xsl:value-of select="$albumTitleDot"/>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>


												<xsl:if test="string-length($tempRYM)>0">
													<xsl:if test="string-length($composerLFDot)>0 or string-length($titleDot)>0 or string-length($albumTitleDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$tempRYM"/>
												</xsl:if>

											</xsl:otherwise>



										</xsl:choose>
									</xsl:when>


									<xsl:when test="b:SourceType='Performance'">

												<xsl:if test="string-length($writerLFDot)>0">
													<xsl:call-template name="templ_prop_Space"/>
													<xsl:value-of select="$writerLFDot"/>
												</xsl:if>

												<xsl:if test="string-length($titleDot)>0">
													<xsl:if test="string-length($writerLFDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>
											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
													<xsl:value-of select="$titleDot"/>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>

												<xsl:if test="string-length($theCapLongPrefixDirectedByDot)>0">
													<xsl:if test="string-length($titleDot)>0 or string-length($writerDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$theCapLongPrefixDirectedByDot"/>
												</xsl:if>

												<xsl:if test="string-length($theCapLongPrefixPerformedByDot)>0">
													<xsl:if test="string-length($titleDot)>0 or string-length($writerDot)>0 or string-length($theCapLongPrefixDirectedByDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$theCapLongPrefixPerformedByDot"/>
												</xsl:if>

												<xsl:if test="string-length($tempTC)>0">
													<xsl:if test="string-length($titleDot)>0 or string-length($writerDot)>0 or string-length($theCapLongPrefixDirectedByDot)>0 or string-length($theCapLongPrefixPerformedByDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$tempTC"/>
												</xsl:if>


												<xsl:if test="string-length($dateDot)>0">
													<xsl:if test="string-length($titleDot)>0 or string-length($writerDot)>0 or string-length($theCapLongPrefixDirectedByDot)>0 or string-length($theCapLongPrefixPerformedByDot)>0 or string-length($tempTC)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$dateDot"/>
												</xsl:if>


								</xsl:when>


									<xsl:when test="b:SourceType='Art'">


										<xsl:choose>
											
											<xsl:when test="string-length($publicationTitle)>0">

												<xsl:if test="string-length($artistDot)>0">
													<xsl:value-of select="normalize-space($artistDot)"/>
												</xsl:if>

												<xsl:if test="string-length($titleDot)>0">
													<xsl:if test="string-length($artistDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:call-template name="templ_prop_OpenQuote"/>
													<xsl:value-of select="$titleDot"/>
													<xsl:call-template name="templ_prop_CloseQuote"/>
												</xsl:if>

												<xsl:if test="string-length($institutionDot)>0">
													<xsl:if test="string-length($artistDot)>0 or string-length($titleDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$institutionDot"/>
												</xsl:if>

												<xsl:if test="string-length($publicationTitleDot)>0">
													<xsl:if test="string-length($artistDot)>0 or string-length($titleDot)>0 or string-length($institutionDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
													<xsl:value-of select="$publicationTitleDot"/>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>

												<xsl:if test="string-length($tempCPY)>0">
													<xsl:if test="string-length($artistDot)>0 or string-length($titleDot)>0 or string-length($institutionDot)>0 or string-length($publicationTitle)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$tempCPY"/>
												</xsl:if>

											</xsl:when>
											
											
											<xsl:otherwise>
											
												<xsl:if test="string-length($artistDot)>0">
													<xsl:value-of select="normalize-space($artistDot)"/>
												</xsl:if>

												
												<xsl:if test="string-length($titleDot)>0">
													<xsl:if test="string-length($artistDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
													<xsl:value-of select="$titleDot"/>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>

												<xsl:if test="string-length($tempIC)>0">
													<xsl:if test="string-length($artistDot)>0 or string-length($titleDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$tempIC"/>
												</xsl:if>

											</xsl:otherwise>
											
										</xsl:choose>



									</xsl:when>

									<xsl:when test="b:SourceType='DocumentFromInternetSite'">


	
												<xsl:if test="string-length($theAuthorSufixDot)>0">
													<xsl:value-of select="$theAuthorSufixDot"/>
												</xsl:if>

											
												<xsl:if test="string-length($titleDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:call-template name="templ_prop_OpenQuote"/>
													<xsl:value-of select="$titleDot"/>
													<xsl:call-template name="templ_prop_CloseQuote"/>
												</xsl:if>

												<xsl:if test="string-length($prefixVersionDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>
													<xsl:value-of select="$prefixVersionDot"/>
												</xsl:if>

												<xsl:if test="string-length($internetSiteTitleDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($versionDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
													<xsl:value-of select="$internetSiteTitleDot"/>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>


												<xsl:if test="string-length($theCPCapLongPrefixEditorDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($versionDot)>0 or string-length($internetSiteTitleDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$theCPCapLongPrefixEditorDot"/>
												</xsl:if>

												<xsl:if test="string-length($prodDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($versionDot)>0 or string-length($internetSiteTitleDot)>0 or string-length($theCPCapLongPrefixEditorDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$prodDot"/>
												</xsl:if>

												<xsl:if test="string-length($dateDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($versionDot)>0 or string-length($internetSiteTitleDot)>0 or string-length($theCPCapLongPrefixEditorDot)>0 or string-length($prodDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$dateDot"/>
												</xsl:if>

												<xsl:if test="string-length($tempDaU)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($versionDot)>0 or string-length($internetSiteTitleDot)>0 or string-length($theCPCapLongPrefixEditorDot)>0 or string-length($prodDot)>0 or string-length($dateDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$tempDaU"/>
												</xsl:if>

									</xsl:when>


							

									<xsl:when test="b:SourceType='InternetSite'">

<!--												<xsl:if test="string-length($theAuthorSufixDot)>0">
													<xsl:value-of select="$theAuthorSufixDot"/>
												</xsl:if> -->

												<xsl:if test="string-length($theAuthorSufix)>0">
													<xsl:value-of select="$theAuthorSufix"/>
												</xsl:if>

			<xsl:if test="string-length($enclosedDate)>0">
                          <xsl:call-template name="templ_prop_Space"/>
                          <xsl:value-of select="$enclosedDate"/>
                        </xsl:if>

			<xsl:call-template name="templ_prop_Space"/>

												<xsl:if test="string-length($titleDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
													<xsl:value-of select="$titleDot"/>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>

												<xsl:if test="string-length($theCPCapLongPrefixEditorDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$theCPCapLongPrefixEditorDot"/>
												</xsl:if>

												<xsl:if test="string-length($prefixVersionDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($theCPCapLongPrefixEditorDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$prefixVersionDot"/>
												</xsl:if>


												<xsl:if test="string-length($prodDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($theCPCapLongPrefixEditorDot)>0 or string-length($versionDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$prodDot"/>
												</xsl:if>

<!--												<xsl:if test="string-length($dateDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($theCPCapLongPrefixEditorDot)>0 or string-length($versionDot)>0 or string-length($prodDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$dateDot"/>
												</xsl:if> -->

												<xsl:if test="string-length($tempDaU)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($theCPCapLongPrefixEditorDot)>0 or string-length($versionDot)>0 or string-length($dateDot)>0 or string-length($prodDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$tempDaU"/>
												</xsl:if>

									</xsl:when>




									<xsl:when test="b:SourceType='Patent'">



												<xsl:if test="string-length($inventorLFDot)>0">
													<xsl:value-of select="$inventorLFDot"/>
												</xsl:if>

											
												<xsl:if test="string-length($titleDot)>0">
													<xsl:if test="string-length($inventorLFDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>
													
													<xsl:value-of select="$titleDot"/>
												</xsl:if>

												<xsl:if test="string-length($prefixEditorDot)>0">
													<xsl:if test="string-length($inventorLFDot)>0 or string-length($titleDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$prefixEditorDot"/>
												</xsl:if>

												<xsl:if test="string-length($prefixTranslatorDot)>0">
													<xsl:if test="string-length($inventorLFDot)>0 or string-length($titleDot)>0 or string-length($prefixEditorDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$prefixTranslatorDot"/>
												</xsl:if>

												<xsl:if test="string-length($tempCP)>0">
													<xsl:if test="string-length($inventorLFDot)>0 or string-length($titleDot)>0 or string-length($prefixEditorDot)>0 or string-length($prefixTranslatorDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$tempCP"/>
												</xsl:if>

												<xsl:if test="string-length($dateDot)>0">
													<xsl:if test="string-length($inventorLFDot)>0 or string-length($titleDot)>0 or string-length($prefixEditorDot)>0 or string-length($prefixTranslatorDot)>0 or string-length($tempCP)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$dateDot"/>
												</xsl:if>

									</xsl:when>



									<xsl:when test="b:SourceType='Case'">


												<xsl:if test="string-length($titleDot)>0">
											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
														<xsl:value-of select="$titleDot"/>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>

												<xsl:if test="string-length($caseNoDot)>0">
													<xsl:if test="string-length($titleDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>
	
													<xsl:value-of select="$caseNoDot"/>
												</xsl:if>

												<xsl:if test="string-length($tempCCD)>0">
													<xsl:if test="string-length($titleDot)>0 or string-length($caseNoDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>
	
													<xsl:value-of select="$tempCCD"/>
												</xsl:if>

									</xsl:when>



									<xsl:when test="b:SourceType='Misc'">

												<xsl:if test="string-length($theAuthorSufixDot)>0">
													<xsl:value-of select="$theAuthorSufixDot"/>
												</xsl:if>

												<xsl:if test="string-length($titleDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:call-template name="templ_prop_OpenQuote"/>
													<xsl:value-of select="$titleDot"/>
													<xsl:call-template name="templ_prop_CloseQuote"/>
												</xsl:if>

												<xsl:if test="string-length($publicationTitleDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
													<xsl:value-of select="$publicationTitleDot"/>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>

												<xsl:if test="string-length($prefixVolumeDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($publicationTitleDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$prefixVolumeDot"/>
												</xsl:if>


												<xsl:if test="string-length($noIssueDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($publicationTitleDot)>0 or string-length($prefixVolumeDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$noIssueDot"/>
												</xsl:if>

												<xsl:if test="string-length($theCPCapLongPrefixEditorDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($publicationTitleDot)>0 or string-length($prefixVolumeDot)>0 or string-length($issueDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$theCPCapLongPrefixEditorDot"/>
												</xsl:if>

												<xsl:if test="string-length($theCapLongPrefixTranslatorDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($publicationTitleDot)>0 or string-length($prefixVolumeDot)>0 or string-length($issueDot)>0 or string-length($theCPCapLongPrefixEditorDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$theCapLongPrefixTranslatorDot"/>
												</xsl:if>

												<xsl:if test="string-length($theCapLongPrefixCompilerDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($publicationTitleDot)>0 or string-length($prefixVolumeDot)>0 or string-length($issueDot)>0 or string-length($theCPCapLongPrefixEditorDot)>0 or string-length($theCapLongPrefixTranslatorDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$theCapLongPrefixCompilerDot"/>
												</xsl:if>


												<xsl:if test="string-length($tempCPD)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($publicationTitleDot)>0 or string-length($prefixVolumeDot)>0 or string-length($issueDot)>0 or string-length($theCPCapLongPrefixEditorDot)>0 or string-length($theCapLongPrefixTranslatorDot)>0 or string-length($theCapLongPrefixCompilerDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$tempCPD"/>
												</xsl:if>

												<xsl:if test="string-length($pagesDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0 or string-length($publicationTitleDot)>0 or string-length($prefixVolumeDot)>0 or string-length($issueDot)>0 or string-length($theCPCapLongPrefixEditorDot)>0 or string-length($theCapLongPrefixTranslatorDot)>0 or string-length($theCapLongPrefixCompilerDot)>0 or string-length($tempCPD)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$pagesDot"/>
												</xsl:if>


									</xsl:when>




									<xsl:when test="b:SourceType='ElectronicSource'">

												<xsl:variable name="lfAuthor">
													<xsl:if test="string-length($authorDot)>0">
														<xsl:value-of select="$authorDot"/>
													</xsl:if>


													<xsl:if test="string-length($authorDot)=0 and string-length($sufixEditorLFDot)>0">
														<xsl:value-of select="$sufixEditorLFDot"/>
													</xsl:if>

													<xsl:if test="string-length($authorDot)=0 and string-length($sufixEditorLFDot)=0 and string-length($sufixTranslatorLFDot)>0">
														<xsl:value-of select="$sufixTranslatorLFDot"/>
													</xsl:if>

													<xsl:if test="string-length($authorDot)=0 and string-length($sufixEditorLFDot)=0 and string-length($sufixTranslatorLFDot)=0 and string-length($sufixCompilerLFDot)>0">
														<xsl:value-of select="$sufixCompilerLFDot"/>
													</xsl:if>
												</xsl:variable>

												<xsl:value-of select="$lfAuthor"/>
												
												<xsl:if test="string-length($titleDot)>0 and string-length($publicationTitleDot)>0">
													<xsl:if test="string-length($lfAuthor)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:call-template name="templ_prop_OpenQuote"/>
													<xsl:value-of select="$titleDot"/>
													<xsl:call-template name="templ_prop_CloseQuote"/>
												</xsl:if>

												<xsl:if test="string-length($titleDot)>0 and string-length($publicationTitleDot)=0">
													<xsl:if test="string-length($lfAuthor)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>
			
											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
													<xsl:value-of select="$titleDot"/>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>

												<xsl:if test="string-length($publicationTitleDot)>0">
													<xsl:if test="string-length($lfAuthor)>0 or string-length($titleDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
													<xsl:value-of select="$publicationTitleDot"/>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>

												<xsl:if test="string-length($editionDot)>0">
													<xsl:if test="string-length($lfAuthor)>0 or string-length($titleDot)>0 or string-length($publicationTitleDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$editionDot"/>
												</xsl:if>

												<xsl:if test="string-length($prefixVolumeDot)>0">
													<xsl:if test="string-length($lfAuthor)>0 or string-length($titleDot)>0 or string-length($publicationTitleDot)>0 or string-length($editionDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$prefixVolumeDot"/>
												</xsl:if>

												<xsl:if test="string-length($mediumDot)>0">
													<xsl:if test="string-length($lfAuthor)>0 or string-length($titleDot)>0 or string-length($publicationTitleDot)>0 or string-length($editionDot)>0 or string-length($prefixVolumeDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$mediumDot"/>
												</xsl:if>


												<xsl:if test="string-length($authorDot)>0 and string-length($theCPCapLongPrefixEditorDot)>0">
													<xsl:if test="string-length($lfAuthor)>0 or string-length($titleDot)>0 or string-length($publicationTitleDot)>0 or string-length($editionDot)>0 or string-length($prefixVolumeDot)>0 or string-length($mediumDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$theCPCapLongPrefixEditorDot"/>
												</xsl:if>

												<xsl:if test="string-length($theCapLongPrefixTranslatorDot)>0 and (string-length($authorDot)>0 or (string-length($authorDot)=0 and  string-length($sufixEditorLFDot)>0 ))">
													<xsl:if test="string-length($lfAuthor)>0 or string-length($titleDot)>0 or string-length($publicationTitleDot)>0 or string-length($editionDot)>0 or string-length($prefixVolumeDot)>0 or string-length($mediumDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$theCapLongPrefixTranslatorDot"/>
												</xsl:if>
												
												<xsl:if test="string-length($prefixCompilerDot)>0 and (string-length($authorDot)>0 or (string-length($authorDot)=0 and  (string-length($sufixEditorLFDot)>0 or string-length($sufixTranslatorLFDot)>0)))">
													<xsl:if test="string-length($lfAuthor)>0 or string-length($titleDot)>0 or string-length($publicationTitleDot)>0 or string-length($editionDot)>0 or string-length($prefixVolumeDot)>0 or string-length($mediumDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$prefixCompilerDot"/>
												</xsl:if>
												
												<xsl:if test="string-length($prefixProdDot)>0">
													<xsl:if test="string-length($lfAuthor)>0 or string-length($titleDot)>0 or string-length($publicationTitleDot)>0 or string-length($editionDot)>0 or string-length($prefixVolumeDot)>0 or string-length($mediumDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$prefixProdDot"/>
												</xsl:if>

												<xsl:if test="string-length($tempCPD)>0">
													<xsl:if test="string-length($lfAuthor)>0 or string-length($titleDot)>0 or string-length($publicationTitleDot)>0 or string-length($editionDot)>0 or string-length($prefixVolumeDot)>0 or string-length($mediumDot)>0 or string-length($prefixProdDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$tempCPD"/>
												</xsl:if>



									</xsl:when>


									<xsl:when test="b:SourceType='ArticleInAPeriodical'">


												<xsl:if test="string-length($theAuthorSufixDot)>0">
													<xsl:value-of select="$theAuthorSufixDot"/>
												</xsl:if>

												<xsl:if test="string-length($periodicalTitle)>0 and string-length($theAuthorSufixDot) = 0">
											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
														<xsl:value-of select="$periodicalTitleDot"/>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>
												
												<xsl:if test="string-length($titleDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($periodicalTitle)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:call-template name="templ_prop_OpenQuote"/>
													
													<xsl:value-of select="$titleDot"/>
													
													<xsl:call-template name="templ_prop_CloseQuote"/>
												</xsl:if>

												<xsl:if test="string-length($periodicalTitle)>0 and string-length($theAuthorSufixDot)>0">
													<xsl:if test="string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
													<xsl:if test="string-length($tempDEP)>0">
														<xsl:value-of select="$periodicalTitle"/>
													</xsl:if>
													<xsl:if test="string-length($tempDEP)=0">
														<xsl:value-of select="$periodicalTitleDot"/>
													</xsl:if>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>

												<xsl:if test="string-length($tempDEP)>0">
													<xsl:choose>
														<xsl:when test="string-length($theAuthorSufixDot)>0 and string-length($periodicalTitle)>0">
															<xsl:call-template name="templ_prop_ListSeparator"/>
														</xsl:when>
														<xsl:when test="((string-length($theAuthorSufixDot)>0 or string-length($titleDot)>0) and string-length($periodicalTitle)=0) or (string-length($theAuthorSufixDot)=0 and string-length($titleDot)>0)">
															<xsl:call-template name="templ_prop_Space"/>
														</xsl:when>
													</xsl:choose>
	
													<xsl:value-of select="$tempDEP"/>
												</xsl:if>

									</xsl:when>


									<xsl:when test="b:SourceType='Film'">
									
												<xsl:if test="string-length($writerDot)>0">
													<xsl:value-of select="$writerLFDot"/>
												</xsl:if>

												<xsl:if test="string-length($titleDot)>0">
													<xsl:if test="string-length($writerDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>
											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
													<xsl:value-of select="$titleDot"/>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>
									
												<xsl:if test="string-length($mediumDot)>0">
													<xsl:if test="string-length($titleDot)>0 or string-length($writerDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>
													
													<xsl:value-of select="$mediumDot"/>
												</xsl:if>

												<xsl:if test="string-length($theCapLongPrefixDirectedByDot)>0">
													<xsl:if test="string-length($titleDot)>0 or string-length($writerDot)>0 or string-length($mediumDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$theCapLongPrefixDirectedByDot"/>
												</xsl:if>

												<xsl:if test="string-length($theCapLongPrefixProducedByDot)>0">
													<xsl:if test="string-length($titleDot)>0 or string-length($writerDot)>0 or string-length($theCapLongPrefixDirectedByDot)>0 or string-length($mediumDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$theCapLongPrefixProducedByDot"/>
												</xsl:if>

												<xsl:if test="string-length($theCapLongPrefixPerformedByDot)>0">
													<xsl:if test="string-length($titleDot)>0 or string-length($writerDot)>0 or string-length($theCapLongPrefixDirectedByDot)>0 or string-length($theCapLongPrefixProducedByDot)>0 or string-length($mediumDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$theCapLongPrefixPerformedByDot"/>
												</xsl:if>

												<xsl:if test="string-length($tempDY)>0">
													<xsl:if test="string-length($titleDot)>0 or string-length($writerDot)>0 or string-length($theCapLongPrefixDirectedByDot)>0 or string-length($theCapLongPrefixProducedByDot)>0 or string-length($theCapLongPrefixPerformedByDot)>0 or string-length($mediumDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
													</xsl:if>

													<xsl:value-of select="$tempDY"/>
												</xsl:if>
									
									</xsl:when>


									<xsl:when test="b:SourceType='Interview'">

										<xsl:choose>
										
											<xsl:when test="string-length($broadcaster)>0">

												<xsl:if test="string-length($intervieweeLFDot)>0">
						        	                <xsl:if test="string-length($interviewerDot)=0">
														<xsl:value-of select="$intervieweeLFDot"/>
													</xsl:if>
						        	                <xsl:if test="string-length($interviewerDot)>0">
														<xsl:value-of select="$intervieweeLF"/>
													</xsl:if>
												</xsl:if>

						                        <xsl:if test="string-length($interviewerDot)>0">
													<xsl:if test="string-length($intervieweeLFDot)>0">
														<xsl:call-template name="templ_prop_ListSeparator"/>
													</xsl:if>

													<xsl:call-template name="StringFormatDot">
	  													<xsl:with-param name="format">
															<xsl:if test="string-length($intervieweeLFDot)>0">
										                    	<xsl:call-template name="templ_str_InterviewByUnCap"/>
															</xsl:if>
															<xsl:if test="string-length($intervieweeLFDot)=0">
										                    	<xsl:call-template name="templ_str_InterviewByCap"/>
															</xsl:if>
	  													</xsl:with-param>
	  													<xsl:with-param name="parameters">
	  														<t:params>
	  															<t:param>
																	<xsl:value-of select="$interviewer"/>
																</t:param>
	  														</t:params>
	  													</xsl:with-param>
													</xsl:call-template>
												</xsl:if>
												
												<xsl:if test="string-length($interviewTitle)>0">
						                        	<xsl:if test="string-length($interviewerDot)>0 or string-length($intervieweeLFDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
						                        	</xsl:if>

													<xsl:if test="string-length($broadcastTitleDot)>0">
														<xsl:if test="string-length($intervieweeLFDot)>0">
															<xsl:call-template name="templ_prop_Space"/>
														</xsl:if>

														<xsl:call-template name="templ_prop_OpenQuote"/>
														<xsl:value-of select="$interviewTitleDot"/>
														<xsl:call-template name="templ_prop_CloseQuote"/>
													</xsl:if>


													<xsl:if test="string-length($broadcastTitleDot)=0">
														<xsl:if test="string-length($intervieweeLFDot)>0 or string-length($broadcastTitleDot)>0">
															<xsl:call-template name="templ_prop_Space"/>
														</xsl:if>

												        <xsl:call-template name = "ApplyItalicTitleNS">
												         <xsl:with-param name = "data">
														<xsl:value-of select="$interviewTitle"/>
											             </xsl:with-param>
											            </xsl:call-template>
													</xsl:if>
												</xsl:if>

												<xsl:if test="string-length($broadcastTitleDot)>0">
						                        	<xsl:if test="string-length($interviewerDot)>0 or string-length($intervieweeLFDot)>0 or string-length($interviewTitle)>0">
														<xsl:call-template name="templ_prop_Space"/>
						                        	</xsl:if>

											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
													<xsl:value-of select="$broadcastTitleDot"/>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>

												<xsl:if test="string-length($broadcasterDot)>0">
						                        	<xsl:if test="string-length($interviewerDot)>0 or string-length($intervieweeLFDot)>0 or string-length($interviewTitle)>0 or string-length($broadcastTitleDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
						                        	</xsl:if>
													<xsl:value-of select="$broadcasterDot"/>
												</xsl:if>

												<xsl:if test="string-length($tempSC)>0">
						                        	<xsl:if test="string-length($interviewerDot)>0 or string-length($intervieweeLFDot)>0 or string-length($interviewTitle)>0 or string-length($broadcastTitleDot)>0 or string-length($broadcasterDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
						                        	</xsl:if>
													<xsl:value-of select="$tempSC"/>
												</xsl:if>

												<xsl:if test="string-length($dateDot)>0">
						                        	<xsl:if test="string-length($interviewerDot)>0 or string-length($intervieweeLFDot)>0 or string-length($interviewTitle)>0 or string-length($broadcastTitleDot)>0 or string-length($broadcasterDot)>0 or string-length($tempSC)>0">
														<xsl:call-template name="templ_prop_Space"/>
						                        	</xsl:if>
													<xsl:value-of select="$dateDot"/>
												</xsl:if>
											
											</xsl:when>
											
											
											<xsl:otherwise>
											
												<xsl:if test="string-length($intervieweeLFDot)>0">
						        	                <xsl:if test="string-length($interviewerDot)=0">
														<xsl:value-of select="$intervieweeLFDot"/>
													</xsl:if>
						        	                <xsl:if test="string-length($interviewerDot)>0">
														<xsl:value-of select="$intervieweeLF"/>
													</xsl:if>
												</xsl:if>

												
                        <xsl:if test="string-length($enclosedDate)>0">
                          <xsl:call-template name="templ_prop_Space"/>
                          <xsl:value-of select="$enclosedDate"/>
                        </xsl:if>

			<xsl:call-template name="templ_prop_Space"/>
			
						                        <xsl:if test="string-length($interviewerDot)>0">
													<xsl:if test="string-length($intervieweeLFDot)>0">
														<xsl:call-template name="templ_prop_ListSeparator"/>
													</xsl:if>
													
													<xsl:call-template name="StringFormatDot">
	  													<xsl:with-param name="format">
															<xsl:if test="string-length($intervieweeLFDot)>0">
										                    	<xsl:call-template name="templ_str_InterviewByUnCap"/>
															</xsl:if>
															<xsl:if test="string-length($intervieweeLFDot)=0">
										                    	<xsl:call-template name="templ_str_InterviewByCap"/>
															</xsl:if>
	  													</xsl:with-param>
	  													<xsl:with-param name="parameters">
	  														<t:params>
	  															<t:param>
																	<xsl:value-of select="$interviewer"/>
																</t:param>
	  														</t:params>
	  													</xsl:with-param>
													</xsl:call-template>
												</xsl:if>

												<xsl:if test="string-length($interviewTitle)>0">

						                        	<xsl:if test="string-length($interviewerDot)>0 or string-length($intervieweeLFDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
						                        	</xsl:if>

													<xsl:if test="string-length($broadcastTitleDot)>0">
														<xsl:if test="string-length($intervieweeLFDot)>0">
															<xsl:call-template name="templ_prop_Space"/>
														</xsl:if>

														<xsl:call-template name="templ_prop_OpenQuote"/>
														<xsl:value-of select="$interviewTitleDot"/>
														<xsl:call-template name="templ_prop_CloseQuote"/>
													</xsl:if>


													<xsl:if test="string-length($broadcastTitleDot)=0">
														<xsl:if test="string-length($intervieweeLFDot)>0 or string-length($broadcastTitleDot)>0">
															<xsl:call-template name="templ_prop_Space"/>
														</xsl:if>

												        <xsl:call-template name = "ApplyItalicTitleNS">
												         <xsl:with-param name = "data">
														<xsl:value-of select="$interviewTitle"/>
	 											         </xsl:with-param>
	 											        </xsl:call-template>
													</xsl:if>
												</xsl:if>

												<xsl:if test="string-length($broadcastTitleDot)>0">
						                        	<xsl:if test="string-length($interviewerDot)>0 or string-length($intervieweeLFDot)>0 or string-length($interviewTitle)>0">
														<xsl:call-template name="templ_prop_Space"/>
						                        	</xsl:if>
													
											        <xsl:call-template name = "ApplyItalicTitleNS">
											         <xsl:with-param name = "data">
													<xsl:if test="string-length($editor)>0 or string-length($translator)>0">
														<xsl:value-of select="$broadcastTitle"/>
													</xsl:if>
													<xsl:if test="string-length($editor)=0 and string-length($translator)=0">
														<xsl:value-of select="$broadcastTitleDot"/>
													</xsl:if>
											         </xsl:with-param>
											        </xsl:call-template>
												</xsl:if>


												<xsl:if test="string-length($theCapLongPrefixEditedByDot)>0">
													<xsl:if test="string-length($broadcastTitleDot)>0">
														<xsl:call-template name="templ_prop_ListSeparator"/>
														<xsl:if test="string-length($theCapLongPrefixTranslatedByDot)>0">
															<xsl:value-of select="$theUnCapLongPrefixEditedBy"/>
														</xsl:if>
														<xsl:if test="string-length($theCapLongPrefixTranslatedByDot)=0">
															<xsl:value-of select="$theUnCapLongPrefixEditedByDot"/>
														</xsl:if>
													</xsl:if>
													<xsl:if test="string-length($broadcastTitleDot)=0">
														<xsl:if test="string-length($theCapLongPrefixTranslatedByDot)>0">
															<xsl:value-of select="$theCapLongPrefixEditedBy"/>
														</xsl:if>
														<xsl:if test="string-length($theCapLongPrefixTranslatedByDot)=0">
															<xsl:value-of select="$theCapLongPrefixEditedByDot"/>
														</xsl:if>
													</xsl:if>
												</xsl:if>

												<xsl:if test="string-length($theCapLongPrefixTranslatedByDot)>0">
													<xsl:if test="string-length($broadcastTitleDot)>0 or string-length($theCapLongPrefixEditedByDot)>0">
														<xsl:call-template name="templ_prop_ListSeparator"/>
														<xsl:value-of select="$theUnCapLongPrefixTranslatedByDot"/>
													</xsl:if>
													<xsl:if test="string-length($broadcastTitleDot)=0 and string-length($theCapLongPrefixEditedByDot)=0">
														<xsl:value-of select="$theCapLongPrefixTranslatedByDot"/>
													</xsl:if>
												</xsl:if>

												<xsl:if test="string-length($tempCPDMY)>0">
						                        	<xsl:if test="string-length($interviewerDot)>0 or string-length($intervieweeLFDot)>0 or string-length($interviewTitle)>0 or string-length($broadcastTitleDot)>0 or string-length($theCapLongPrefixTranslatedByDot)>0 or string-length($theCapLongPrefixEditedByDot)>0">
														<xsl:call-template name="templ_prop_Space"/>
						                        	</xsl:if>

													<xsl:value-of select="$tempCPDMY"/>
												</xsl:if>
											</xsl:otherwise>
										</xsl:choose>
										

									</xsl:when>


									



									
								</xsl:choose>
							</xsl:element>
						</xsl:for-each>
					</body>
				</html>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="sortedList">
		<xsl:param name="sourceRoot"/>	
		<xsl:apply-templates select="msxsl:node-set($sourceRoot)/*">	
			<xsl:sort select="b:SortingString" />				
		</xsl:apply-templates>	
	</xsl:template>

	
	<xsl:template match="*">
	
		<xsl:element name="{name()}" namespace="{namespace-uri()}">
			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}" namespace="{namespace-uri()}">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:for-each>
			<xsl:apply-templates>
				<xsl:sort select="b:SortingString" />				
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template name="formatMainAuthor">
		<xsl:call-template name="formatNameCore">
			<xsl:with-param name="FML"><xsl:call-template name="templ_prop_Chicago_MainAuthor_FML"/></xsl:with-param>
			<xsl:with-param name="FM"><xsl:call-template name="templ_prop_Chicago_MainAuthor_FM"/></xsl:with-param>
			<xsl:with-param name="ML"><xsl:call-template name="templ_prop_Chicago_MainAuthor_ML"/></xsl:with-param>
			<xsl:with-param name="FL"><xsl:call-template name="templ_prop_Chicago_MainAuthor_FL"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	
	<xsl:template name="formatSecondaryName">
		<xsl:call-template name="formatNameCore">
			<xsl:with-param name="FML"><xsl:call-template name="templ_prop_Chicago_SecondaryAuthors_FML"/></xsl:with-param>
			<xsl:with-param name="FM"><xsl:call-template name="templ_prop_Chicago_SecondaryAuthors_FM"/></xsl:with-param>
			<xsl:with-param name="ML"><xsl:call-template name="templ_prop_Chicago_SecondaryAuthors_ML"/></xsl:with-param>
			<xsl:with-param name="FL"><xsl:call-template name="templ_prop_Chicago_SecondaryAuthors_FL"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>


	<xsl:template name="formatOtherAuthors">
		<xsl:call-template name="formatNameCore">
			<xsl:with-param name="FML"><xsl:call-template name="templ_prop_Chicago_OtherAuthors_FML"/></xsl:with-param>
			<xsl:with-param name="FM"><xsl:call-template name="templ_prop_Chicago_OtherAuthors_FM"/></xsl:with-param>
			<xsl:with-param name="ML"><xsl:call-template name="templ_prop_Chicago_OtherAuthors_ML"/></xsl:with-param>
			<xsl:with-param name="FL"><xsl:call-template name="templ_prop_Chicago_OtherAuthors_FL"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template>


	<xsl:template name="formatPersonSeperator">

		<xsl:choose>
			<xsl:when test="count(../b:Person) > 6 and position() = 1">
        <xsl:variable name="noCommaBeforeAnd">
          <xsl:call-template name="templ_prop_NoCommaBeforeAnd" />
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$noCommaBeforeAnd != 'yes'">
            <xsl:call-template name="templ_prop_ListSeparator"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="templ_prop_Space"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="templ_str_AndOthersUnCap"/>
			</xsl:when>
			<xsl:when test="count(../b:Person) > 6 and position() >= 2">
			</xsl:when>
			<xsl:when test="6 >= count(../b:Person) and position() = count(../b:Person) - 1">
        <xsl:variable name="noCommaBeforeAnd">
          <xsl:call-template name="templ_prop_NoCommaBeforeAnd" />
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$noCommaBeforeAnd != 'yes'">
            <xsl:call-template name="templ_prop_ListSeparator"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="templ_prop_Space"/>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:variable name="noAndBeforeLastAuthor">
			        <xsl:call-template name="templ_prop_NoAndBeforeLastAuthor"/>
				</xsl:variable>
		        <xsl:if test="$noAndBeforeLastAuthor != 'yes'">
			        <xsl:call-template name="templ_str_AndUnCap"/>
			        <xsl:call-template name="templ_prop_Space"/>
		        </xsl:if>
			</xsl:when>
			<xsl:when test="position() = count(../b:Person)">
				<xsl:text></xsl:text>
			</xsl:when>
			<xsl:when test="6 > position()">
				<xsl:call-template name="templ_prop_ListSeparator"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="formatPersonSeperator2">

		<xsl:choose>
			<xsl:when test="count(../b:Person) > 6 and position() = 1">
        <xsl:variable name="noCommaBeforeAnd">
          <xsl:call-template name="templ_prop_NoCommaBeforeAnd" />
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$noCommaBeforeAnd != 'yes'">
            <xsl:call-template name="templ_prop_ListSeparator"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="templ_prop_Space"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="templ_str_AndOthersUnCap"/>
			</xsl:when>
			<xsl:when test="count(../b:Person) > 6 and position() >= 2">
			</xsl:when>
			<xsl:when test="6 >= count(../b:Person) and position() = count(../b:Person) - 1">
				<xsl:variable name="noAndBeforeLastAuthor">
			        <xsl:call-template name="templ_prop_NoAndBeforeLastAuthor"/>
				</xsl:variable>

		        <xsl:if test="$noAndBeforeLastAuthor != 'yes'">
					<xsl:call-template name="templ_prop_Space"/>
			        <xsl:call-template name="templ_str_AndUnCap"/>
			        <xsl:call-template name="templ_prop_Space"/>
			    </xsl:if>
		        <xsl:if test="$noAndBeforeLastAuthor = 'yes'">
			        <xsl:call-template name="templ_prop_AuthorsSeparator"/>
		        </xsl:if>
			</xsl:when>
			<xsl:when test="position() = count(../b:Person)">
				<xsl:text></xsl:text>
			</xsl:when>
			<xsl:when test="6 > position()">
				<xsl:call-template name="templ_prop_ListSeparator"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="formatPersonsAuthor">
		<xsl:if test="string-length(b:Corporate)=0">
			<xsl:for-each select="b:NameList/b:Person">
				<xsl:if test="position() = 1">
					<xsl:call-template name="formatMainAuthor"/>
				</xsl:if>
				<xsl:if test="6 >= count(../b:Person) and 6 >= position() and position() != 1">
					<xsl:call-template name="formatOtherAuthors"/>
				</xsl:if>
				<xsl:call-template name="formatPersonSeperator"/>
			</xsl:for-each>
		</xsl:if>

		<xsl:if test="string-length(b:Corporate)>0">
			<xsl:value-of select="b:Corporate"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="formatPersons">
		<xsl:if test="string-length(b:Corporate)=0">
			<xsl:for-each select="b:NameList/b:Person">
				<xsl:if test="(count(../b:Person) > 6 and 1 = position()) or (6 >= count(../b:Person))">
					<xsl:call-template name="formatSecondaryName"/>
				</xsl:if>
				<xsl:call-template name="formatPersonSeperator2"/>
			</xsl:for-each>
		</xsl:if>

		<xsl:if test="string-length(b:Corporate)>0">
			<xsl:value-of select="b:Corporate"/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="formatAuthor">
		<xsl:for-each select="b:Author/b:Author">
			<xsl:call-template name="formatPersonsAuthor"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="formatMain">
		<xsl:for-each select="b:Author/b:Main">
			<xsl:call-template name="formatPersonsAuthor"/>
		</xsl:for-each>
	</xsl:template>


	<xsl:template name="formatBookAuthor">
		<xsl:for-each select="b:Author/b:BookAuthor">
			<xsl:call-template name="formatPersons"/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="formatEditorLF">
		<xsl:for-each select="b:Author/b:Editor">
			<xsl:call-template name="formatPersonsAuthor"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="formatTranslatorLF">
		<xsl:for-each select="b:Author/b:Translator">
			<xsl:call-template name="formatPersonsAuthor"/>
		</xsl:for-each>
	</xsl:template>


	<xsl:template name="formatPerformerLF">
		<xsl:for-each select="b:Author/b:Performer">
			<xsl:call-template name="formatPersonsAuthor"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="formatConductorLF">
		<xsl:for-each select="b:Author/b:Conductor">
			<xsl:call-template name="formatPersonsAuthor"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="formatComposerLF">
		<xsl:for-each select="b:Author/b:Composer">
			<xsl:call-template name="formatPersonsAuthor"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="formatArtistLF">
		<xsl:for-each select="b:Author/b:Artist">
			<xsl:call-template name="formatPersonsAuthor"/>
		</xsl:for-each>
	</xsl:template>


	<xsl:template name="formatInventorLF">
		<xsl:for-each select="b:Author/b:Inventor">
			<xsl:call-template name="formatPersonsAuthor"/>
		</xsl:for-each>
	</xsl:template>


	<xsl:template name="formatIntervieweeLF">
		<xsl:for-each select="b:Author/b:Interviewee">
			<xsl:call-template name="formatPersonsAuthor"/>
		</xsl:for-each>
	</xsl:template>


	<xsl:template name="formatInterviewerLF">
		<xsl:for-each select="b:Author/b:Interviewer">
			<xsl:call-template name="formatPersonsAuthor"/>
		</xsl:for-each>
	</xsl:template>


	<xsl:template name="formatCompilerLF">
		<xsl:for-each select="b:Author/b:Compiler">
			<xsl:call-template name="formatPersonsAuthor"/>
		</xsl:for-each>
	</xsl:template>


	<xsl:template name="formatWriterLF">
		<xsl:for-each select="b:Author/b:Writer">
			<xsl:call-template name="formatPersonsAuthor"/>
		</xsl:for-each>
	</xsl:template>










	<xsl:template name="formatEditor">
		<xsl:for-each select="b:Author/b:Editor">
			<xsl:call-template name="formatPersons"/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="formatTranslator">
		<xsl:for-each select="b:Author/b:Translator">
			<xsl:call-template name="formatPersons"/>
		</xsl:for-each>
	</xsl:template>
	

	<xsl:template name="formatPerformer">
		<xsl:for-each select="b:Author/b:Performer">
			<xsl:call-template name="formatPersons"/>
		</xsl:for-each>
	</xsl:template>
	
	

	<xsl:template name="formatConductor">
		<xsl:for-each select="b:Author/b:Conductor">
			<xsl:call-template name="formatPersons"/>
		</xsl:for-each>
	</xsl:template>
	

	<xsl:template name="formatComposer">
		<xsl:for-each select="b:Author/b:Composer">
			<xsl:call-template name="formatPersons"/>
		</xsl:for-each>
	</xsl:template>		
	
	<xsl:template name="formatInterviewer">
		<xsl:for-each select="b:Author/b:Interviewer">
			<xsl:call-template name="formatPersons"/>
		</xsl:for-each>
	</xsl:template>		
	

	<xsl:template name="formatWriter">
		<xsl:for-each select="b:Author/b:Writer">
			<xsl:call-template name="formatPersons"/>
		</xsl:for-each>
	</xsl:template>
	

	<xsl:template name="formatDirector">
		<xsl:for-each select="b:Author/b:Director">
			<xsl:call-template name="formatPersons"/>
		</xsl:for-each>
	</xsl:template>		
	
	<xsl:template name="formatProducerName">
		<xsl:for-each select="b:Author/b:ProducerName">
			<xsl:call-template name="formatPersons"/>
		</xsl:for-each>
	</xsl:template>		

	<xsl:template name="formatCompiler">
		<xsl:for-each select="b:Author/b:Compiler">
			<xsl:call-template name="formatPersons"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="formatDate">
		<xsl:param name="appendSpace"/>
		<xsl:call-template name="formatDateCore">
			<xsl:with-param name="day">
				<xsl:call-template name="handleSpaces">
					<xsl:with-param name="field" select="b:Day"/>
				</xsl:call-template>
			</xsl:with-param>

			<xsl:with-param name="month">
				<xsl:call-template name="handleSpaces">
					<xsl:with-param name="field" select="b:Month"/>
				</xsl:call-template>
			</xsl:with-param>

			<xsl:with-param name="year">
				<xsl:call-template name="handleSpaces">
					<xsl:with-param name="field" select="b:Year"/>
				</xsl:call-template>
			</xsl:with-param>

			<xsl:with-param name="DMY"><xsl:call-template name="templ_prop_Chicago_Date_DMY"/></xsl:with-param>
			<xsl:with-param name="DM"><xsl:call-template name="templ_prop_Chicago_Date_DM"/></xsl:with-param>
			<xsl:with-param name="MY"><xsl:call-template name="templ_prop_Chicago_Date_MY"/></xsl:with-param>
			<xsl:with-param name="DY"><xsl:call-template name="templ_prop_Chicago_Date_DY"/></xsl:with-param>

			<xsl:with-param name="displayND">yes</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="formatDateAccessed">
		<xsl:call-template name="formatDateCore">
			<xsl:with-param name="day">
				<xsl:call-template name="handleSpaces">
					<xsl:with-param name="field" select="b:DayAccessed"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="month">
				<xsl:call-template name="handleSpaces">
					<xsl:with-param name="field" select="b:MonthAccessed"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="year">
				<xsl:call-template name="handleSpaces">
					<xsl:with-param name="field" select="b:YearAccessed"/>
				</xsl:call-template>
			</xsl:with-param>
			
			<xsl:with-param name="DMY"><xsl:call-template name="templ_prop_APA_DateAccessed_DMY"/></xsl:with-param>
			<xsl:with-param name="DM"><xsl:call-template name="templ_prop_APA_DateAccessed_DM"/></xsl:with-param>
			<xsl:with-param name="MY"><xsl:call-template name="templ_prop_APA_DateAccessed_MY"/></xsl:with-param>
			<xsl:with-param name="DY"><xsl:call-template name="templ_prop_APA_DateAccessed_DY"/></xsl:with-param>

			<xsl:with-param name="displayND">no</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	
		
		
		
		
	<xsl:template name="MainContributors">
		<xsl:param name="SourceRoot"/>
		<xsl:choose>
			<xsl:when test="./b:SourceType='Book'">
				<xsl:choose>
					<xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
					<xsl:when test="string-length(./b:Author/b:Editor)>0">Editor</xsl:when>
					<xsl:when test="string-length(./b:Author/b:Translator)>0">Translator</xsl:when>
				</xsl:choose>
			</xsl:when>
			
			<xsl:when test="./b:SourceType='BookSection'">
				<xsl:choose>
					<xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
					<xsl:when test="string-length(./b:Author/b:BookAuthor)>0">BookAuthor</xsl:when>
				</xsl:choose>
			</xsl:when>
			
			<xsl:when test="./b:SourceType='JournalArticle'">
				<xsl:choose>
					<xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
					<xsl:when test="string-length(./b:Author/b:Editor)>0">Editor</xsl:when>
				</xsl:choose>
			</xsl:when>
			
			<xsl:when test="./b:SourceType='ArticleInAPeriodical'">
				<xsl:choose>
					<xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
					<xsl:when test="string-length(./b:Author/b:Editor)>0">Editor</xsl:when>
				</xsl:choose>
			</xsl:when>
			
			<xsl:when test="./b:SourceType='ConferenceProceedings'">
				<xsl:choose>
					<xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
				</xsl:choose>
			</xsl:when>
			
			<xsl:when test="./b:SourceType='Report'">
				<xsl:choose>
					<xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
				</xsl:choose>
			</xsl:when>
			
			<xsl:when test="./b:SourceType='SoundRecording'">
				<xsl:choose>
					<xsl:when test="string-length(./b:Author/b:Performer)>0">Performer</xsl:when>
					<xsl:when test="string-length(./b:Author/b:Conductor)>0">Conductor</xsl:when>
					<xsl:when test="string-length(./b:Author/b:Composer)>0">Composer</xsl:when>
					<xsl:when test="string-length(./b:Author/b:Artist)>0">Artist</xsl:when>
				</xsl:choose>
			</xsl:when>
						
			<xsl:when test="./b:SourceType='Performance'">
				<xsl:choose>
					<xsl:when test="string-length(./b:Author/b:Writer)>0">Writer</xsl:when>
					<xsl:when test="string-length(./b:Author/b:Performer)>0">Performer</xsl:when>
					<xsl:when test="string-length(./b:Author/b:Director)>0">Director</xsl:when>
				</xsl:choose>
			</xsl:when>
						
			<xsl:when test="./b:SourceType='Art'">
				<xsl:choose>
					<xsl:when test="string-length(./b:Author/b:Artist)>0">Artist</xsl:when>
				</xsl:choose>
			</xsl:when>
									
			<xsl:when test="./b:SourceType='DocumentFromInternetSite'">
				<xsl:choose>
					<xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
				</xsl:choose>
			</xsl:when>
									
			<xsl:when test="./b:SourceType='InternetSite'">
				<xsl:choose>
					<xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
				</xsl:choose>
			</xsl:when>
									
			<xsl:when test="./b:SourceType='Film'">
				<xsl:choose>
					<xsl:when test="string-length(./b:Author/b:Writer)>0">Writer</xsl:when>
					<xsl:when test="string-length(./b:Author/b:Performer)>0">Performer</xsl:when>
					<xsl:when test="string-length(./b:Author/b:Director)>0">Director</xsl:when>
				</xsl:choose>
			</xsl:when>
									
			<xsl:when test="./b:SourceType='Interview'">
				<xsl:choose>
					<xsl:when test="string-length(./b:Author/b:Interviewee)>0">Interviewee</xsl:when>
					<xsl:when test="string-length(./b:Author/b:Editor)>0">Editor</xsl:when>
					<xsl:when test="string-length(./b:Author/b:Translator)>0">Translator</xsl:when>
				</xsl:choose>
			</xsl:when>
									
			<xsl:when test="./b:SourceType='Patent'">
				<xsl:choose>
					<xsl:when test="string-length(./b:Author/b:Inventor)>0">Inventor</xsl:when>
					<xsl:when test="string-length(./b:Author/b:Editor)>0">Editor</xsl:when>
					<xsl:when test="string-length(./b:Author/b:Translator)>0">Translator</xsl:when>
				</xsl:choose>
			</xsl:when>
									
			<xsl:when test="./b:SourceType='ElectronicSource'">
				<xsl:choose>
					<xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
					<xsl:when test="string-length(./b:Author/b:Editor)>0">Editor</xsl:when>
				</xsl:choose>
			</xsl:when>
									
			<xsl:when test="./b:SourceType='Case'">
				<xsl:choose>
					<xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
				</xsl:choose>
			</xsl:when>
												
			<xsl:when test="./b:SourceType='Misc'">
				<xsl:choose>
					<xsl:when test="string-length(./b:Author/b:Author)>0">Author</xsl:when>
					<xsl:when test="string-length(./b:Author/b:Editor)>0">Editor</xsl:when>
					<xsl:when test="string-length(./b:Author/b:Compiler)>0">Compiler</xsl:when>
					<xsl:when test="string-length(./b:Author/b:Translator)>0">Translator</xsl:when>
				</xsl:choose>
			</xsl:when>	
		</xsl:choose>
	</xsl:template>
	
	
	
	<xsl:template name="populateMain">
		<xsl:param name="Type"/>	
		<xsl:element name="{$Type}">	
		
		<xsl:for-each select="/*[$Type]/b:Source">		
			<xsl:variable name="MostImportantAuthorLocalName">	
				<xsl:call-template name="MainContributors"/>
			</xsl:variable>
			<xsl:element name="{'b:Source'}">	
        <xsl:if test="$Type='b:Citation'">
          
          <b:Title>
            
            <xsl:if test="string-length(b:Title)>0">
              <xsl:value-of select="b:Title"/>
            </xsl:if>
            
            <xsl:if test="string-length(b:Title)=0">
              <xsl:choose>
                <xsl:when test="b:SourceType='Book' or
                                  b:SourceType='JournalArticle' or
                                  b:SourceType='ConferenceProceedings' or
                                  b:SourceType='Report' or
                                  b:SourceType='Performance' or
                                  b:SourceType='Film' or
                                  b:SourceType='Patent' or
                                  b:SourceType='Case'">

                  <xsl:value-of select="b:ShortTitle"/>
                </xsl:when>

                <xsl:when test="b:SourceType='BookSection'">
                  <xsl:variable name="shortTitle" select="b:ShortTitle"/>
                  <xsl:variable name="bookTitle" select="b:BookTitle"/>

                  <xsl:choose>
                    <xsl:when test="string-length($shortTitle)>0">
                      <xsl:value-of select="$shortTitle"/>
                    </xsl:when>
                    <xsl:when test="string-length($bookTitle)>0">
                      <xsl:value-of select="$bookTitle"/>
                    </xsl:when>
                  </xsl:choose>

                </xsl:when>

                <xsl:when test="b:SourceType='ArticleInAPeriodical'">
                  <xsl:variable name="shortTitle" select="b:ShortTitle"/>
                  <xsl:variable name="periodicalTitle" select="b:PeriodicalTitle"/>

                  <xsl:choose>
                    <xsl:when test="string-length($shortTitle)>0">
                      <xsl:value-of select="$shortTitle"/>
                    </xsl:when>
                    <xsl:when test="string-length($periodicalTitle)>0">
                      <xsl:value-of select="$periodicalTitle"/>
                    </xsl:when>
                  </xsl:choose>
                </xsl:when>

                <xsl:when test="b:SourceType='InternetSite' or
                                  b:SourceType='DocumentFromInternetSite'">
                  <xsl:variable name="shortTitle" select="b:ShortTitle"/>
                  <xsl:variable name="internetSiteTitle" select="b:InternetSiteTitle"/>

                  <xsl:choose>
                    <xsl:when test="string-length($shortTitle)>0">
                      <xsl:value-of select="$shortTitle"/>
                    </xsl:when>
                    <xsl:when test="string-length($internetSiteTitle)>0">
                      <xsl:value-of select="$internetSiteTitle"/>
                    </xsl:when>
                  </xsl:choose>
                </xsl:when>

                <xsl:when test="b:SourceType='ElectronicSource' or
                                  b:SourceType='Art' or
                                  b:SourceType='Misc'">
                  <xsl:variable name="shortTitle" select="b:ShortTitle"/>
                  <xsl:variable name="publicationTitle" select="b:PublicationTitle"/>

                  <xsl:choose>
                    <xsl:when test="string-length($shortTitle)>0">
                      <xsl:value-of select="$shortTitle"/>
                    </xsl:when>
                    <xsl:when test="string-length($publicationTitle)>0">
                      <xsl:value-of select="$publicationTitle"/>
                    </xsl:when>
                  </xsl:choose>
                </xsl:when>

                <xsl:when test="b:SourceType='SoundRecording'">
                  <xsl:variable name="shortTitle" select="b:ShortTitle"/>
                  <xsl:variable name="albumTitle" select="b:AlbumTitle"/>

                  <xsl:choose>
                    <xsl:when test="string-length($shortTitle)>0">
                      <xsl:value-of select="$shortTitle"/>
                    </xsl:when>
                    <xsl:when test="string-length($albumTitle)>0">
                      <xsl:value-of select="$albumTitle"/>
                    </xsl:when>
                  </xsl:choose>
                </xsl:when>

                <xsl:when test="b:SourceType='Interview'">
                  <xsl:variable name="shortTitle" select="b:ShortTitle"/>
                  
                  <xsl:variable name="broadcastTitle" select="b:BroadcastTitle"/>
                  

                  <xsl:choose>
                    <xsl:when test="string-length($shortTitle)>0">
                      <xsl:value-of select="$shortTitle"/>
                    </xsl:when>
                    
                    <xsl:when test="string-length($broadcastTitle)>0">
                      <xsl:value-of select="$broadcastTitle"/>
                    </xsl:when>
                    
                  </xsl:choose>
                </xsl:when>

              </xsl:choose>
            </xsl:if>
          </b:Title>
        </xsl:if>
        <b:SortingString>
        
		          	<xsl:variable name = "author0">
					  <xsl:for-each select="./b:Author/*[local-name()=$MostImportantAuthorLocalName]">
					    <xsl:call-template name="formatPersonsAuthor"/>
					  </xsl:for-each>
					</xsl:variable>

		          	<xsl:variable name = "author">
			    		<xsl:choose>
							<xsl:when test="string-length(./b:Author/*[local-name()=$MostImportantAuthorLocalName]/b:Corporate) > 0">
					            <xsl:value-of select="./b:Author/*[local-name()=$MostImportantAuthorLocalName]/b:Corporate"/>
					        </xsl:when>
							<xsl:when test="string-length($author0) > 0">
					            <xsl:value-of select="$author0"/>
					        </xsl:when>
			    		</xsl:choose>
			    	</xsl:variable>

					<xsl:if test="string-length($author) > 0 and b:SourceType != 'Case'">
			            <xsl:text>&#32;</xsl:text>
			            <xsl:value-of select="$author"/>
			        </xsl:if>

					<xsl:if test="string-length(b:PeriodicalTitle) > 0 and b:SourceType = 'ArticleInAPeriodical'">
						<xsl:text>&#32;</xsl:text>
						<xsl:value-of select="b:PeriodicalTitle"/>
			        </xsl:if>

		            <xsl:if test="string-length(b:Title) > 0">
						<xsl:text>&#32;</xsl:text>
						<xsl:value-of select="b:Title"/>
					</xsl:if>
					
					<xsl:variable name="order">	
						<xsl:choose>
							<xsl:when test="$MostImportantAuthorLocalName='Author'"><xsl:text>1</xsl:text></xsl:when>
							<xsl:when test="$MostImportantAuthorLocalName='Editor'"><xsl:text>2</xsl:text></xsl:when>
							<xsl:when test="$MostImportantAuthorLocalName='Compiler'"><xsl:text>3</xsl:text></xsl:when>
							<xsl:when test="$MostImportantAuthorLocalName='Translator'"><xsl:text>4</xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>1</xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:text>&#32;</xsl:text><xsl:value-of select="$order"/>
				</b:SortingString>
				<b:Author>		
					<b:Main>
						<xsl:if test="string-length(./b:Author/*[local-name()=$MostImportantAuthorLocalName]/b:Corporate)=0">
							<b:NameList>
								<xsl:for-each select="./b:Author/*[local-name()=$MostImportantAuthorLocalName]/b:NameList/b:Person">	
									<b:Person>		
										<b:Last><xsl:value-of select="./b:Last"/></b:Last>
										<b:First><xsl:value-of select="./b:First"/></b:First>
										<b:Middle><xsl:value-of select="./b:Middle"/></b:Middle>
									</b:Person>
								</xsl:for-each>
							</b:NameList>
						</xsl:if>
						<xsl:if test="string-length(./b:Author/*[local-name()=$MostImportantAuthorLocalName]/b:Corporate)>0">
							<b:Corporate>
							  <xsl:value-of select="./b:Author/*[local-name()=$MostImportantAuthorLocalName]/b:Corporate"/>
							</b:Corporate>
						</xsl:if>
					</b:Main>
					<xsl:for-each select="./b:Author/*">	
						
							<xsl:element name="{name()}" namespace="{namespace-uri()}">
								<xsl:call-template name="copyNameNodes"/>	
							</xsl:element>
						
					</xsl:for-each>
				</b:Author>
				<xsl:for-each select="*">	
            <xsl:if test="name()!='Author' and not(name()='Title' and $Type='b:Citation')">
              <xsl:element name="{name()}" namespace="{namespace-uri()}">
								<xsl:call-template name="copyNodes"/>	
							</xsl:element>
						</xsl:if>
				</xsl:for-each>
			</xsl:element>
			<xsl:for-each select="../*">	
						<xsl:if test="local-name()!='Source' and namespace-uri()='http://schemas.openxmlformats.org/officeDocument/2006/bibliography'">
							<xsl:element name="{name()}" namespace="{namespace-uri()}">
								<xsl:call-template name="copyNodes"/>	
							</xsl:element>
						</xsl:if>
			</xsl:for-each>
		</xsl:for-each>
		
      <xsl:copy-of select="/*[$Type]/b:Locals"/>
    </xsl:element>
  </xsl:template>

  
	<xsl:template name="copyNameNodes">
		<xsl:if test="string-length(b:Corporate)=0">
			<b:NameList>
				<xsl:for-each select="b:NameList/b:Person">	
					<b:Person>			
							<xsl:if test="string-length(./b:Last)>0">	
							<b:Last>
								<xsl:value-of select="./b:Last"/>
							</b:Last>
						</xsl:if>
						<xsl:if test="string-length(./b:First)>0">
							<b:First>
								<xsl:value-of select="./b:First"/>
							</b:First>
						</xsl:if>
						<xsl:if test="string-length(./b:Middle)>0">
							<b:Middle>
								<xsl:value-of select="./b:Middle"/>
							</b:Middle>
						</xsl:if>
					</b:Person>
				</xsl:for-each>
			</b:NameList>
		</xsl:if>
		<xsl:if test="string-length(b:Corporate)>0">
			<b:Corporate>
			  <xsl:value-of select="b:Corporate"/>
			</b:Corporate>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="copyNodes">
		<xsl:value-of select="."/>

	</xsl:template>

	<xsl:template name="copyNodes2">
			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}" namespace="{namespace-uri()}">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:for-each>
			<xsl:for-each select="*">
				<xsl:element name="{name()}" namespace="{namespace-uri()}">
					<xsl:call-template name="copyNodes2"/>	
				</xsl:element>
			</xsl:for-each>

	</xsl:template>


	<xsl:template name="handleSpaces">
		<xsl:param name="field"/>

    <xsl:variable name="prop_NormalizeSpace">
      <xsl:call-template name="templ_prop_NormalizeSpace"/>
    </xsl:variable>

    <xsl:choose>
			<xsl:when test="$prop_NormalizeSpace='yes'">
				<xsl:value-of select="normalize-space($field)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$field"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	
	<xsl:template name="appendField_Dot">
		<xsl:param name="field"/>
		
		<xsl:variable name="temp">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="$field"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="lastChar">
			<xsl:value-of select="substring($temp, string-length($temp))"/>
		</xsl:variable>

    <xsl:variable name="prop_EndChars">
      <xsl:call-template name="templ_prop_EndChars"/>
    </xsl:variable>

    <xsl:choose>
			<xsl:when test="string-length($temp) = 0">
			</xsl:when>
			<xsl:when test="contains($prop_EndChars, $lastChar)">
				<xsl:value-of select="$temp"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$temp"/>
				<xsl:call-template name="templ_prop_Dot"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template name="need_Dot">
		<xsl:param name="field"/>
		
		<xsl:variable name="temp">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="$field"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="lastChar">
			<xsl:value-of select="substring($temp, string-length($temp))"/>
		</xsl:variable>
    
    <xsl:variable name="prop_EndChars">
      <xsl:call-template name="templ_prop_EndChars"/>
    </xsl:variable>

    <xsl:choose>
			<xsl:when test="string-length($temp) = 0">
			</xsl:when>
			<xsl:when test="contains($prop_EndChars, $lastChar)">
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="templ_prop_Dot"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="appendFieldNoHandleSpaces_Dot">
		<xsl:param name="field"/>
		
		<xsl:variable name="lastChar">
			<xsl:value-of select="substring($field, string-length($field))"/>
		</xsl:variable>
    
    <xsl:variable name="prop_EndChars">
      <xsl:call-template name="templ_prop_EndChars"/>
    </xsl:variable>

    <xsl:choose>
			<xsl:when test="string-length($field) = 0">
			</xsl:when>
			<xsl:when test="contains($prop_EndChars, $lastChar)">
				<xsl:value-of select="$field"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$field"/>
				<xsl:call-template name="templ_prop_Dot"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>


	<xsl:template name="templateA">
		<xsl:param name="first"/>
		<xsl:param name="second"/>
		<xsl:param name="third"/>
		
		<xsl:variable name="tempFirst">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="$first"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="tempSecond">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="$second"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="tempThird">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="$third"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="temp">
			<xsl:if test="string-length($tempFirst)>0">
				<xsl:value-of select="$tempFirst"/>
			</xsl:if>

			<xsl:if test="string-length($tempFirst)>0 and string-length($tempSecond)>0">
				<xsl:call-template name="templ_prop_EnumSeparator"/>
			</xsl:if>

			<xsl:if test="string-length($tempSecond)>0">
				<xsl:value-of select="$tempSecond"/>
			</xsl:if>

			<xsl:if test="(string-length($tempFirst)>0 or string-length($tempSecond)>0) and string-length($tempThird)>0">
				<xsl:call-template name="templ_prop_ListSeparator"/>
			</xsl:if>

			<xsl:if test="string-length($tempThird)>0">
				<xsl:value-of select="$tempThird"/>
			</xsl:if>
		</xsl:variable>

		<xsl:call-template name="appendFieldNoHandleSpaces_Dot">
			<xsl:with-param name="field" select="$temp"/>
		</xsl:call-template>		
	</xsl:template>

	<xsl:template name="templateANoDot">
		<xsl:param name="first"/>
		<xsl:param name="second"/>
		<xsl:param name="third"/>
		
		<xsl:variable name="tempFirst">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="$first"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="tempSecond">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="$second"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="tempThird">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="$third"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:if test="string-length($tempFirst)>0">
			<xsl:value-of select="$tempFirst"/>
		</xsl:if>

		<xsl:if test="string-length($tempFirst)>0 and string-length($tempSecond)>0">
			<xsl:call-template name="templ_prop_EnumSeparator"/>
		</xsl:if>

		<xsl:if test="string-length($tempSecond)>0">
			<xsl:value-of select="$tempSecond"/>
		</xsl:if>

		<xsl:if test="(string-length($tempFirst)>0 or string-length($tempSecond)>0) and string-length($tempThird)>0">
			<xsl:call-template name="templ_prop_ListSeparator"/>
		</xsl:if>

		<xsl:if test="string-length($tempThird)>0">
			<xsl:value-of select="$tempThird"/>
		</xsl:if>

	</xsl:template>

	<xsl:template name="templateB">
		<xsl:param name="first"/>
		<xsl:param name="second"/>
		
		<xsl:variable name="tempFirst">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="$first"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="tempSecond">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="$second"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="temp">
			<xsl:if test="string-length($tempFirst)>0">
				<xsl:value-of select="$tempFirst"/>
			</xsl:if>

			<xsl:if test="string-length($tempFirst)>0 and string-length($tempSecond)>0">
				<xsl:call-template name="templ_prop_EnumSeparator"/>
			</xsl:if>

			<xsl:if test="string-length($tempSecond)>0">
				<xsl:value-of select="$tempSecond"/>
			</xsl:if>

		</xsl:variable>

		<xsl:call-template name="appendFieldNoHandleSpaces_Dot">
			<xsl:with-param name="field" select="$temp"/>
		</xsl:call-template>
		
	</xsl:template>

	<xsl:template name="templateSpaceAB">
		<xsl:param name="first"/>
		<xsl:param name="second"/>
		
		<xsl:variable name="tempFirst">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="$first"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="tempSecond">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="$second"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="temp">
			<xsl:if test="string-length($tempFirst)>0">
				<xsl:value-of select="$tempFirst"/>
			</xsl:if>

			<xsl:if test="string-length($tempFirst)>0 and string-length($tempSecond)>0">
				<xsl:call-template name="templ_prop_Space"/>
			</xsl:if>

			<xsl:if test="string-length($tempSecond)>0">
				<xsl:value-of select="$tempSecond"/>
			</xsl:if>

		</xsl:variable>

		<xsl:call-template name="appendFieldNoHandleSpaces_Dot">
			<xsl:with-param name="field" select="$temp"/>
		</xsl:call-template>
		
	</xsl:template>


	<xsl:template name="templateC">
		<xsl:param name="first"/>
		<xsl:param name="second"/>
		
		<xsl:variable name="tempFirst">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="$first"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="tempSecond">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="$second"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="temp">
			<xsl:if test="string-length($tempFirst)>0">
				<xsl:value-of select="$tempFirst"/>
			</xsl:if>

			<xsl:if test="string-length($tempFirst)>0 and string-length($tempSecond)>0">
				<xsl:call-template name="templ_prop_ListSeparator"/>
			</xsl:if>

			<xsl:if test="string-length($tempSecond)>0">
				<xsl:value-of select="$tempSecond"/>
			</xsl:if>

		</xsl:variable>

		<xsl:call-template name="appendFieldNoHandleSpaces_Dot">
			<xsl:with-param name="field" select="$temp"/>
		</xsl:call-template>
	</xsl:template>


	<xsl:template name="templateE">
		<xsl:param name="first"/>
		<xsl:param name="second"/>
		<xsl:param name="third"/>
		
		<xsl:variable name="tempFirst">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="$first"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="tempSecond">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="$second"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="tempThird">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="$third"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="temp">
			<xsl:if test="string-length($tempFirst)>0">
				<xsl:value-of select="$tempFirst"/>
			</xsl:if>

			<xsl:if test="string-length($tempFirst)>0 and string-length($tempSecond)>0">
				<xsl:call-template name="templ_prop_ListSeparator"/>
			</xsl:if>

			<xsl:if test="string-length($tempSecond)>0">
				<xsl:value-of select="$tempSecond"/>
			</xsl:if>

			<xsl:if test="(string-length($tempFirst)>0 or string-length($tempSecond)>0) and string-length($tempThird)>0">
				<xsl:call-template name="templ_prop_EnumSeparator"/>
			</xsl:if>

			<xsl:if test="string-length($tempThird)>0">
				<xsl:value-of select="$tempThird"/>
			</xsl:if>
		</xsl:variable>

		<xsl:call-template name="appendFieldNoHandleSpaces_Dot">
			<xsl:with-param name="field" select="$temp"/>
		</xsl:call-template>		
	</xsl:template>

	<xsl:template name="templateCityStateProvince">
		<xsl:value-of select="b:City"/>

		<xsl:if test="string-length(b:City)>0 and string-length(b:StateProvince)>0">
			<xsl:call-template name="templ_prop_ListSeparator"/>
		</xsl:if>

		<xsl:value-of select="b:StateProvince"/>
	</xsl:template>

	<xsl:template name="templateCPY">
		<xsl:call-template name="templateA">
			<xsl:with-param name="first">
				<xsl:call-template name="templateCityStateProvince" />
			</xsl:with-param>
			<xsl:with-param name="second" select="b:Publisher"/>
			<xsl:with-param name="third">
				<xsl:call-template name="getYear" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="templateCPYNoDot">
		<xsl:call-template name="templateANoDot">
			<xsl:with-param name="first">
				<xsl:call-template name="templateCityStateProvince" />
			</xsl:with-param>
			<xsl:with-param name="second" select="b:Publisher"/>
			<xsl:with-param name="third">
				<xsl:call-template name="getYear" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="templateDEP">

		<xsl:variable name="date">
			<xsl:call-template name="formatDate"/>
		</xsl:variable>
		
		<xsl:variable name="editionTemp">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="b:Edition"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="edition">
			<xsl:choose>
				<xsl:when test="string-length($editionTemp)>0">
					<xsl:call-template name="StringFormat">
	  					<xsl:with-param name="format">
							<xsl:call-template name="templ_str_EditionShortUnCap"/>
	  					</xsl:with-param>
	  					<xsl:with-param name="parameters">
	  						<t:params>
	  							<t:param>
									<xsl:value-of select="$editionTemp"/>
								</t:param>
	  						</t:params>
	  					</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
	
		<xsl:call-template name="templateE">
			<xsl:with-param name="first" select="$date"/>
			<xsl:with-param name="second" select="$edition"/>
			<xsl:with-param name="third" select="b:Pages"/>
		</xsl:call-template>		
	</xsl:template>

	<xsl:template name="templateRYM">
		<xsl:call-template name="appendField_Dot">
			<xsl:with-param name="field" select="b:RecordingNumber"/>
		</xsl:call-template>

		<xsl:variable name="year">
			<xsl:call-template name="getYear"/>
		</xsl:variable>

		<xsl:if test="string-length(b:RecordingNumber) > 0 and (string-length($year) > 0 or string-length(b:Medium) > 0)">
			<xsl:call-template name="templ_prop_Space"/>
		</xsl:if>

		<xsl:call-template name="appendField_Dot">
			<xsl:with-param name="field" select="$year"/>
		</xsl:call-template>

		<xsl:if test="(string-length($year) > 0 and string-length(b:Medium) > 0)">
			<xsl:call-template name="templ_prop_Space"/>
		</xsl:if>

		<xsl:call-template name="appendField_Dot">
			<xsl:with-param name="field" select="b:Medium"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="templateTC">
		<xsl:call-template name="templateC">
			<xsl:with-param name="first" select="b:Theater"/>
			<xsl:with-param name="second" select="b:City"/>
		</xsl:call-template>		
	</xsl:template>

	<xsl:template name="templateIC">
		<xsl:call-template name="templateC">
			<xsl:with-param name="first" select="b:Institution"/>
			<xsl:with-param name="second" select="b:City"/>
		</xsl:call-template>		
	</xsl:template>

	<xsl:template name="templateDY">
		<xsl:call-template name="templateC">
			<xsl:with-param name="first" select="b:Distributor"/>
			<xsl:with-param name="second">
				<xsl:call-template name="getYear" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="templateCPD">
		<xsl:variable name="date">
			<xsl:call-template name="formatDate"/>
		</xsl:variable>
		
		<xsl:call-template name="templateA">
			<xsl:with-param name="first">
				<xsl:call-template name="templateCityStateProvince" />
			</xsl:with-param>
			<xsl:with-param name="second" select="b:Publisher"/>
			<xsl:with-param name="third" select="$date"/>
		</xsl:call-template>		
	</xsl:template>
	
	<xsl:template name="templateSC">
		<xsl:call-template name="templateC">
			<xsl:with-param name="first" select="b:Station"/>
			<xsl:with-param name="second" select="b:City"/>
		</xsl:call-template>		
	</xsl:template>
	

	<xsl:template name="templateCP">
		<xsl:variable name="patentTemp">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="b:PatentNumber"/>
			</xsl:call-template>
		</xsl:variable>
    <xsl:variable name="str_PatentCap">
      <xsl:call-template name="templ_str_PatentCap"/>
    </xsl:variable>

    <xsl:variable name="patent">
			<xsl:choose>
				<xsl:when test="string-length($patentTemp)>0">
					<xsl:call-template name="StringFormat">
	  					<xsl:with-param name="format" select="$str_PatentCap"/>
	  					<xsl:with-param name="parameters">
	  						<t:params>
	  							<t:param>
									<xsl:value-of select="$patentTemp"/>
								</t:param>
	  						</t:params>
	  					</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="templateSpaceAB">
			<xsl:with-param name="first" select="b:CountryRegion"/>
			<xsl:with-param name="second" select="$patent"/>
		</xsl:call-template>		
	</xsl:template>


	<xsl:template name="templateCCD">
		<xsl:variable name="date">
			<xsl:call-template name="formatDate"/>
		</xsl:variable>
		
		<xsl:variable name="temp">
			<xsl:if test = "string-length(b:Court)>0 or string-length(b:City)>0 or string-length($date)>0">
				<xsl:call-template name="templ_prop_OpenBracket"/>
				<xsl:value-of select="b:Court"/>
				<xsl:if test = "string-length(b:Court)>0 and (string-length(b:City)>0 or string-length($date)>0)">
					<xsl:call-template name="templ_prop_ListSeparator"/>
				</xsl:if>
				<xsl:if test = "string-length(b:City)>0 or string-length($date)>0">
					<xsl:value-of select="b:City"/>
					<xsl:if test = "string-length(b:City)>0 and string-length($date)>0">
						<xsl:call-template name="templ_prop_Space"/>
					</xsl:if>
					<xsl:value-of select="$date"/>
				</xsl:if>
				<xsl:call-template name="templ_prop_CloseBracket"/>
			</xsl:if>
		</xsl:variable>

		<xsl:call-template name="appendField_Dot">
			<xsl:with-param name="field" select="$temp"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="templateVIYP">

		<xsl:variable name="volume">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="b:Volume"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="issue">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="b:Issue"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="year">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field">
					<xsl:call-template name="getYear" />
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="month">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="b:Month"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="monthYear">
			<xsl:if test="string-length(b:Year)>0">
				<xsl:value-of select="$month" />
				<xsl:if test="string-length($month) > 0">
					<xsl:call-template name="templ_prop_Space"/>
				</xsl:if>
			</xsl:if>
			<xsl:value-of select="$year" />
		</xsl:variable>

		<xsl:variable name="pages">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="b:Pages"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="temp">
		
			<xsl:if test="string-length(b:Publisher)>0">
				<xsl:if test="string-length(b:JournalName)>0">
					<xsl:call-template name="templ_prop_Space"/>
				</xsl:if>
				<xsl:call-template name="templ_prop_OpenBracket"/>
				<xsl:value-of select="b:Publisher"/>
				<xsl:call-template name="templ_prop_CloseBracket"/>
			</xsl:if>

			<xsl:if test="string-length($volume)>0">
				<xsl:if test="string-length(b:JournalName)>0 or string-length(b:Publisher)>0">
					<xsl:call-template name="templ_prop_Space"/>
				</xsl:if>
				<xsl:value-of select="$volume"/>
			</xsl:if>

			<xsl:if test="((string-length(b:JournalName)>0 or string-length(b:Publisher)>0 or string-length($volume)>0) and string-length($issue)>0) or ((string-length($volume)=0 and string-length($issue)=0) and (string-length(b:JournalName)>0 and string-length($monthYear)>0))">
				<xsl:call-template name="templ_prop_ListSeparator"/>
			</xsl:if>
			
			<xsl:variable name="str_NumberShortUnCap">
				<xsl:call-template name="templ_str_NumberShortUnCap"/>
			</xsl:variable>

			<xsl:if test="string-length($issue)>0">
				<xsl:call-template name="StringFormat">
	  				<xsl:with-param name="format" select="$str_NumberShortUnCap"/>
	  				<xsl:with-param name="parameters">
	  					<t:params>
	  						<t:param>
								<xsl:value-of select="$issue"/>
							</t:param>
	  					</t:params>
	  				</xsl:with-param>
				</xsl:call-template>
			</xsl:if>

			<xsl:if test="string-length($monthYear)>0">
				<xsl:call-template name="templ_prop_Space"/>
				
				<xsl:if test="string-length($volume)>0 or string-length($issue)>0">
					<xsl:call-template name="templ_prop_OpenBracket"/>
				</xsl:if>
				
				<xsl:value-of select="$monthYear"/>

				<xsl:if test="string-length($volume)>0 or string-length($issue)>0">
					<xsl:call-template name="templ_prop_CloseBracket"/>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="(string-length($volume)>0 or string-length($issue)>0 or string-length($monthYear)>0) and (string-length($pages)>0)">
				<xsl:call-template name="templ_prop_EnumSeparator"/>
			</xsl:if>

			<xsl:if test="string-length($pages)>0">
				<xsl:if test="(string-length(b:JournalName)>0 or string-length(b:Publisher)>0)and not((string-length($volume)>0 or string-length($issue)>0 or string-length($monthYear)>0))">
					<xsl:call-template name="templ_prop_Space"/>
				</xsl:if>
				<xsl:value-of select="$pages"/>
			</xsl:if>
		</xsl:variable>
		
		<xsl:call-template name="appendField_Dot">
			<xsl:with-param name="field" select="$temp"/>
		</xsl:call-template>
		
		
	</xsl:template>

	<xsl:template match="*" mode="outputHtml">
		<xsl:element name="{name()}" namespace="{namespace-uri()}">
			<xsl:for-each select="@*">
				<xsl:attribute name="{name()}" namespace="{namespace-uri()}">
					<xsl:value-of select="." />
				</xsl:attribute>
			</xsl:for-each>
			<xsl:apply-templates mode="outputHtml"/>		
		</xsl:element>
	</xsl:template>

	
	<xsl:template name="templateVI">

		<xsl:variable name="volume">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="b:Volume"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="issue">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="b:Issue"/>
			</xsl:call-template>
		</xsl:variable>
	
	    <xsl:variable name="prop_APA_Hyphens">
	      <xsl:call-template name="templ_prop_Hyphens"/>
	    </xsl:variable>
	    
    		<xsl:variable name="theVolume">
			<xsl:if test="string-length($volume)>0">
				<xsl:call-template name="StringFormat">
					<xsl:with-param name="format">
					  <xsl:choose>
						<xsl:when test="not(string-length($volume)=string-length(translate($volume, ',', '')))">
						  <xsl:call-template name="templ_str_VolumesShortCap"/>
						</xsl:when>
						<xsl:when test="string-length($volume)=string-length(translate($volume, $prop_APA_Hyphens, ''))">
						  <xsl:call-template name="templ_str_VolumeShortCap"/>
						</xsl:when>
						<xsl:otherwise>
						  <xsl:call-template name="templ_str_VolumesShortCap"/>
						</xsl:otherwise>
					  </xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="parameters">
						<t:params>
							<t:param>
								<xsl:value-of select="$volume"/>
							</t:param>
						</t:params>
					</xsl:with-param>
				</xsl:call-template>	
			</xsl:if>
		</xsl:variable>

    <xsl:variable name="str_NumberShortUnCap">
      <xsl:call-template name="templ_str_NumberShortUnCap"/>
    </xsl:variable>
    <xsl:variable name="str_NumberShortCap">
      <xsl:call-template name="templ_str_NumberShortCap"/>
    </xsl:variable>

    <xsl:variable name="theIssue">
			<xsl:if test="string-length($issue)>0">
				<xsl:if test="string-length($volume)>0">
					<xsl:call-template name="StringFormat">
	  					<xsl:with-param name="format" select="$str_NumberShortUnCap"/>
	  					<xsl:with-param name="parameters">
	  						<t:params>
	  							<t:param>
									<xsl:value-of select="$issue"/>
								</t:param>
	  						</t:params>
	  					</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="string-length($volume)=0">
					<xsl:call-template name="StringFormat">
	  					<xsl:with-param name="format" select="$str_NumberShortCap"/>
	  					<xsl:with-param name="parameters">
	  						<t:params>
	  							<t:param>
									<xsl:value-of select="$issue"/>
								</t:param>
	  						</t:params>
	  					</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
			</xsl:if>
		</xsl:variable>


		<xsl:call-template name="templateB">
			<xsl:with-param name="first" select="$theVolume"/>
			<xsl:with-param name="second" select="$theIssue"/>
		</xsl:call-template>		
	</xsl:template>

	<xsl:template name="templateCPDMY">

		<xsl:variable name="date">
			<xsl:call-template name="formatDate"/>
		</xsl:variable>

		<xsl:variable name = "temp">
			<xsl:call-template name="templateA">
				<xsl:with-param name="first">
					<xsl:call-template name="templateCityStateProvince" />
				</xsl:with-param>
				<xsl:with-param name="second" select="b:Publisher"/>
				<xsl:with-param name="third">
					<xsl:if test = "string-length($date) > 0">
						<xsl:call-template name="templ_prop_OpenBracket"/>
						<xsl:value-of select="$date"/>
						<xsl:call-template name="templ_prop_CloseBracket"/>
					</xsl:if>

					<xsl:if test = "string-length(b:Pages) > 0 and string-length($date) > 0">
						<xsl:call-template name="templ_prop_EnumSeparator"/>
						<xsl:value-of select="b:Pages"/>
					</xsl:if>
				</xsl:with-param>
			</xsl:call-template>	
		</xsl:variable>

		<xsl:if test = "string-length($temp) > 0">
			<xsl:value-of select="$temp"/>
		</xsl:if>
		
		<xsl:if test = "string-length(b:Pages) > 0 and string-length($date) = 0">
			<xsl:if test = "string-length($temp) > 0">
				<xsl:call-template name="templ_prop_Space"/>
			</xsl:if>

			<xsl:call-template name="appendField_Dot">
				<xsl:with-param name="field" select="b:Pages"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="templateDACURL">

		<xsl:variable name="date">
			<xsl:call-template name="formatDateAccessed"/>
		</xsl:variable>

		<xsl:if test = "string-length(b:URL) > 0">
			<xsl:value-of select="b:URL"/>
		</xsl:if>
		
		<xsl:if test = "string-length(b:URL) > 0 and string-length($date) > 0">
			<xsl:call-template name="templ_prop_Space"/>
		</xsl:if>

		<xsl:if test = "string-length($date) > 0">
			<xsl:call-template name="templ_prop_OpenBracket"/>
			<xsl:call-template name="StringFormat">
				<xsl:with-param name="format">
					<xsl:call-template name="templ_str_AccessedUnCap"/>
				</xsl:with-param>
				<xsl:with-param name="parameters">
					<t:params>
						<t:param>
							<xsl:value-of select="$date"/>
						</t:param>
					</t:params>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="templ_prop_CloseBracket"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="templateRICPY">
		<xsl:variable name="tempCPY">
			<xsl:call-template name="templateCPYNoDot"/>
		</xsl:variable>

		<xsl:call-template name='PrintList'>
			<xsl:with-param name="list">
				<Items>
					<TextItem>
						<xsl:value-of select ="b:ThesisType"/>
					</TextItem>
					<TextItem>
						<xsl:value-of select ="b:Department"/>
					</TextItem>
					<TextItem>
						<xsl:value-of select ="b:Institution"/>
					</TextItem>
					<TextItem>
						<xsl:value-of select ="$tempCPY"/>
					</TextItem>
					<TextItem>
						<xsl:value-of select ="b:Pages"/>
					</TextItem>
				</Items>
			</xsl:with-param>
		</xsl:call-template>
	
	</xsl:template>

	<xsl:template name="templatePR">

		<xsl:variable name="producerName">
			<xsl:call-template name="formatProducerName"/>
		</xsl:variable>

		<xsl:variable name="productionCompany">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="b:ProductionCompany"/>
			</xsl:call-template>
		</xsl:variable>


		<xsl:variable name="prod">
			<xsl:if test="string-length($producerName)>0">
				<xsl:value-of select="$producerName"/>
			</xsl:if>

			<xsl:if test="string-length($producerName)=0 and string-length($productionCompany)">
				<xsl:value-of select="$productionCompany"/>
			</xsl:if>
		</xsl:variable>

		<xsl:call-template name="templateC">
			<xsl:with-param name="first" select="$prod"/>
			<xsl:with-param name="second" select="b:RecordingNumber"/>
		</xsl:call-template>		
	</xsl:template>

	<xsl:template name="formatNameCore">
		<xsl:param name="FML"/>
		<xsl:param name="FM"/>
		<xsl:param name="ML"/>
		<xsl:param name="FL"/>
		<xsl:param name="upperLast"/>
		<xsl:param name="withDot"/>

		<xsl:variable name="first">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="b:First"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="middle">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="b:Middle"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="last">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="b:Last"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="format">
			<xsl:choose>
				<xsl:when test="string-length($first) = 0 and string-length($middle) = 0 and string-length($last) = 0 ">
				</xsl:when>
				<xsl:when test="string-length($first) = 0 and string-length($middle) = 0 and string-length($last) != 0 ">
					<xsl:call-template name="templ_prop_SimpleAuthor_L" />
				</xsl:when>
				<xsl:when test="string-length($first) = 0 and string-length($middle) != 0 and string-length($last) = 0 ">
          <xsl:call-template name="templ_prop_SimpleAuthor_M" />
				</xsl:when>
				<xsl:when test="string-length($first) = 0 and string-length($middle) != 0 and string-length($last) != 0 ">
					<xsl:value-of select="$ML"/>
				</xsl:when>
				<xsl:when test="string-length($first) != 0 and string-length($middle) = 0 and string-length($last) = 0 ">
					<xsl:call-template name="templ_prop_SimpleAuthor_F" />
				</xsl:when>
				<xsl:when test="string-length($first) != 0 and string-length($middle) = 0 and string-length($last) != 0 ">
					<xsl:value-of select="$FL"/>
				</xsl:when>
				<xsl:when test="string-length($first) != 0 and string-length($middle) != 0 and string-length($last) = 0 ">
					<xsl:value-of select="$FM"/>
				</xsl:when>
				<xsl:when test="string-length($first) != 0 and string-length($middle) != 0 and string-length($last) != 0 ">
					<xsl:value-of select="$FML"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:call-template name="StringFormatName">
			<xsl:with-param name="format" select="$format"/>
			<xsl:with-param name="upperLast" select="$upperLast"/>
			<xsl:with-param name="withDot" select="$withDot"/>
		</xsl:call-template>
		
	</xsl:template>

	<xsl:template name="formatDateCorePrivate">
		<xsl:param name="DMY"/>
		<xsl:param name="DM"/>
		<xsl:param name="MY"/>
		<xsl:param name="DY"/>

		<xsl:param name="day"/>
		<xsl:param name="month"/>
		<xsl:param name="year"/>
		
		<xsl:param name="withDot"/>
		
		<xsl:variable name="format">
			<xsl:choose>
				<xsl:when test="string-length($day) = 0 and string-length($month) = 0 and string-length($year) = 0 ">
				</xsl:when>
				<xsl:when test="string-length($day) = 0 and string-length($month) = 0 and string-length($year) != 0 ">
					<xsl:call-template name="templ_prop_SimpleDate_Y" />
				</xsl:when>
				<xsl:when test="string-length($day) = 0 and string-length($month) != 0 and string-length($year) = 0 ">
				</xsl:when>
				<xsl:when test="string-length($day) = 0 and string-length($month) != 0 and string-length($year) != 0 ">
					<xsl:value-of select="$MY"/>
				</xsl:when>
				<xsl:when test="string-length($day) != 0 and string-length($month) = 0 and string-length($year) = 0 ">
				</xsl:when>
				<xsl:when test="string-length($day) != 0 and string-length($month) = 0 and string-length($year) != 0 ">
					<xsl:call-template name="templ_prop_SimpleDate_Y" />
				</xsl:when>
				<xsl:when test="string-length($day) != 0 and string-length($month) != 0 and string-length($year) = 0 ">
				</xsl:when>
				<xsl:when test="string-length($day) != 0 and string-length($month) != 0 and string-length($year) != 0 ">
<!--					<xsl:value-of select="$DMY"/> -->
					<xsl:call-template name="templ_prop_SimpleDate_DMY"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:call-template name="StringFormatDate">
			<xsl:with-param name="format" select="$format"/>

			<xsl:with-param name="day" select="$day"/>
			<xsl:with-param name="month" select="$month"/>
			<xsl:with-param name="year" select="$year"/>

			<xsl:with-param name="withDot" select="$withDot"/>
		</xsl:call-template>
		
	</xsl:template>

	<xsl:template name="StringFormatName">
		<xsl:param name="format" />
		<xsl:param name="withDot" />
		<xsl:param name="upperLast"/>

    <xsl:variable name="prop_EndChars">
      <xsl:call-template name="templ_prop_EndChars"/>
    </xsl:variable>

    <xsl:choose>
			<xsl:when test="$format = ''"></xsl:when>
			<xsl:when test="substring($format, 1, 2) = '%%'">
				<xsl:text>%</xsl:text>
				<xsl:call-template name="StringFormatName">
					<xsl:with-param name="format" select="substring($format, 3)" />
					<xsl:with-param name="withDot" select="$withDot" />
					<xsl:with-param name="upperLast" select="$upperLast" />
				</xsl:call-template>
				<xsl:if test="string-length($format)=2 and withDot = 'yes' and not(contains($prop_EndChars, '%'))">
					<xsl:call-template name="templ_prop_Dot"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="substring($format, 1, 1) = '%'">
				<xsl:variable name="what" select="substring($format, 2, 1)" />
				
				<xsl:choose>
					<xsl:when test="(what = 'l' or what = 'L') and upperLast = 'yes'">
						<span style='text-transform: uppercase;'>
							<xsl:call-template name="formatNameOneItem">
								<xsl:with-param name="format" select="$what"/>
							</xsl:call-template>
						</span>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="formatNameOneItem">
							<xsl:with-param name="format" select="$what"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:call-template name="StringFormatName">
					<xsl:with-param name="format" select="substring($format, 3)" />
					<xsl:with-param name="withDot" select="$withDot" />
					<xsl:with-param name="upperLast" select="$upperLast" />
				</xsl:call-template>
				<xsl:if test="string-length($format)=2 and withDot='yes'">
					<xsl:variable name="temp2">
						<xsl:call-template name="handleSpaces">
							<xsl:with-param name="field">
								<xsl:call-template name="formatNameOneItem">
									<xsl:with-param name="format" select="$what"/>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>				
					<xsl:variable name="lastChar">
						<xsl:value-of select="substring($temp2, string-length($temp2))"/>
					</xsl:variable>
					<xsl:if test="not(contains($prop_EndChars, $lastChar))">
						<xsl:call-template name="templ_prop_Dot"/>
					</xsl:if>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring($format, 1, 1)" />
				<xsl:call-template name="StringFormatName">
					<xsl:with-param name="format" select="substring($format, 2)" />
					<xsl:with-param name="withDot" select="$withDot" />
					<xsl:with-param name="upperLast" select="$upperLast" />
				</xsl:call-template>
				<xsl:if test="string-length($format)=1">
					<xsl:if test="withDot = 'yes' and not(contains($prop_EndChars, $format))">
						<xsl:call-template name="templ_prop_Dot"/>
					</xsl:if>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	

	<xsl:template name="StringFormatDate">
		<xsl:param name="format" />
		
		<xsl:param name="day"/>
		<xsl:param name="month"/>
		<xsl:param name="year"/>		
		
		<xsl:param name="withDot" />

    <xsl:variable name="prop_EndChars">
      <xsl:call-template name="templ_prop_EndChars"/>
    </xsl:variable>

    <xsl:choose>
			<xsl:when test="$format = ''"></xsl:when>
			<xsl:when test="substring($format, 1, 2) = '%%'">
				<xsl:text>%</xsl:text>
				<xsl:call-template name="StringFormatDate">
					<xsl:with-param name="format" select="substring($format, 3)" />
					<xsl:with-param name="day" select="$day"/>
					<xsl:with-param name="month" select="$month"/>
					<xsl:with-param name="year" select="$year"/>
					<xsl:with-param name="withDot" select="$withDot" />
				</xsl:call-template>
				<xsl:if test="string-length($format)=2 and withDot = 'yes' and not(contains($prop_EndChars, '%'))">
					<xsl:call-template name="templ_prop_Dot"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="substring($format, 1, 1) = '%'">
				<xsl:variable name="what" select="substring($format, 2, 1)" />
				<xsl:choose>
					<xsl:when test="$what = 'D'">
						<xsl:value-of select="$day"/>
					</xsl:when>
					<xsl:when test="$what = 'M'">
						<xsl:value-of select="$month"/>
					</xsl:when>
					<xsl:when test="$what = 'Y'">
						<xsl:value-of select="$year"/>
					</xsl:when>
				</xsl:choose>
				<xsl:call-template name="StringFormatDate">
					<xsl:with-param name="format" select="substring($format, 3)" />
					<xsl:with-param name="day" select="$day"/>
					<xsl:with-param name="month" select="$month"/>
					<xsl:with-param name="year" select="$year"/>
					<xsl:with-param name="withDot" select="$withDot" />
				</xsl:call-template>
				<xsl:if test="string-length($format)=2 and withDot='yes'">
					<xsl:variable name="temp2">
						<xsl:call-template name="handleSpaces">
							<xsl:with-param name="field">
								<xsl:call-template name="formatNameOneItem">
									<xsl:with-param name="format" select="$what"/>
								</xsl:call-template>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>				
					<xsl:variable name="lastChar">
						<xsl:value-of select="substring($temp2, string-length($temp2))"/>
					</xsl:variable>
					<xsl:if test="not(contains($prop_EndChars, $lastChar))">
						<xsl:call-template name="templ_prop_Dot"/>
					</xsl:if>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring($format, 1, 1)" />
				<xsl:call-template name="StringFormatDate">
					<xsl:with-param name="format" select="substring($format, 2)" />
					<xsl:with-param name="day" select="$day"/>
					<xsl:with-param name="month" select="$month"/>
					<xsl:with-param name="year" select="$year"/>
					<xsl:with-param name="withDot" select="$withDot" />
				</xsl:call-template>
				<xsl:if test="string-length($format)=1">
					<xsl:if test="withDot = 'yes' and not(contains($prop_EndChars, $format))">
						<xsl:call-template name="templ_prop_Dot"/>
					</xsl:if>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getYear">
		<xsl:choose>
			<xsl:when test="string-length(b:Year)=0">
				<xsl:call-template name="templ_str_NoDateShortUnCap"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="b:Year"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="formatDateCore">
		<xsl:param name="day"/>
		<xsl:param name="month"/>
		<xsl:param name="year"/>
		<xsl:param name="displayND"/>
		
		<xsl:param name="DMY"/>
		<xsl:param name="DM"/>
		<xsl:param name="MY"/>
		<xsl:param name="DY"/>
	
		<xsl:choose>
			<xsl:when test="string-length($year)=0">
				<xsl:if test="$displayND = 'yes'">
					<xsl:call-template name="templ_str_NoDateShortUnCap"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="formatDateCorePrivate">
					<xsl:with-param name="day" select="$day"/>
					<xsl:with-param name="month" select="$month"/>
					<xsl:with-param name="year" select="$year"/>
					
					<xsl:with-param name="DMY" select="$DMY"/>
					<xsl:with-param name="DM" select="$DM"/>
					<xsl:with-param name="MY" select="$MY"/>
					<xsl:with-param name="DY" select="$DY"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>
	
	<xsl:template name="formatNameOneItem">
		<xsl:param name="format"/>

		<xsl:choose>
			<xsl:when test="$format = 'F'">
				<xsl:value-of select="b:First"/>
			</xsl:when>
			<xsl:when test="$format = 'L'">
				<xsl:value-of select="b:Last"/>
			</xsl:when>
			<xsl:when test="$format = 'M'">
				<xsl:value-of select="b:Middle"/>
			</xsl:when>
			<xsl:when test="$format = 'f'">
				<xsl:call-template name="formatNameInitial">
					<xsl:with-param name="name" select="b:First"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$format = 'm'">
				<xsl:call-template name="formatNameInitial">
					<xsl:with-param name="name" select="b:Middle"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$format = 'l'">
				<xsl:call-template name="formatNameInitial">
					<xsl:with-param name="name" select="b:Last"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>

	</xsl:template>
	
	<xsl:template name="formatNameInitial">
		<xsl:param name="name"/>
		<xsl:variable name="temp">
			<xsl:call-template name="handleSpaces">
				<xsl:with-param name="field" select="$name"/>
			</xsl:call-template>
		</xsl:variable>

    <xsl:variable name="prop_APA_Hyphens">
      <xsl:call-template name="templ_prop_Hyphens"/>
    </xsl:variable>

    <xsl:if test="string-length($temp)>0">

			<xsl:variable name="tempWithoutSpaces">
				<xsl:value-of select="translate($temp, '&#32;&#160;', '')"/>
			</xsl:variable>

			<xsl:if test="not(contains($prop_APA_Hyphens, substring($tempWithoutSpaces, 1, 1)))">
				<xsl:value-of select="substring($tempWithoutSpaces, 1, 1)"/>
				<xsl:call-template name="templ_prop_DotInitial"/>
			</xsl:if>

			<xsl:call-template name="handleHyphens">
				<xsl:with-param name="name" select="$tempWithoutSpaces"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="handleHyphens">
		<xsl:param name="name"/>

    <xsl:variable name="prop_APA_Hyphens">
      <xsl:call-template name="templ_prop_Hyphens"/>
    </xsl:variable>

    <xsl:if test="string-length($name)>=2">
			<xsl:choose>
				<xsl:when test="contains($prop_APA_Hyphens, substring($name, 1, 1))">
					<xsl:value-of select="substring($name, 1, 2)"/>
					<xsl:call-template name="templ_prop_DotInitial"/>
					
					<xsl:call-template name="handleHyphens">
						<xsl:with-param name="name" select="substring($name, 3)"/>
					</xsl:call-template>
				</xsl:when>
				
				<xsl:otherwise>
					<xsl:call-template name="handleHyphens">
						<xsl:with-param name="name" select="substring($name, 2)"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:if>

	</xsl:template>

	<xsl:template name="PrintSpaceAndList">
		<xsl:param name="list"/>

		<xsl:variable name="result">
			<xsl:call-template name="PrintList">
				<xsl:with-param name="list" select="$list" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:if test="string-length($result) > 0">
			<xsl:call-template name="templ_prop_Space" />
			<xsl:copy-of select="$result" />
		</xsl:if>
	</xsl:template>

	<xsl:template name="PrintList">
		<xsl:param name="list"/>

		<xsl:call-template name="PrintList2">
			<xsl:with-param name="list" select="$list" />
			<xsl:with-param name="index" select="'1'" />
			<xsl:with-param name="nextSeparator">
				<xsl:call-template name="templ_prop_ListSeparator"/>
			</xsl:with-param>
			<xsl:with-param name="textDisplayed" select="''" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="PrintList2">
		<xsl:param name="list"/>
		<xsl:param name="index"/>
		<xsl:param name="nextSeparator"/>
		<xsl:param name="lastTextDisplayed"/>

		

		<xsl:choose>
			<xsl:when test="$index > count(msxsl:node-set($list)/*/*)">
				<xsl:call-template name="need_Dot">
					<xsl:with-param name="field" select ="$lastTextDisplayed"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="local-name(msxsl:node-set($list)/*/*[$index]) = 'TextItem'">
				<xsl:variable name="item">
					<xsl:value-of select="msxsl:node-set($list)/*/*[$index]" />
				</xsl:variable>

				<xsl:if test="string-length($item) > 0 and string-length($lastTextDisplayed) > 0">
					<xsl:value-of select = "$nextSeparator" />
				</xsl:if>

				<xsl:if test="string-length($item) > 0">
					<xsl:value-of select = "$item" />
				</xsl:if>

				<xsl:call-template name="PrintList2">
					<xsl:with-param name="list" select="$list" />
					<xsl:with-param name="index" select="$index + 1" />
					<xsl:with-param name="nextSeparator">
						<xsl:choose>
							<xsl:when test="string-length($item) > 0 and string-length($lastTextDisplayed) > 0">
								<xsl:call-template name="templ_prop_ListSeparator"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$nextSeparator" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="lastTextDisplayed">
						<xsl:choose>
							<xsl:when test="string-length($item) > 0">
								<xsl:value-of select="$item" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$lastTextDisplayed" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>					
			</xsl:when>
			<xsl:when test="local-name(msxsl:node-set($list)/*/*[$index]) = 'GroupSeparator'">
				<xsl:call-template name="PrintList2">
					<xsl:with-param name="list" select="$list" />
					<xsl:with-param name="index" select="$index + 1" />
					<xsl:with-param name="nextSeparator">
						<xsl:call-template name="templ_prop_GroupSeparator"/>
					</xsl:with-param>
					<xsl:with-param name="lastTextDisplayed" select="$lastTextDisplayed" />
				</xsl:call-template>			
			</xsl:when>
			<xsl:when test="local-name(msxsl:node-set($list)/*/*[$index]) = 'CopyItem'">
				<xsl:variable name="item">
					<xsl:copy-of select="msxsl:node-set($list)/*/*[$index]" />
				</xsl:variable>

				<xsl:if test="string-length($item) > 0 and string-length($lastTextDisplayed) > 0">
					<xsl:value-of select = "$nextSeparator" />
				</xsl:if>

				<xsl:if test="string-length($item) > 0">
					<xsl:copy-of select = "msxsl:node-set($item)/*[1]" />
				</xsl:if>

				<xsl:call-template name="PrintList2">
					<xsl:with-param name="list" select="$list" />
					<xsl:with-param name="index" select="$index + 1" />
					<xsl:with-param name="nextSeparator">
						<xsl:choose>
							<xsl:when test="string-length($item) > 0 and string-length($lastTextDisplayed) > 0">
								<xsl:call-template name="templ_prop_ListSeparator"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$nextSeparator" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="lastTextDisplayed">
						<xsl:choose>
							<xsl:when test="string-length(msxsl:node-set($item)/*[1]) > 0">
								<xsl:value-of select="msxsl:node-set($item)/*[1]" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$lastTextDisplayed" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="ApplyItalicTitleNS">
		<xsl:param name="data" />

	    <xsl:variable name="prop_NoItalics">
	      <xsl:call-template name="templ_prop_NoItalics"/>
	    </xsl:variable>

		<xsl:choose>
			<xsl:when test = "$prop_NoItalics = 'yes'">
				<xsl:variable name = "prop_TitleOpen">
		      		<xsl:call-template name="templ_prop_TitleOpen"/>
				</xsl:variable>
				<xsl:variable name = "prop_TitleClose">
		      		<xsl:call-template name="templ_prop_TitleClose"/>
				</xsl:variable>
				<xsl:variable name = "prop_OpenQuote">
		      		<xsl:call-template name="templ_prop_OpenQuote"/>
				</xsl:variable>
				<xsl:variable name = "prop_CloseQuote">
		      		<xsl:call-template name="templ_prop_CloseQuote"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test = "string-length($prop_TitleOpen) > 0 and string-length($prop_TitleClose) > 0 and string-length($prop_OpenQuote) > 0 and string-length($prop_CloseQuote) > 0 and 
					              not(starts-with($data, $prop_TitleOpen) or (substring($data, string-length($data) - string-length($prop_TitleClose)) = $prop_TitleClose) or starts-with($data, $prop_OpenQuote) or (substring($data, string-length($data) - string-length($prop_CloseQuote)) = $prop_CloseQuote))">
			      		<xsl:call-template name="templ_prop_TitleOpen"/>
						<xsl:copy-of select="msxsl:node-set($data)" />
						<xsl:call-template name="templ_prop_TitleClose"/>
					</xsl:when>
					<xsl:when test = "string-length($prop_TitleOpen) > 0 and string-length($prop_TitleClose) > 0 and 
					              not(starts-with($data, $prop_TitleOpen) or (substring($data, string-length($data) - string-length($prop_TitleClose)) = $prop_TitleClose))">
			      		<xsl:call-template name="templ_prop_TitleOpen"/>
						<xsl:copy-of select="msxsl:node-set($data)" />
						<xsl:call-template name="templ_prop_TitleClose"/>
					</xsl:when>
		      		<xsl:otherwise>
						<xsl:copy-of select="msxsl:node-set($data)" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<i xmlns="http://www.w3.org/TR/REC-html40">
					<xsl:copy-of select="msxsl:node-set($data)" />
				</i>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="ApplyItalicFieldNS">
		<xsl:param name="data" />

	    <xsl:variable name="prop_NoItalics">
	      <xsl:call-template name="templ_prop_NoItalics"/>
	    </xsl:variable>

		<xsl:choose>
			<xsl:when test = "$prop_NoItalics = 'yes'">
				<xsl:copy-of select="msxsl:node-set($data)" />
			</xsl:when>
			<xsl:otherwise>
				<i xmlns="http://www.w3.org/TR/REC-html40">
				<xsl:copy-of select="msxsl:node-set($data)" />
				</i>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
