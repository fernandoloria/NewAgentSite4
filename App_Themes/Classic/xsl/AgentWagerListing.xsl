<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output  method="html" indent="no" encoding="UTF-8" />

  <xsl:template match="//xml">
    <SCRIPT LANGUAGE="JavaScript" SRC="../App_Themes/Classic/CalendarPopup.js"></SCRIPT>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/JavaScript">
      var cal = new CalendarPopup();

      function post(){
      document.forms[0].submit();
      }
    </SCRIPT>
    <TABLE CELLSPACING="1" CELLPADDING="1" BORDER="0" >
      <TR>
        <TD align="right">Initial Date:</TD>
        <TD align="left">
          <INPUT style="WIDTH: 100px" TYPE="text" class="form-control form-control-sm" NAME="Date1" value="{@StartDate}" />
          <A HREF="#" onClick="JavaScript:cal.select(document.forms[0].Date1,'anchor1','MM/dd/yyyy'); return false;" NAME="anchor1" ID="anchor1">
            <IMG SRC="../App_Themes/Classic/images/calendar2.gif" border="0" width="20"/>
          </A>
        </TD>
        <TD align="right">End Date:</TD>
        <TD align="left">
          <INPUT style="WIDTH: 100px" TYPE="text" class="form-control form-control-sm" NAME="Date2" value="{@EndDate}" />
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
      <TR>
      	<TD style="height:6PX; line-height:6PX;" colspan="7"></TD>
      </TR>
      <TR>
        <TD align="right">
          <font size="3">
            <strong>History for Player:</strong>
          </font>
        </TD>
        <TD align="left">
          <SELECT class="form-control form-control-sm"  NAME="cPlayer" OnChange="post();">
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
        <TD style="height:6PX; line-height:6PX;" colspan="5"></TD>
      </TR>
    </TABLE>
    <center>
      <H4>
        - Agent Wager Listing - <BR />
        <xsl:value-of select="@StartDate"/> To <xsl:value-of select="@EndDate"/>
      </H4>
    </center>

    <xsl:if test="count(Agent) != 0">

      <xsl:for-each select="Agent">
        <table cellspacing="0" cellpadding="0" border="0" width="100%" class="TbMainAgent">
          <tr>
            <td colspan="8"  class="AgentTitle">
              Agent <xsl:value-of select="@Agent" disable-output-escaping="yes"/>
            </td>
          </tr>
          <xsl:for-each select="Player">
            <tr>
              <td colspan="8" class="AgentTitle">
                <xsl:value-of select="@Player" disable-output-escaping="yes"/>
              </td>
            </tr>
            <tr class="TbInTitle">
              <td>Ticket</td>
              <td>Placed Date</td>
              <td>Complete Description</td>
              <td>Risk</td>
              <td>Win</td>
              <td>Result</td>
              <td>User/Score</td>
              <td>Phone/IP</td>
            </tr>
            <xsl:for-each select="Wager">
              <tr class="GameHeader">
                <td>
                  <xsl:value-of select="@Ticket" disable-output-escaping="yes"/>
                </td>
                <td>
                  <xsl:value-of select="@PlacedDate" disable-output-escaping="yes"/>
                </td>
                <td>
                  <xsl:value-of select="@Description" disable-output-escaping="yes"/>
                </td>
                <td>
                  <xsl:value-of select="format-number(@RiskAmount,'###,##0')" disable-output-escaping="yes"/>
                </td>
                <td>
                  <xsl:value-of select="format-number(@WinAmount,'###,##0')" disable-output-escaping="yes"/>
                </td>
                <td>
                  <xsl:value-of select="@Result" disable-output-escaping="yes"/>
                </td>
                <td>
                  <xsl:value-of select="@User" disable-output-escaping="yes"/>
                </td>
                <td>
                  <xsl:value-of select="@PhoneLine" disable-output-escaping="yes"/>
                </td>
              </tr>
              <xsl:for-each select="Wager">
                <tr>
                  <xsl:attribute name="class">
                    <xsl:choose>
                      <xsl:when test="count(preceding::Wager) mod 2 = 0">TrGameOdd</xsl:when>
                      <xsl:otherwise>TrGameEven</xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                  <td></td>
                  <td>
                    <xsl:value-of select="@IdSport" disable-output-escaping="yes"/>
                  </td>
                  <td>
                    <xsl:value-of select="@Description" disable-output-escaping="yes"/>
                  </td>
                  <td></td>
                  <td></td>
                  <td>
                    <xsl:value-of select="@Result" disable-output-escaping="yes"/>
                  </td>
                  <td>
                    <xsl:if test="@VisitorScore != ''">
                      <xsl:value-of select="@VisitorScore" disable-output-escaping="yes"/> -
                      <xsl:value-of select="@HomeScore" disable-output-escaping="yes"/>
                    </xsl:if>
                  </td>
                  <td></td>
                </tr>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:for-each>
        </table>
        <table cellspacing="0" cellpadding="0" border="0" width="100%">
          <tr class="TbInTitle">
            <td>
              Totals(Win-Lose): <xsl:value-of select="format-number(number(sum(Player/Wager[@Result = 'WIN']/@WinAmount) - sum(Player/Wager[@Result = 'LOSE']/@RiskAmount)),'###,##0')" disable-output-escaping="yes"/>
            </td>
            <td>
              Total Risk: <xsl:value-of select="format-number(sum(Player/Wager/@RiskAmount),'###,##0')" disable-output-escaping="yes"/>
            </td>
            <td align="right">
              Total To Win: <xsl:value-of select="format-number(sum(Player/Wager/@WinAmount),'###,##0')" disable-output-escaping="yes"/>
            </td>
            <td align="right">
              Total Win: <xsl:value-of select="format-number(sum(Player/Wager[@Result = 'WIN']/@WinAmount),'###,##0')" disable-output-escaping="yes"/>
            </td>
            <td align="right">
              Total Lose: <xsl:value-of select="format-number(sum(Player/Wager[@Result = 'LOSE']/@RiskAmount),'###,##0')" disable-output-escaping="yes"/>
            </td>
          </tr>
        </table>
      </xsl:for-each>

      <xsl:if test="count(Agent) > 1">
        <table cellspacing="0" cellpadding="0" border="0" width="100%" class="TbMainAgent">
          <tr class="AgentTitle">
            <td colspan="5">
              Master Agent Totals
            </td>
          </tr>
          <tr class="TbInTitle">
            <td>
              Totals(Win-Lose): <xsl:value-of select="format-number(number(sum(Agent/Player/Wager[@Result = 'WIN']/@WinAmount) - sum(Agent/Player/Wager[@Result = 'LOSE']/@RiskAmount)),'###,##0')" disable-output-escaping="yes"/>
            </td>
            <td>
              Total Risk: <xsl:value-of select="format-number(sum(Agent/Player/Wager/@RiskAmount),'###,##0')" disable-output-escaping="yes"/>
            </td>
            <td align="right">
              Total To Win: <xsl:value-of select="format-number(sum(Agent/Player/Wager/@WinAmount),'###,##0')" disable-output-escaping="yes"/>
            </td>
            <td align="right">
              Total Win: <xsl:value-of select="format-number(sum(Agent/Player/Wager[@Result = 'WIN']/@WinAmount),'###,##0')" disable-output-escaping="yes"/>
            </td>
            <td align="right">
              Total Lose: <xsl:value-of select="format-number(sum(Agent/Player/Wager[@Result = 'LOSE']/@RiskAmount),'###,##0')" disable-output-escaping="yes"/>
            </td>
          </tr>
        </table>
      </xsl:if>
    </xsl:if>

    <xsl:if test="count(Agent) = 0">
      <table cellspacing="0" cellpadding="0" border="0" width="100%">
        <tr class="TbInTitle">
          <td>
            No data.
          </td>
        </tr>
      </table>
    </xsl:if>
</xsl:template>

</xsl:stylesheet> 

