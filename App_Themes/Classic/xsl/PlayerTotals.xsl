<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="no" encoding="UTF-8" />

    <xsl:template match="//xml">
                
		<div class="row page-titles">
        <div class="col-md-12 col-12 align-self-center">
            <h3 class="main-title m-b-0 m-t-0">Player Totals</h3>          
        </div>
    </div>
        <div class="row">
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                <div class="form-group">
                                    <label for="Date1">Initial Date:</label><br></br>
                                    <INPUT TYPE="text" class="form-control form-control-sm datepicker" NAME="Date1" value="{@StartDate}" />
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                <div class="form-group">
                                    <label for="Date2">End Date:</label><br></br>
                                    <INPUT TYPE="text" class="form-control form-control-sm datepicker" NAME="Date2" value="{@EndDate}" />
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                <div class="form-group">
                                    <label for="cCurrency">Currency:</label>
                                    <SELECT class="form-control form-control-sm" NAME="cCurrency" OnChange="post();">
                                    <xsl:for-each select="currency">
                                      <OPTION VALUE="{@IdCurrency}">
                                        <xsl:if test="@AgentCurrency='True'">
                                          <xsl:attribute name="Selected">Selected</xsl:attribute>
                                        </xsl:if>
                                        <xsl:value-of select="@Currency" /> (<xsl:value-of select="@Symbol" />)
                                      </OPTION>
                                    </xsl:for-each>
                                  </SELECT>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                <INPUT type="SUBMIT" class="btn btn-primary" style="margin-top:30px;" value="Submit" name="Submit" />
                            </div>
                        </div>
                        <h4 class="card-title">From
                            <xsl:value-of select="@StartDate" /> To
                            <xsl:value-of select="@EndDate" />
                        </h4>

                        <xsl:if test="count(//agent) > 0">

                            <xsl:for-each select="agent">

                                <div class="table-responsive">
                                    <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm">
                                        <THEAD>
                                          <tr class="trAgent">
                                            <th colspan="8">
                                              Agent
                                              <xsl:value-of select="@Agent" />
                                            </th>
                                          </tr>
                                            <TR>
                                                <TH>Player</TH>
                                                <TH>Last Wager</TH>
                                                <TH>Open Bets</TH>
                                                <TH>Graded Bets Amount</TH>
                                                <TH>Win</TH>
                                                <TH>Lose</TH>
                                                <TH>Net</TH>
                                                <TH class="hidden-md-down">Balance</TH>
                                              <TH class="d-lg-none">Bal</TH>
                                            </TR>
                                        </THEAD>
                                        <xsl:for-each select="detail">
                                            <TR>
                                                <TD>
                                                    <xsl:value-of select="@Player" />
                                                </TD>
                                                <TD>
                                                    <xsl:value-of select="@LastWager" />
                                                </TD>
                                                <TD>
                                                    <xsl:value-of select="format-number(@TotalRiskOpen,'###,##0')" />
                                                </TD>
                                                <TD>
                                                    <xsl:value-of select="format-number(@TotalRiskGraded,'###,##0')" />
                                                </TD>
                                                <TD>
                                                    <xsl:value-of select="format-number(@Win,'###,##0')" />
                                                </TD>
                                                <TD>
                                                    <xsl:value-of select="format-number(@Lose,'###,##0')" />
                                                </TD>
                                                <TD>
                                                    <xsl:value-of select="format-number(@Net,'###,##0')" />
                                                </TD>

                                                <TD>
                                                    <xsl:value-of select="format-number(@CurrentBalance,'###,##0')" />
                                                </TD>
                                            </TR>

                                        </xsl:for-each>
                                        <TFOOT>
                                        <TR>
                                            <TD colspan="2" align="left">Agent Totals</TD>
                                            <TD>
                                                <xsl:value-of select="count(detail/@Player)" />
                                            </TD>
                                            <TD>
                                                <xsl:value-of select="format-number(sum(detail/@TotalRiskOpen) + sum(detail/@TotalRiskGraded),'###,##0')" />
                                            </TD>
                                            <TD>
                                                <xsl:value-of select="format-number(sum(detail/@Win),'###,##0')" />
                                            </TD>
                                            <TD>
                                                <xsl:value-of select="format-number(sum(detail/@Lose),'###,##0')" />
                                            </TD>
                                            <TD>
                                                <xsl:value-of select="format-number(sum(detail/@Net),'###,##0')" />
                                            </TD>
                                          <td></td>
                                        </TR>
                                        </TFOOT>
                                    </TABLE>
                                </div>
                            </xsl:for-each>

                        </xsl:if>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet>
