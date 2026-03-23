<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output  method="html" indent="no" encoding="UTF-8" />

  <xsl:template match="//xml">

    <SCRIPT LANGUAGE="JavaScript">
      function post(){
      var Currency = document.getElementById('cCurrency');
      var HCurrency = document.getElementById('hCurrency');

      HCurrency.value = Currency.value;

      document.forms[0].submit();
      }
    </SCRIPT>
    
    <input type="hidden" value="{//xml/@StartDate}" name="hStartDate" id="hStartDate"/>
    <input type="hidden" value="{//xml/@EndDate}" name="hEndDate" id="hEndDate"/>
    <input type="hidden" value="{//xml/@IdGame}" name="hGame" id="hGame"/>
    <input type="hidden" value="" name="hCurrency" id="hCurrency"/>

        <CENTER>
          <div>
            <font size="2">
              <strong>Agent Position Detail</strong>
            </font>

            <H4>
              <STRONG>
                From <xsl:value-of select="//xml/@StartDate"/> To <xsl:value-of select="//xml/@EndDate"/>
              </STRONG>
            </H4>
          </div>

          <TABLE CELLSPACING="0" CELLPADDING="1" BORDER="0" align="left">
            <TR>
              <TD>Currency:</TD>
              <TD>
                <SELECT class="form-control form-control-sm"  NAME="cCurrency" id="cCurrency" OnChange="post();">
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
            </TR>
          </TABLE>

          <TABLE CELLSPACING="0" CELLPADDING="1" BORDER="0" WIDTH="100%" >
            <TR CLASS="GameHeader">
              <TD CLASS="TdSpace"></TD>
              <TD ALIGN="left">
                <B>Player</B>
              </TD>
              <TD ALIGN="right">
                <B>Ticket#</B>
              </TD>
              <TD ALIGN="right">
                <B>Placed Date</B>
              </TD>
              <TD ALIGN="right">
                <B>Line</B>
              </TD>
              <TD ALIGN="right">
                <B>Amount</B>
              </TD>
              <TD ALIGN="right">
                <B>Risk</B>
              </TD>
              <TD ALIGN="right">
                <B>To Win</B>
              </TD>
              <TD CLASS="TdSpace"></TD>
            </TR>
            <xsl:for-each select="//wager">
              <TR>
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="count(preceding::wager) mod 2 = 0">TrGameOdd</xsl:when>
                    <xsl:otherwise>TrGameEven</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <TD CLASS="TdSpace"></TD>
                <TD ALIGN="Left">
                  <xsl:value-of select="@Player"/>(<xsl:value-of select="@Password"/>)
                </TD>
                <TD ALIGN="right">
                  <xsl:value-of select="@TicketNumber"/>
                </TD>
                <TD ALIGN="right">
                  <xsl:value-of select="@PlacedDate"/>
                </TD>
                <TD ALIGN="right">
                  <xsl:value-of disable-output-escaping="yes" select="@CompleteDescription"/>
                </TD>
                <TD ALIGN="right">
                  <xsl:value-of select="format-number(@WagerAmount, '###,###')"/>
                </TD>
                <TD ALIGN="right">
                  <xsl:value-of select="format-number(@RiskAmount, '###,###')"/>
                </TD>
                <TD ALIGN="right">
                  <xsl:value-of select="format-number(@WinAmount, '###,###')"/>
                </TD>
                <TD CLASS="TdSpace"></TD>
              </TR>
            </xsl:for-each>
            <tr CLASS="TrGameBottom">
              <TD ALIGN="right" COLSPAN="5">
                <B>Total</B>
              </TD>
              <TD ALIGN="right">
                <B>
                  <xsl:value-of select="format-number(sum(//@WagerAmount), '###,###')"/>
                </B>
              </TD>
              <TD ALIGN="right">
                <B>
                  <xsl:value-of select="format-number(sum(//@RiskAmount), '###,###')"/>
                </B>
              </TD>
              <TD ALIGN="right">
                <B>
                  <xsl:value-of select="format-number(sum(//@WinAmount), '###,###')"/>
                </B>
              </TD>
              <TD CLASS="TdSpace"></TD>
            </tr>
          </TABLE>
          <INPUT TYPE="button" data-bs-dismiss="modal" VALUE="Close"/>
        </CENTER>
  </xsl:template>

</xsl:stylesheet>
