<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output  method="html" indent="no" encoding="UTF-8" />

  <xsl:template match="//xml">
    
    <TABLE CELLSPACING="1" CELLPADDING="1" BORDER="0" >
      <TR>
        <TD align="right">Initial Date:</TD>
        <TD align="left">
          <INPUT style="WIDTH: 100px" TYPE="text" class="form-control form-control-sm datepicker" NAME="Date1" value="{@StartDate}" />
          <A HREF="#" onClick="JavaScript:cal.select(document.forms[0].Date1,'anchor1','MM/dd/yyyy'); return false;" NAME="anchor1" ID="anchor1">
            <IMG SRC="../App_Themes/Classic/images/calendar2.gif" border="0" width="20"/>
          </A>
        </TD>
        <TD align="right">End Date:</TD>
        <TD align="left">
          <INPUT style="WIDTH: 100px" TYPE="text" class="form-control form-control-sm datepicker" NAME="Date2" value="{@EndDate}" />
          <A HREF="#" onClick="JavaScript:cal.select(document.forms[0].Date2,'anchor2','MM/dd/yyyy'); return false;" NAME="anchor2" ID="anchor2">
            <IMG SRC="../App_Themes/Classic/images/calendar2.gif" border="0" width="20"/>
          </A>
        </TD>
        <TD align="right">Currency:</TD>
        <TD align="left">
          <SELECT class="form-control form-control-sm"  NAME="cCurrency" OnChange="post();">
            <xsl:for-each select="currency">
              <OPTION VALUE="{@IdCurrency}">
                <xsl:if test="@AgentCurrency='True'">
                  <xsl:attribute name="Selected">Selected</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="@Currency" /> (<xsl:value-of select="@Symbol" />)
              </OPTION>
            </xsl:for-each>
          </SELECT>
        </TD>
        <TD>
          <INPUT type="SUBMIT" class="btn btn-primary"  value="Submit" name="Submit" />
        </TD>
      </TR>
    </TABLE>
    <center>
      <H4>
        - Agent Balance History - <BR />
        <xsl:value-of select="@StartDate"/> To <xsl:value-of select="@EndDate"/>
      </H4>
    </center>

    <xsl:if test="count(detail) != 0">
      <table cellspacing="0" cellpadding="0" border="0" width="100%" class="TbMainAgent">
        <tr class="TbInTitle">
          <td>Week</td>
          <td align="right">This Week</td>
          <td align="right">Pmts</td>
          <td align="right">Mon</td>
          <td align="right">Tue</td>
          <td align="right">Wed</td>
          <td align="right">Thu</td>
          <td align="right">Fri</td>
          <td align="right">Sat</td>
          <td align="right">Sun</td>
        </tr>
        <xsl:for-each select="detail">
          <tr>
            <xsl:attribute name="class">
              <xsl:choose>
                <xsl:when test="count(preceding::detail) mod 2 = 0">TrGameOdd</xsl:when>
                <xsl:otherwise>TrGameEven</xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <td>
              <xsl:value-of select="@WeekStart" disable-output-escaping="yes"/>
              <br />
              <xsl:value-of select="@WeekEnd" disable-output-escaping="yes"/>
            </td>
            <td align="right">
              <xsl:value-of select="format-number(@ThisWeek,'###,##0')" disable-output-escaping="yes"/>
            </td>
            <td align="right">
              <xsl:value-of select="format-number(@Pmts,'###,##0')" disable-output-escaping="yes"/>
            </td>
            <td align="right">
              <xsl:value-of select="format-number(@Day1,'###,##0')" disable-output-escaping="yes"/>
            </td>
            <td align="right">
              <xsl:value-of select="format-number(@Day2,'###,##0')" disable-output-escaping="yes"/>
            </td>
            <td align="right">
              <xsl:value-of select="format-number(@Day3,'###,##0')" disable-output-escaping="yes"/>
            </td>
            <td align="right">
              <xsl:value-of select="format-number(@Day4,'###,##0')" disable-output-escaping="yes"/>
            </td>
            <td align="right">
              <xsl:value-of select="format-number(@Day5,'###,##0')" disable-output-escaping="yes"/>
            </td>
            <td align="right">
              <xsl:value-of select="format-number(@Day6,'###,##0')" disable-output-escaping="yes"/>
            </td>
            <td align="right">
              <xsl:value-of select="format-number(@Day7,'###,##0')" disable-output-escaping="yes"/>
            </td>
          </tr>
        </xsl:for-each>
      </table>

      <table cellspacing="0" cellpadding="0" border="0" width="100%">
        <tr class="TbInTitle">
          <td>Totals</td>
          <td align="right">This Week</td>
          <td align="right">Pmts</td>
          <td align="right">Mon</td>
          <td align="right">Tue</td>
          <td align="right">Wed</td>
          <td align="right">Thu</td>
          <td align="right">Fri</td>
          <td align="right">Sat</td>
          <td align="right">Sun</td>
        </tr>
        <tr class="TrGameOdd">
          <td></td>
          <td align="right">
            <xsl:value-of select="format-number(sum(detail/@ThisWeek),'###,##0')" disable-output-escaping="yes"/>
          </td>
          <td align="right">
            <xsl:value-of select="format-number(sum(detail/@Pmts),'###,##0')" disable-output-escaping="yes"/>
          </td>
          <td align="right">
            <xsl:value-of select="format-number(sum(detail/@Day1),'###,##0')" disable-output-escaping="yes"/>
          </td>
          <td align="right">
            <xsl:value-of select="format-number(sum(detail/@Day2),'###,##0')" disable-output-escaping="yes"/>
          </td>
          <td align="right">
            <xsl:value-of select="format-number(sum(detail/@Day3),'###,##0')" disable-output-escaping="yes"/>
          </td>
          <td align="right">
            <xsl:value-of select="format-number(sum(detail/@Day4),'###,##0')" disable-output-escaping="yes"/>
          </td>
          <td align="right">
            <xsl:value-of select="format-number(sum(detail/@Day5),'###,##0')" disable-output-escaping="yes"/>
          </td>
          <td align="right">
            <xsl:value-of select="format-number(sum(detail/@Day6),'###,##0')" disable-output-escaping="yes"/>
          </td>
          <td align="right">
            <xsl:value-of select="format-number(sum(detail/@Day7),'###,##0')" disable-output-escaping="yes"/>
          </td>
        </tr>
      </table>
      
    </xsl:if>

    <xsl:if test="count(detail) = 0">
      <table cellspacing="0" cellpadding="0" border="0" width="100%">
        <tr class="TbInTitle">
          <td>No data.</td>
        </tr>
      </table>
    </xsl:if>
</xsl:template>

</xsl:stylesheet> 

