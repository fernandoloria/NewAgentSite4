<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output  method="html" indent="no" encoding="UTF-8" />

  <xsl:template match="//xml">

    <SCRIPT LANGUAGE="JavaScript" SRC="../App_Themes/Classic/CalendarPopup.js"></SCRIPT>

        <SCRIPT LANGUAGE="JavaScript">
          var cal = new CalendarPopup();
        </SCRIPT>
      
          <TABLE CELLSPACING="1" CELLPADDING="1" BORDER="0" >
            <TR>
              <TD>Initial Date:</TD>
              <TD>
                <INPUT style="WIDTH: 100px" TYPE="text" class="form-control form-control-sm" NAME="Date1" value="{@StartDate}" />
                <A HREF="#" onClick="JavaScript:cal.select(document.forms[0].Date1,'anchor1','MM/dd/yyyy'); return false;" NAME="anchor1" ID="anchor1">
                  <IMG SRC="../App_Themes/Classic/images/calendar2.gif" border="0" width="20"/>
                </A>
              </TD>
            </TR>
            <TR>
              <TD>End Date:</TD>
              <TD>
                <INPUT style="WIDTH: 100px" TYPE="text" class="form-control form-control-sm" NAME="Date2" value="{@EndDate}" />
                <A HREF="#" onClick="JavaScript:cal.select(document.forms[0].Date2,'anchor2','MM/dd/yyyy'); return false;" NAME="anchor2" ID="anchor2">
                  <IMG SRC="../App_Themes/Classic/images/calendar2.gif" border="0" width="20"/>
                </A>
              </TD>
              <TD>
                <INPUT type="SUBMIT" class="btn btn-primary"  value="Submit" name="Submit" />
              </TD>
            </TR>
          </TABLE>

          <CENTER>

            <TABLE CELLSPACING="1" CELLPADDING="1" BORDER="0" WIDTH="100%">
              <TR>
                <TD align="center">
                  <STRONG>Sign Up</STRONG>
                </TD>
              </TR>
              <TR>
                <TD align="center">
                  <H4>
                    From <xsl:value-of select="@StartDate"/> To <xsl:value-of select="@EndDate"/>
                  </H4>
                </TD>
              </TR>
            </TABLE>

            <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="100%">
              <TR>
                <TD align="right">
                  First Transaction
                </TD>
              </TR>
            </TABLE>
            <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="100%">
              <TR CLASS="page-titles">
                <TD align="center">Account</TD>
                <TD align="center">Creation Date</TD>
                <TD width="80%">
                  <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="100%" style="table-layout:fixed;">

                    <TR CLASS="page-titles">
                      <TD >Placed Date</TD>
                      <TD >Method</TD>
                      <TD >Reference</TD>
                      <TD >Description</TD>
                      <TD width="7%" align="right">Cash</TD>
                      <TD width="7%" align="right">Fee</TD>
                      <TD width="7%" align="right">Bonus</TD>
                    </TR>
                  </TABLE>
                </TD>
              </TR>
              <xsl:for-each select="detail">
                <TR>
                  <xsl:attribute name="class">
                    <xsl:choose>
                      <xsl:when test="count(preceding::detail) mod 2 = 0">TrGameOdd</xsl:when>
                      <xsl:otherwise>TrGameEven</xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                  <TD>
                    <xsl:value-of select="@player"/>
                  </TD>
                  <TD align="center">
                    <xsl:value-of select="@AccountOpened"/>
                  </TD>
                  <TD>
                    <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="100%" style="border:solid 1px #000000;table-layout:fixed;font-size: 12px;">
                      <TR>
                        <xsl:if test="@description = ''">
                          <TD colspan="4">
                            No Transaction
                          </TD>
                        </xsl:if>
                        <xsl:if test="@description != ''">
                          <TD>
                            <xsl:value-of select="@placeddate"/>
                          </TD>
                          <TD>
                            <xsl:value-of select="@PaymentMethod"/>
                          </TD>
                          <TD>
                            <xsl:value-of select="@reference"/>
                          </TD>
                          <TD>
                            <xsl:value-of select="@description"/>
                          </TD>
                        </xsl:if>
                        <TD width="7%" align="right">
                          <xsl:value-of select="format-number(@amount,'###,##0')"/>
                        </TD>
                        <TD width="7%" align="right">
                          <xsl:value-of select="format-number(@fee,'###,##0')"/>
                        </TD>
                        <TD width="7%" align="right">
                          <xsl:value-of select="format-number(@bonus,'###,##0')"/>
                        </TD>
                      </TR>
                    </TABLE>
                  </TD>
                </TR>
              </xsl:for-each>
            </TABLE>

            <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="100%">
              <TR CLASS="page-titles">
                <TD>
                  Account Total
                </TD>
                <TD>
                  Cash Total
                </TD>
                <TD>
                  Fee Total
                </TD>
                <TD>
                  Bonus Total
                </TD>
              </TR>
              <TR CLASS="TrGameBottom">
                <TD>
                  <xsl:value-of select="format-number(count(detail/@player),'###,##0')"/> Players
                </TD>
                <TD>
                  <xsl:value-of select="format-number(sum(detail/@amount),'###,##0')"/>
                </TD>
                <TD>
                  <xsl:value-of select="format-number(sum(detail/@fee),'###,##0')"/>
                </TD>
                <TD>
                  <xsl:value-of select="format-number(sum(detail/@bonus),'###,##0')"/>
                </TD>
              </TR>
            </TABLE>

          </CENTER>

  </xsl:template>

</xsl:stylesheet>


