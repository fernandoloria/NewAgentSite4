<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="no" encoding="UTF-8" />

    <xsl:template match="//xml">
        <SCRIPT LANGUAGE="JavaScript" SRC="../App_Themes/Classic/CalendarPopup.js"></SCRIPT>

        <div class="row page-titles">
        <div class="col-md-12 col-12 align-self-center">
            <h3 class="main-title m-b-0 m-t-0">Web Vs Phone</h3>          
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
                                    <label for="Date1">Currency:</label><br></br>
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
                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
                                <div class="form-group">
                                    <INPUT type="SUBMIT" class="btn btn-primary" style="margin-top:28px;" value="Submit" name="Submit" />
                                </div>
                            </div>
                        </div>

                            <h4 class="card-title">
                                <xsl:value-of select="@StartDate" /> to <xsl:value-of select="@EndDate" />
                            </h4>
                            <div class="table-responsive">
                                <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm hidden-md-down">
                                    <THEAD>
                                    <TR>
                                        <TH>Agent</TH>
                                        <TH>Phone Volume</TH>
                                        <TH>Phone Bets</TH>
                                        <TH>Phone Players</TH>
                                        <TH>On Line Volume</TH>
                                        <TH>On Line Bets</TH>
                                        <TH>On Line Players</TH>
                                        <TH>Casino Volume</TH>
                                        <TH>Casino Bets</TH>
                                        <TH>Casino Players</TH>
                                    </TR>
                                    </THEAD>

                                    <xsl:if test="count(//detail) > 0">
                                        <xsl:for-each select="detail">
                                            <TR>
                                                <TD>
                                                    <xsl:value-of select="@Agent" />
                                                </TD>
                                                <TD>
                                                    <xsl:value-of select="format-number(@PhoneVol,'###,##0')" />
                                                </TD>
                                                <TD>
                                                    <xsl:value-of select="@PhoneCount" />
                                                </TD>
                                                <TD>
                                                    <xsl:value-of select="@PhonePlayers" />
                                                </TD>
                                                <TD>
                                                    <xsl:value-of select="format-number(@OnLineVol,'###,##0')" />
                                                </TD>
                                                <TD>
                                                    <xsl:value-of select="@OnLineCount" />
                                                </TD>
                                                <TD>
                                                    <xsl:value-of select="@OnLinePlayers" />
                                                </TD>
                                                <TD>
                                                    <xsl:value-of select="format-number(@CasinoVol,'###,##0')" />
                                                </TD>
                                                <TD>
                                                    <xsl:value-of select="@CasinoCount" />
                                                </TD>
                                                <TD>
                                                    <xsl:value-of select="@CasinoPlayers" />
                                                </TD>
                                            </TR>
                                        </xsl:for-each>
                                    </xsl:if>
                                    <TR CLASS="TrGameBottom">
                                        <TD colspan="9"></TD>
                                    </TR>
                                </TABLE>

                              <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm d-lg-none">
                                <THEAD>
                                  <TR>
                                    <TH>Agent</TH>
                                    <TH>Type</TH>
                                    <TH>Volume</TH>
                                    <TH>Bets</TH>
                                    <TH>Player</TH>
                                  </TR>
                                </THEAD>

                                <xsl:if test="count(//detail) > 0">
                                  <xsl:for-each select="detail">
                                    <TR>
                                      <TD>
                                        <xsl:value-of select="@Agent" />
                                      </TD>
                                      <TD>
                                        Phone
                                        <br/>
                                        Online
                                        <br/>
                                        Casino
                                      </TD>
                                      <TD>
                                        <xsl:value-of select="format-number(@PhoneVol,'###,##0')" />
                                        <xsl:value-of select="format-number(@OnLineVol,'###,##0')" />
                                        <xsl:value-of select="format-number(@CasinoVol,'###,##0')" />
                                      </TD>
                                      <TD>
                                        <xsl:value-of select="@PhoneCount" />
                                        <xsl:value-of select="@OnLineCount" />
                                        <xsl:value-of select="@CasinoCount" />
                                      </TD>
                                      <TD>
                                        <xsl:value-of select="@PhonePlayers" />
                                        <xsl:value-of select="@OnLinePlayers" />
                                        <xsl:value-of select="@CasinoPlayers" />
                                      </TD>
                                    </TR>
                                  </xsl:for-each>
                                </xsl:if>
                              </TABLE>
                            </div>
                            <xsl:if test="//xml/@Distributor = 'True' and count(//detail) > 0">

                                <div class="table-responsive">
                                    <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm hidden-md-down">
                                        <THEAD>
                                            <TR>
                                            <TH>Totals</TH>
                                            <TH>Phone Volume</TH>
                                            <TH>Phone Bets</TH>
                                            <TH>Phone Players</TH>
                                            <TH>On Line Volume</TH>
                                            <TH>On Line Bets</TH>
                                            <TH>On Line Players</TH>
                                            <TH>Casino Volume</TH>
                                            <TH>Casino Bets</TH>
                                            <TH>Casino Players</TH>
                                        </TR>
                                        </THEAD>
                                        <TR CLASS="TrGameEven">
                                            <TD>
                                                <xsl:value-of select="//xml/@Agent" />
                                            </TD>
                                            <TD>
                                                <xsl:value-of select="format-number(sum(detail/@PhoneVol),'###,##0')" />
                                            </TD>
                                            <TD>
                                                <xsl:value-of select="format-number(sum(detail/@PhoneCount),'###,##0')" />
                                            </TD>
                                            <TD>
                                                <xsl:value-of select="format-number(sum(detail/@PhonePlayers),'###,##0')" />
                                            </TD>
                                            <TD>
                                                <xsl:value-of select="format-number(sum(detail/@OnLineVol),'###,##0')" />
                                            </TD>
                                            <TD>
                                                <xsl:value-of select="format-number(sum(detail/@OnLineCount),'###,##0')" />
                                            </TD>
                                            <TD>
                                                <xsl:value-of select="format-number(sum(detail/@OnLinePlayers),'###,##0')" />
                                            </TD>
                                            <TD>
                                                <xsl:value-of select="format-number(sum(detail/@CasinoVol),'###,##0')" />
                                            </TD>
                                            <TD>
                                                <xsl:value-of select="format-number(sum(detail/@CasinoCount),'###,##0')" />
                                            </TD>
                                            <TD>
                                                <xsl:value-of select="format-number(sum(detail/@CasinoPlayers),'###,##0')" />
                                            </TD>
                                        </TR>

                                    </TABLE>

                                  <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm d-lg-none">
                                    <THEAD>
                                      <TR>
                                        <TH>Totals</TH>
                                        <TH>Type</TH>
                                        <TH>Volume</TH>
                                        <TH>Bets</TH>
                                        <TH>Players</TH>
                                      </TR>
                                    </THEAD>
                                    <TR CLASS="TrGameEven">
                                      <TD>
                                        <xsl:value-of select="//xml/@Agent" />
                                      </TD>
                                      <TD>
                                        Phone
                                        <br/>
                                        Online
                                        <br/>
                                        Casino
                                      </TD>
                                      <TD>
                                        <xsl:value-of select="format-number(sum(detail/@PhoneVol),'###,##0')" />
                                        <br/>
                                        <xsl:value-of select="format-number(sum(detail/@OnLineVol),'###,##0')" />
                                        <br/>
                                        <xsl:value-of select="format-number(sum(detail/@CasinoVol),'###,##0')" />
                                      </TD>
                                      <TD>
                                        <xsl:value-of select="format-number(sum(detail/@PhoneCount),'###,##0')" />
                                        <br/>
                                        <xsl:value-of select="format-number(sum(detail/@OnLineCount),'###,##0')" />
                                        <br/>
                                        <xsl:value-of select="format-number(sum(detail/@CasinoCount),'###,##0')" />
                                      </TD>
                                      <TD>
                                        <xsl:value-of select="format-number(sum(detail/@PhonePlayers),'###,##0')" />
                                        <br/>
                                        <xsl:value-of select="format-number(sum(detail/@OnLinePlayers),'###,##0')" />
                                        <br/>
                                        <xsl:value-of select="format-number(sum(detail/@CasinoPlayers),'###,##0')" />
                                      </TD>
                                    </TR>

                                  </TABLE>
                                </div>
                            </xsl:if>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet>
