<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output  method="html" indent="no" encoding="UTF-8" />

  <xsl:template match="//xml">

        
    
<input type="hidden" name="hNegativeXFER" id="hNegativeXFER" value="{@NegativeBalanceXFER}" />
    <input type="hidden" name="hCurrentBalance" id="hCurrentBalance" value="{@CurrentBalance}" />
    <input type="hidden" name="hAgentToDist" id="hAgentToDist" value="{@Distributor}" />
    <center>
    <TABLE CELLSPACING="0" CELLPADDING="3" BORDER="0" style="border:solid 1px #000;">
      <TR CLASS="GameHeader">
        <TD colspan="2" align="center">AGENT TRANSACTION</TD>
      </TR>
      <TR CLASS="TrGameEven">
        <TD colspan="2" align="right" style="border-bottom:solid 1px #000;">
          Current Balance: <xsl:value-of select="format-number(@CurrentBalance,'###,##0')"/>
        </TD>
      </TR>
      <TR>
        <TD valign="top" colspan="2">
          <xsl:value-of select="@Agent"/> XFER TO
        </TD>
      </TR>
      <xsl:if test="count(detail) > 0">
        <TR>
          <TD align="right">Agent To Transfer:</TD>
          <TD align="left" valign="top">
            <SELECT class="form-control form-control-sm"  NAME="cAgentTo" id="cAgentTo" style="width:155px;">
              <xsl:for-each select="detail">
                <OPTION VALUE="{@IdAgent}">
                  <xsl:value-of select="@Agent" />
                </OPTION>
              </xsl:for-each>
            </SELECT>
          </TD>
        </TR>
      </xsl:if>
      <xsl:if test="@Distributor != '-1'">
        <TR>
          <TD></TD>
          <TD align="left" valign="top">
            <input type="checkbox" name="ToDistributor" id="ToDistributor" >
              <xsl:if test="count(detail) = 0">
                <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
              </xsl:if>
              Send Transfer To Distributor
            </input>
          </TD>
        </TR>
      </xsl:if>
      <TR>
        <TD align="right">Amount:</TD>
        <TD align="left">
          <input TYPE="text" class="form-control form-control-sm" id="txtAmount" name="txtAmount" style="width:100px;" />
          <xsl:value-of select="@Currency"/>
        </TD>
      </TR>
      <TR>
        <TD align="right" valign="top">Reference:</TD>
        <TD align="left">
          <textarea name="txtReference" id="txtReference" rows="3" style="width:150px;"></textarea>
        </TD>
      </TR>
      <TR>
        <TD align="right">Payment Method:</TD>
        <TD align="left">
          <SELECT class="form-control form-control-sm"  NAME="cPaymentMethod" style="width:155px;">
            <xsl:for-each select="PMCombo">
              <OPTION VALUE="{@Id}">
                <xsl:value-of select="@Description" />
              </OPTION>
            </xsl:for-each>
          </SELECT>
        </TD>
      </TR>
      <TR CLASS="GameHeader">
        <TD colspan="2" style="border-top:solid 1px #000;">
          <input type="button" value="Cancel" data-bs-dismiss="modal" />
          <input type="button" value="Save" onclick="ValidateInfo();"/>
        </TD>
      </TR>
    </TABLE>
    </center>
  </xsl:template>

</xsl:stylesheet>