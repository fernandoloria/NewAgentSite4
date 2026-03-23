<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <CENTER>
    <div>

      <font size="3">
        <STRONG>Chart Straight Details </STRONG>
      </font>

    </div>

    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="100%">
      <TR CLASS="page-titles">
        <TD CLASS="TdSpace"></TD>
        <TD>Player</TD>
        <TD>Ticket#</TD>
        <TD>Placed Date</TD>
        <TD>Line</TD>
        <TD align="right">Risk</TD>
        <TD align="right">To Win</TD>
        <TD CLASS="TdSpace"></TD>
      </TR>
      <xsl:for-each select="//detail">
        <TR>
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="count(preceding::detail) mod 2 = 0">TrGameOdd</xsl:when>
              <xsl:otherwise>TrGameEven</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <TD CLASS="TdSpace"></TD>
          <TD>
            <xsl:if test="@SubHeader = '1'">
              <xsl:value-of select="@Player" />
            </xsl:if>
          </TD>
          <TD>
            <xsl:value-of select="@Ticket" />
          </TD>
          <TD>
            <xsl:value-of select="@PlacedDate" />
          </TD>
          <TD>
            <xsl:value-of select="@Description" />
            <BR/>
            <xsl:value-of select="@Line" />
          </TD>
          <TD align="right">
            <xsl:value-of select="format-number(@RiskAmount,'###,###')" />
          </TD>
          <TD align="right">
            <xsl:value-of select="format-number(@WinAmount,'###,###')" />
          </TD>
          <TD CLASS="TdSpace"></TD>
        </TR>
      </xsl:for-each>
      <TR CLASS="TrGameBottom">
        <TD colspan="5" align="right">
          <B>Total</B>
        </TD>
        <TD align="right">
          <B>
            <xsl:value-of select="format-number(sum(//detail/@RiskAmount),'###,###')" />
          </B>
        </TD>
        <TD align="right">
          <B>
            <xsl:value-of select="format-number(sum(//detail/@WinAmount),'###,###')" />
          </B>
        </TD>
        <TD CLASS="TdSpace"></TD>
      </TR>
    </TABLE>
    <INPUT TYPE="button" data-bs-dismiss="modal" VALUE="Close"/>
  </CENTER>
</xsl:template>

</xsl:stylesheet> 

