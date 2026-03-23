<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output  method="html" indent="no" encoding="UTF-8" />

  <xsl:template match="//xml">
    
        <CENTER>
            <h4 class="card-title">Agent Exposure Detail</h4>

          <div class="table-responsive">
            <TABLE class="table color-table success-table table-bordered table-striped table-sm">
            <thead>
            <TR>
              <TH></TH>
              <TH>Player</TH>
              <TH>Ticket#</TH>
              <TH>Placed Date</TH>
              <TH>Line</TH>
              <TH>Risk</TH>
              <TH>To Win</TH>
              <TH></TH>
            </TR>
            </thead>
            <xsl:for-each select="//detail">
              <TR>
                <TD></TD>
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
                <TD>
                  <xsl:value-of select="format-number(@RiskAmount,'###,###')" />
                </TD>
                <TD>
                  <xsl:value-of select="format-number(@WinAmount,'###,###')" />
                </TD>
                <TD></TD>
              </TR>
            </xsl:for-each>
            <TR>
              <TD colspan="5">
                <B>Total</B>
              </TD>
              <TD>
                <B>
                  <xsl:value-of select="format-number(sum(//detail/@RiskAmount),'###,###')" />
                </B>
              </TD>
              <TD>
                <B>
                  <xsl:value-of select="format-number(sum(//detail/@WinAmount),'###,###')" />
                </B>
              </TD>
              <TD></TD>
            </TR>
          </TABLE>
            </div>
          <INPUT TYPE="button" class="btn btn-default" data-bs-dismiss="modal" VALUE="Close"/>
        </CENTER>
      </xsl:template>

</xsl:stylesheet>

