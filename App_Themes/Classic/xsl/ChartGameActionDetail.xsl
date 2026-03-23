<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output  method="html" indent="no" encoding="UTF-8" />

  <xsl:template match="//xml">

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/JavaScript">
      function post(){

      document.forms[0].action = 'ChartGameActionDetail.aspx';
      document.forms[0].submit();
      }
    </SCRIPT>
    
      <TABLE CELLSPACING="1" CELLPADDING="1" BORDER="0">
      <TR>
        <TD colspan="4"  align="center">
          <h4>Game Action Detail</h4>
        </TD>
      </TR>
      <TR>
        <TD>
          <STRONG>Type of Wager:</STRONG>
          <SELECT class="form-control form-control-sm"  NAME="cWagerType"  OnChange="post();">
            <xsl:for-each select="wagertype">
              <OPTION VALUE="{@Value}">
                <xsl:if test="@Selected='1'">
                  <xsl:attribute name="Selected">Selected</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="@Text" />
              </OPTION>
            </xsl:for-each>
          </SELECT>
        </TD>
        <TD>
          <STRONG>Player Type:</STRONG>
          <SELECT class="form-control form-control-sm"  NAME="cPlayerType"  OnChange="post();">
            <xsl:for-each select="combobox">
              <OPTION VALUE="{@Value}">
                <xsl:if test="@Selected='1'">
                  <xsl:attribute name="Selected">Selected</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="@Text" />
              </OPTION>
            </xsl:for-each>
          </SELECT>
        </TD>
        <TD>
          <INPUT type="SUBMIT" class="btn btn-primary"  VALUE="Go" />
        </TD>
      </TR>
    </TABLE>

    <INPUT type="hidden" name="hGame" value="{@IdGame}" />
    <INPUT type="hidden" name="hPlay" value="{@Play}" />

    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="100%" >
      <xsl:for-each select="//detail">
        <xsl:if test="@Header='True'">
          <TR>
            <TD colspan="8">
              <xsl:value-of select="@Text1" />(<xsl:value-of select="@Text2" />)
            </TD>
          </TR>
          <TR CLASS="page-titles">
            <TD>Placed</TD>
            <TD>User/Phone</TD>
            <TD>Game Date</TD>
            <TD>Sport</TD>
            <TD>Description</TD>
            <TD>Risk/Win</TD>
          </TR>
        </xsl:if>
        <xsl:if test="@Header='False'">
          <TR>
            <xsl:attribute name="class">
              <xsl:choose>
                <xsl:when test="count(preceding::detail) mod 2 = 0">TrGameOdd</xsl:when>
                <xsl:otherwise>TrGameEven</xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <TD ALIGN="center">
              <xsl:value-of disable-output-escaping="yes" select="@Text1"/>
            </TD>
            <TD>
              <xsl:value-of disable-output-escaping="yes" select="@Text2"/>
            </TD>
            <TD>
              <xsl:value-of disable-output-escaping="yes" select="@Text3"/>
            </TD>
            <TD>
              <xsl:value-of disable-output-escaping="yes" select="@Text4"/>
            </TD>
            <TD>
              <xsl:value-of disable-output-escaping="yes" select="@Text5"/>
            </TD>
            <TD>
              <xsl:value-of disable-output-escaping="yes" select="@Text6"/>
            </TD>
          </TR>

        </xsl:if>

      </xsl:for-each>
      <xsl:if test="count(//detail)=0">
        <TR>
          <TD CLASS="TrGameBottom" COLSPAN="7"> No open Wagers</TD>
        </TR>
      </xsl:if>
    </TABLE>
    <br />
    <div align="center">
      <input type="button" value="Close" data-bs-dismiss="modal" />
    </div>
  </xsl:template>

</xsl:stylesheet>

