<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output  method="html" indent="no" encoding="UTF-8" />

  <xsl:template match="/*">
    <CENTER>
      <TABLE class="tblWeeklyBalance table color-table success-table table-bordered  table-sm table-responsive">
		  <TR CLASS="page-titles">
			  <th class="ticket">Placed</th>
			  <th class="user">User</th>
			  <th class="gamedate">Game Date</th>
			  <th class="sport">Sport</th>
			  <th class="description">Description</th>
			  <th class="riskwin">Amount</th>
			  <th class="riskwin">Risk/Win</th>
			  <th class="delete">Result</th>
		  </TR>
        <xsl:for-each select="historybet">
          <TR>
            <xsl:attribute name="class">
              <xsl:choose>
                <xsl:when test="count(preceding::historybet) mod 2 = 0">TrGameOdd</xsl:when>
                <xsl:otherwise>TrGameEven</xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <TD ALIGN="center">
				<xsl:value-of disable-output-escaping="yes" select="@Text8"
/>
            </TD>
            <TD>
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
              <xsl:value-of disable-output-escaping="yes" select="@Text6 + @TTaxAmount"/>

            </TD>
			 <TD>

			 <xsl:value-of disable-output-escaping="yes" select="format-number(@TRisk,'###,##0')"/>/<xsl:value-of disable-output-escaping="yes" select="format-number(@TWin,'###,##0')"/>
            </TD>
            <xsl:if test="@Score != ''">
              <TD>
                <a href="javascript:GetScore({@Score});" title="View Games Score">
                  <xsl:value-of disable-output-escaping="yes" select="@Text7"/>
                </a>
			 
              </TD>
            </xsl:if>
            <xsl:if test="@Score = ''">
              <TD>
                <xsl:value-of disable-output-escaping="yes" select="@Text7"/> 
              </TD>
            </xsl:if>


          </TR>
        </xsl:for-each>
        <xsl:if test="count(//historybet)=0">
          <TR>
            <TD CLASS="TrGameBottom" COLSPAN="9" align="center"> No History Wagers</TD>
          </TR>
        </xsl:if>
        <xsl:if test="count(//historybet)!=0">
			<TR CLASS="TrGameBottom">
				<TD><xsl:value-of disable-output-escaping="yes" select="count(//historybet/@Text1)"/> Tickets</TD>
				<TD></TD>
			    <TD></TD>
			    <TD></TD>
			    <TD></TD>
			    <TD><xsl:value-of disable-output-escaping="yes" select="format-number(sum(//historybet/@Text6) + sum(//historybet/@TTaxAmount),'###,##0')"/></TD>
				<TD>
					<xsl:value-of disable-output-escaping="yes" select="format-number(sum(//historybet/@TRisk),'###,##0')"/> / <xsl:value-of disable-output-escaping="yes" select="format-number(sum(//historybet/@TWin),'###,##0')"/>
				</TD>
				<TD></TD>
			</TR>
    <TR CLASS="TrGameBottom">
            
            <TD colspan="8">
              <xsl:value-of disable-output-escaping="yes" select="count(//historybet/@Text1)"/> Bet(s) -
              Total Risk: <xsl:value-of disable-output-escaping="yes" select="format-number(sum(//historybet/@TRisk),'###,##0')"/>
              Total Win: <xsl:value-of disable-output-escaping="yes" select="format-number(sum(//historybet/@TWin),'###,##0')"/>
              Total Win/Lost: <xsl:value-of disable-output-escaping="yes" select="format-number(sum(//historybet/@Text6) + sum(//historybet/@TTaxAmount),'###,##0')"/>
			  Hold Percent <xsl:value-of disable-output-escaping="yes" select="format-number((sum(//historybet/@Text6) + sum(//historybet/@TTaxAmount)) div sum(//historybet/@TRisk),'###,##0 %')"/>
              (<xsl:value-of disable-output-escaping="yes" select="//xml/@StartDate"/> thru <xsl:value-of disable-output-escaping="yes" select="//xml/@EndDate"/>)
            </TD>
          </TR>
        </xsl:if>
      </TABLE>

      <div>
		  <input type="button" class="btn btn-danger" value="Close"  data-bs-dismiss="modal" />
      </div>

    </CENTER>
  </xsl:template>

</xsl:stylesheet>
