<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="no" encoding="UTF-8" />

    <xsl:template match="//xml">


		<div class="row">
			<div class="page-titles">
				<h4>Agent Distribution</h4>
			</div>
		</div>
        <div class="row">
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                <div class="form-group">
                                    <label for="Date1">Date Week:</label><br></br>
                                    <INPUT TYPE="text" class="form-control form-control-sm datepicker" NAME="Date1" value="{//xml/@StartDate}" />
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                <div class="form-group">
                                    <label for="cCurrency">Currency:</label><br></br>
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
                                <div class="form-group">
                                    <INPUT type="SUBMIT" class="btn btn-primary" style="margin-top:28px;" value="Submit" name="Submit" />
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                <div class="form-group">

                                </div>
                            </div>
                        </div>

                        <h4 class="card-title">Distribution</h4>
                        <div class="table-responsive">
                            <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm hidden-md-down">
                                <THEAD>
                                    <TR>
                                        <TH>Agent</TH>
                                        <TH>Make Up</TH>
                                        <TH>This Week</TH>
                                        <TH>Net Week</TH>
                                        <TH>Comm</TH>
                                        <TH>Distributor</TH>
                                        <TH>Dist Week</TH>
                                        <TH>New MU</TH>
                                        <TH>Prev Bal</TH>
                                        <TH>New Bal</TH>
                                        <TH>Type</TH>
                                    </TR>
                                </THEAD>
                                <xsl:for-each select="detail">
                                    <TR>
                                        <TD>
                                            <xsl:value-of disable-output-escaping="yes" select="@Agent" />
                                        </TD>
                                        <TD>
                                            <xsl:value-of disable-output-escaping="yes" select="format-number(@MakeUp,'###,##0')" />
                                        </TD>
                                        <TD>
                                            <xsl:value-of disable-output-escaping="yes" select="format-number(@TotalTransaction,'###,##0')" />
                                        </TD>
                                        <TD>
                                            <xsl:value-of disable-output-escaping="yes" select="format-number(@TotalTransaction,'###,##0')" />
                                        </TD>
                                        <TD>
                                            <xsl:value-of disable-output-escaping="yes" select="format-number(@TotalMoneyComm,'###,##0')" />
                                        </TD>
                                        <TD>
                                            <xsl:value-of disable-output-escaping="no" select="@AgentDist" />
                                        </TD>
                                        <TD>
                                            <xsl:value-of disable-output-escaping="yes" select="format-number(@DistWeek,'###,##0')" />
                                        </TD>
                                        <TD>
                                            <xsl:value-of disable-output-escaping="yes" select="format-number(@NewMakeUp,'###,##0')" />
                                        </TD>
                                        <TD>
                                            <xsl:value-of disable-output-escaping="yes" select="format-number(@PrevBalance,'###,##0')" />
                                        </TD>
                                        <TD>
                                            <xsl:value-of disable-output-escaping="yes" select="format-number(@NewBalance,'###,##0')" />
                                        </TD>
                                        <xsl:if test="@DontXfer = 'False'">
                                            <TD>
                                                <xsl:value-of disable-output-escaping="yes" select="@AgentType" /> SX
                                                <xsl:value-of disable-output-escaping="yes" select="format-number(@SportComm,'#0')" />%
                                            </TD>
                                        </xsl:if>
                                        <xsl:if test="@DontXfer = 'True'">
                                            <TD>
                                                <xsl:value-of disable-output-escaping="yes" select="@AgentType" /> FX
                                                <xsl:value-of disable-output-escaping="yes" select="format-number(@SportComm,'#0')" />%
                                            </TD>
                                        </xsl:if>
                                    </TR>
                                </xsl:for-each>
                                <TR>
                                    <TD COLSPAN="11"></TD>
                                </TR>
                            </TABLE>

                          <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm d-lg-none">
                            <THEAD>
                              <TR class="GameHeader">
                                <TH>Agent</TH>
                                <TH>Make Up</TH>
                                <TH>This Week</TH>
                                <TH>Net Week</TH>
                                <TH>Comm</TH>
                                <TH>Dist Week</TH>
                                <TH>New MU</TH>
                                <TH>Prev Bal</TH>
                                <TH>New Bal</TH>
                              </TR>
                            </THEAD>
                            <xsl:for-each select="detail">
                              <TR>
                                <TD>
                                  <xsl:value-of disable-output-escaping="yes" select="@Agent" />
                                  <br/>
                                  <xsl:if test="@DontXfer = 'False'">
                                      <xsl:value-of disable-output-escaping="yes" select="@AgentType" /> SX
                                      <xsl:value-of disable-output-escaping="yes" select="format-number(@SportComm,'#0')" />%
                                  </xsl:if>
                                  <xsl:if test="@DontXfer = 'True'">
                                      <xsl:value-of disable-output-escaping="yes" select="@AgentType" /> FX
                                      <xsl:value-of disable-output-escaping="yes" select="format-number(@SportComm,'#0')" />%
                                  </xsl:if>
                                  <br/>
                                  (<xsl:value-of disable-output-escaping="no" select="@AgentDist" />)
                                </TD>
                                <TD>
                                  <xsl:value-of disable-output-escaping="yes" select="format-number(@MakeUp,'###,##0')" />
                                </TD>
                                <TD>
                                  <xsl:value-of disable-output-escaping="yes" select="format-number(@TotalTransaction,'###,##0')" />
                                </TD>
                                <TD>
                                  <xsl:value-of disable-output-escaping="yes" select="format-number(@TotalTransaction,'###,##0')" />
                                </TD>
                                <TD>
                                  <xsl:value-of disable-output-escaping="yes" select="format-number(@TotalMoneyComm,'###,##0')" />
                                </TD>
                                
                                <TD>
                                  <xsl:value-of disable-output-escaping="yes" select="format-number(@DistWeek,'###,##0')" />
                                </TD>
                                <TD>
                                  <xsl:value-of disable-output-escaping="yes" select="format-number(@NewMakeUp,'###,##0')" />
                                </TD>
                                <TD>
                                  <xsl:value-of disable-output-escaping="yes" select="format-number(@PrevBalance,'###,##0')" />
                                </TD>
                                <TD>
                                  <xsl:value-of disable-output-escaping="yes" select="format-number(@NewBalance,'###,##0')" />
                                </TD>
                                
                              </TR>
                            </xsl:for-each>
                          </TABLE>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet>
