<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="no" encoding="UTF-8" />

    <xsl:template match="//DATA">
        
		
<div class="row page-titles">
            <div 
class="col-md-12 col-12 align-self-center"
>
                <h3 
class="main-title m-b-0 m-t-0"
>Agent Commission
</h3>          
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                <div class="form-group">
                                    <label for="Date1">Select Week:</label><br></br>
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-info dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            Week Of
                                        </button>
                                        <div class="dropdown-menu" x-placement="bottom-start" style="position: absolute; transform: translate3d(0px, 33px, 0px); top: 0px; left: 0px; will-change: transform;">
                                            <a class="dropdown-item" href="AgentCommission.aspx?Date1={//DATA/@STARTDATE1}">This week</a>
                                            <a class="dropdown-item" href="AgentCommission.aspx?Date1={//DATA/@STARTDATE7}">Last week</a>
                                            <a class="dropdown-item" href="AgentCommission.aspx?Date1={//DATA/@STARTDATE14}">2 weeks ago</a>
                                            <a class="dropdown-item" href="AgentCommission.aspx?Date1={//DATA/@STARTDATE21}">3 weeks ago</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                <div class="form-group">
                                    <label for="Date1">Day Week Date:</label>
                                    <INPUT TITLE="The Format is mm/dd/yyyy ej: 7/15/2002 for July 15 2002" TYPE="text" class="form-control form-control-sm datepicker" NAME="Date1" value="{//DATA/@STARTDATE}" />
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                <div class="form-group">
                                    <label for="cCurrency">Currency:</label>
                                    <SELECT class="form-control form-control-sm" NAME="cCurrency" OnChange="post();">
                                      <xsl:for-each select="currency">
                                        <OPTION VALUE="{@IdCurrency}">
                                          <xsl:if test="@AgentCurrency='1'">
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
                                    <div class="form-group">
                                        <INPUT type="SUBMIT" class="btn btn-primary" style="margin-top:28px;" value="Submit" name="Submit" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <h4 class="card-title">Agent weekly Balance -
                            <BR />
                            <xsl:value-of select="//DATA/@STARTDATE" /> To
                            <xsl:value-of select="//DATA/@ENDDATE" />
                        </h4>
                        <xsl:for-each select="//AGENT">
                            <xsl:if test="@HasDetail = '0' and @Root = '0'">
                                <xsl:call-template name="SimpleAgent" />
                            </xsl:if>
                            <xsl:if test="@HasDetail = '0' and @Root = '1'">
                                <xsl:call-template name="SimpleAgentMaster" />
                            </xsl:if>
                            <xsl:if test="@HasDetail = '1'">
                                <xsl:call-template name="DistAgent" />
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:if test="@MASTER = '1' or @DIST = 'True'">
                            <xsl:call-template name="MasterEnd" />
                        </xsl:if>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template name="SimpleAgentMaster">

        <xsl:if test="count(DETAIL)>0">
            <div class="table-responsive">
                <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm hidden-md-down ">
                    <THEAD class="trAgent">
                         <TR class="trAgent">
                            <TH colspan="14">
                                Agent
                                <xsl:value-of select="@Agent" />
                            </TH>
                        </TR>
                        <TR>
                            <TH WIDTH="10%">Player</TH>
                            <TH WIDTH="10%">Fwd</TH>
                            <xsl:for-each select="//WEEK">
                                <xsl:for-each select="@*">
                                    <TH>
                                        <xsl:value-of select="." />
                                    </TH>
                                </xsl:for-each>
                            </xsl:for-each>
                            <TH>Week</TH>
                            <TH>Pmts</TH>
                            <TH>Balance</TH>
                            <TH>Settled</TH>
                        </TR>
                    </THEAD>
                    <xsl:for-each select="DETAIL">
                        <TR>
                            <TD>
                                <xsl:value-of select="concat(@Player,' ')" /><br/>
                                <xsl:value-of select="@Password" />
                            </TD>
                            <xsl:if test="name() != 'Player' and name() != 'Password'">
                                <TD>
                                    <xsl:value-of select="format-number(@BalFwd,'###,##0')" />
                                </TD>
                                <TD>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                                        <xsl:choose>
                                            <xsl:when test="@Week1 != 0">
                                                <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',1);">
                                                    <xsl:value-of select="format-number(@Week1,'###,##0')" />
                                                </a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-number(@Week1,'###,##0')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                                        <xsl:value-of select="format-number(@Week1,'###,##0')" />
                                    </xsl:if>
                                </TD>
                                <TD>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                                        <xsl:choose>
                                            <xsl:when test="@Week2 != 0">
                                                <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',2);">
                                                    <xsl:value-of select="format-number(@Week2,'###,##0')" />
                                                </a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-number(@Week2,'###,##0')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                                        <xsl:value-of select="format-number(@Week2,'###,##0')" />
                                    </xsl:if>
                                </TD>
                                <TD>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                                        <xsl:choose>
                                            <xsl:when test="@Week3 != 0">
                                                <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',3);">
                                                    <xsl:value-of select="format-number(@Week3,'###,##0')" />
                                                </a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-number(@Week3,'###,##0')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                                        <xsl:value-of select="format-number(@Week3,'###,##0')" />
                                    </xsl:if>
                                </TD>
                                <TD>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                                        <xsl:choose>
                                            <xsl:when test="@Week4 != 0">
                                                <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',4);">
                                                    <xsl:value-of select="format-number(@Week4,'###,##0')" />
                                                </a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-number(@Week4,'###,##0')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                                        <xsl:value-of select="format-number(@Week4,'###,##0')" />
                                    </xsl:if>
                                </TD>
                                <TD>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                                        <xsl:choose>
                                            <xsl:when test="@Week5 != 0">
                                                <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',5);">
                                                    <xsl:value-of select="format-number(@Week5,'###,##0')" />
                                                </a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-number(@Week5,'###,##0')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                                        <xsl:value-of select="format-number(@Week5,'###,##0')" />
                                    </xsl:if>
                                </TD>
                                <TD>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                                        <xsl:choose>
                                            <xsl:when test="@Week6 != 0">
                                                <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',6);">
                                                    <xsl:value-of select="format-number(@Week6,'###,##0')" />
                                                </a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-number(@Week6,'###,##0')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                                        <xsl:value-of select="format-number(@Week6,'###,##0')" />
                                    </xsl:if>
                                </TD>
                                <TD>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                                        <xsl:choose>
                                            <xsl:when test="@Week7 != 0">
                                                <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',7);">
                                                    <xsl:value-of select="format-number(@Week7,'###,##0')" />
                                                </a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-number(@Week7,'###,##0')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                                        <xsl:value-of select="format-number(@Week7,'###,##0')" />
                                    </xsl:if>
                                </TD>
                                <TD>
                                    <xsl:value-of select="format-number(@ThisWeek,'###,##0')" />
                                </TD>
                                <TD>
                                    <xsl:value-of select="format-number(@Pmts,'#####0')" />
                                </TD>
                                <TD>
                                    <xsl:value-of select="format-number(@Balance,'#####0')" />
                                </TD>
                                <TD>
                                    <xsl:value-of select="format-number(@Settled,'#####0')" />
                                </TD>
                            </xsl:if>
                        </TR>
                    </xsl:for-each>
                    <TR>
                        <TD COLSPAN="14">
                            <B>
                              Total Players <xsl:value-of select="concat(' ', @TPlayers)" />
                              Total Active <xsl:value-of select="concat(' ', @TActive)" />
                            </B>
                        </TD>
                    </TR>
                    <TR>
                        <TD height="10"></TD>
                    </TR>
                    <!--Agent totals-->
                    <TR>
                        <TD colspan="2">
                            <B>
              Agent <xsl:value-of select="@Agent" /> Totals:
            </B>
                        </TD>
                        <xsl:for-each select="TOTAL">
                            <TD>
                                <B>
                <xsl:value-of select="@MasterTotal1" />
              </B>
                            </TD>
                            <TD>
                                <B>
                <xsl:value-of select="@MasterTotal2" />
              </B>
                            </TD>
                            <TD>
                                <B>
                <xsl:value-of select="@MasterTotal3" />
              </B>
                            </TD>
                            <TD>
                                <B>
                <xsl:value-of select="@MasterTotal4" />
              </B>
                            </TD>
                            <TD>
                                <B>
                <xsl:value-of select="@MasterTotal5" />
              </B>
                            </TD>
                            <TD>
                                <B>
                <xsl:value-of select="@MasterTotal6" />
              </B>
                            </TD>
                            <TD>
                                <B>
                <xsl:value-of select="@MasterTotal7" />
              </B>
                            </TD>
                            <TD>
                                <B>
                <xsl:value-of select="@MasterThisWeek" />
              </B>
                            </TD>
                            <TD colspan="3"></TD>

                        </xsl:for-each>
                    </TR>
                    <TR>
                        <TD colspan="14"></TD>
                    </TR>
                    <!--Agent commissions-->
                    <xsl:if test="@AgentType = '2'">
                        <TR>
                            <TD colspan="9">
                                <B>Commission: </B>
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@TotalComm,'###,##0')" />
                            </TD>
                        </TR>
                        <TR>
                            <TD colspan="9">
                                <B>New MakeUp: 3</B>
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@NewMakeUp,'###,##0')" />
                            </TD>
                        </TR>
                    </xsl:if>
                    <xsl:if test="@AgentType != '2'">
                        <TR>
                            <TD colspan="2">
                                <B>Sports Commission: </B>
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterSComm1,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterSComm2,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterSComm3,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterSComm4,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterSComm5,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterSComm6,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterSComm7,'###,##0')" />
                            </TD>
                            <TD>
                                <b>
                                <xsl:value-of select="format-number(@SportComm,'###,##0')" />
                              </b>
                            </TD>
                            <TD colSpan="2" rowspan="3">
                                <B>Total Commission: </B>
                            </TD>
                            <TD  rowspan="3">
                                <xsl:value-of select="format-number(@TotalComm,'###,##0')" />
                            </TD>
                        </TR>
                        <TR>
                            <TD colspan="2">
                                <B>Casino Commission: </B>
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterCComm1,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterCComm2,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterCComm3,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterCComm4,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterCComm5,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterCComm6,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterCComm7,'###,##0')" />
                            </TD>
                            <TD>
                                <b>
                                <xsl:value-of select="format-number(@CasinoComm,'###,##0')" />
                              </b>
                            </TD>
                        </TR>
                        <TR>
                            <TD colspan="2">
                                <B>Horses Commission: </B>
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterHComm1,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterHComm2,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterHComm3,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterHComm4,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterHComm5,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterHComm6,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@MasterHComm7,'###,##0')" />
                            </TD>
                            <TD>
                                <b>
                                <xsl:value-of select="format-number(@HorsesComm,'###,##0')" />
                              </b>
                            </TD>
                        </TR>
                    </xsl:if>
                    <TR>
                        <TD colspan="14">
                            <HR></HR>
                        </TD>
                    </TR>
                </TABLE>

              <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm d-lg-none">
                <THEAD class="trAgent">
                  <TR class="trAgent">
                    <TH colspan="10">
                      Agent
                      <xsl:value-of select="@Agent" />
                    </TH>
                  </TR>
                  <TR>
                    <TH WIDTH="10%">Player</TH>
                    <xsl:for-each select="//WEEK">
                      <xsl:for-each select="@*">
                        <TH>
                          <xsl:value-of select="." />
                        </TH>
                      </xsl:for-each>
                    </xsl:for-each>
                    <TH>Week</TH>
                    <TH>Sett</TH>
                  </TR>
                </THEAD>
                <xsl:for-each select="DETAIL">
                  <TR>
                    <TD>
                      <xsl:value-of select="concat(@Player,' ')" />
                    </TD>
                    <xsl:if test="name() != 'Player' and name() != 'Password'">
                      <TD>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                          <xsl:choose>
                            <xsl:when test="@Week1 != 0">
                              <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',1);">
                                <xsl:value-of select="format-number(@Week1,'###,##0')" />
                              </a>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="format-number(@Week1,'###,##0')" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                          <xsl:value-of select="format-number(@Week1,'###,##0')" />
                        </xsl:if>
                      </TD>
                      <TD>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                          <xsl:choose>
                            <xsl:when test="@Week2 != 0">
                              <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',2);">
                                <xsl:value-of select="format-number(@Week2,'###,##0')" />
                              </a>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="format-number(@Week2,'###,##0')" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                          <xsl:value-of select="format-number(@Week2,'###,##0')" />
                        </xsl:if>
                      </TD>
                      <TD>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                          <xsl:choose>
                            <xsl:when test="@Week3 != 0">
                              <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',3);">
                                <xsl:value-of select="format-number(@Week3,'###,##0')" />
                              </a>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="format-number(@Week3,'###,##0')" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                          <xsl:value-of select="format-number(@Week3,'###,##0')" />
                        </xsl:if>
                      </TD>
                      <TD>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                          <xsl:choose>
                            <xsl:when test="@Week4 != 0">
                              <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',4);">
                                <xsl:value-of select="format-number(@Week4,'###,##0')" />
                              </a>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="format-number(@Week4,'###,##0')" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                          <xsl:value-of select="format-number(@Week4,'###,##0')" />
                        </xsl:if>
                      </TD>
                      <TD>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                          <xsl:choose>
                            <xsl:when test="@Week5 != 0">
                              <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',5);">
                                <xsl:value-of select="format-number(@Week5,'###,##0')" />
                              </a>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="format-number(@Week5,'###,##0')" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                          <xsl:value-of select="format-number(@Week5,'###,##0')" />
                        </xsl:if>
                      </TD>
                      <TD>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                          <xsl:choose>
                            <xsl:when test="@Week6 != 0">
                              <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',6);">
                                <xsl:value-of select="format-number(@Week6,'###,##0')" />
                              </a>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="format-number(@Week6,'###,##0')" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                          <xsl:value-of select="format-number(@Week6,'###,##0')" />
                        </xsl:if>
                      </TD>
                      <TD>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                          <xsl:choose>
                            <xsl:when test="@Week7 != 0">
                              <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',7);">
                                <xsl:value-of select="format-number(@Week7,'###,##0')" />
                              </a>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="format-number(@Week7,'###,##0')" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                          <xsl:value-of select="format-number(@Week7,'###,##0')" />
                        </xsl:if>
                      </TD>
                      <TD>
                        <xsl:value-of select="format-number(@ThisWeek,'###,##0')" />
                      </TD>
                      <TD>
                        <xsl:value-of select="format-number(@Settled,'#####0')" />
                      </TD>
                    </xsl:if>
                  </TR>
                </xsl:for-each>
                <TR>
                  <TD COLSPAN="10">
                    <B>
                      Total Players <xsl:value-of select="concat(' ', @TPlayers)" />
                      Total Active <xsl:value-of select="concat(' ', @TActive)" />
                    </B>
                  </TD>
                </TR>
                <TR>
                  <TD height="10"></TD>
                </TR>
                <!--Agent totals-->
                <TR>
                  <TD>
                    <B>
                      Agent <xsl:value-of select="@Agent" /> Totals:
                    </B>
                  </TD>
                  <xsl:for-each select="TOTAL">
                    <TD>
                      <B>
                        <xsl:value-of select="@MasterTotal1" />
                      </B>
                    </TD>
                    <TD>
                      <B>
                        <xsl:value-of select="@MasterTotal2" />
                      </B>
                    </TD>
                    <TD>
                      <B>
                        <xsl:value-of select="@MasterTotal3" />
                      </B>
                    </TD>
                    <TD>
                      <B>
                        <xsl:value-of select="@MasterTotal4" />
                      </B>
                    </TD>
                    <TD>
                      <B>
                        <xsl:value-of select="@MasterTotal5" />
                      </B>
                    </TD>
                    <TD>
                      <B>
                        <xsl:value-of select="@MasterTotal6" />
                      </B>
                    </TD>
                    <TD>
                      <B>
                        <xsl:value-of select="@MasterTotal7" />
                      </B>
                    </TD>
                    <TD>
                      <B>
                        <xsl:value-of select="@MasterThisWeek" />
                      </B>
                    </TD>
                    <td></td>

                  </xsl:for-each>
                </TR>
                <TR>
                  <TD colspan="10"></TD>
                </TR>
                <!--Agent commissions-->
                <xsl:if test="@AgentType = '2'">
                  <TR>
                    <TD colspan="9">
                      <B>Commission: </B>
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@TotalComm,'###,##0')" />
                    </TD>
                  </TR>
                  <TR>
                    <TD colspan="9">
                      <B>New MakeUp: 4</B>
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@NewMakeUp,'###,##0')" />
                    </TD>
                  </TR>
                </xsl:if>
                <xsl:if test="@AgentType != '2'">
                  <TR>
                    <TD>
                      <B>Sports Commission: </B>
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterSComm1,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterSComm2,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterSComm3,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterSComm4,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterSComm5,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterSComm6,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterSComm7,'###,##0')" />
                    </TD>
                    <TD>
                      <b>
                        <xsl:value-of select="format-number(@SportComm,'###,##0')" />
                      </b>
                    </TD>
                    <TD rowspan="3">
                      <B>Total:</B>
                      <br/>
                      <xsl:value-of select="format-number(@TotalComm,'###,##0')" />
                    </TD>
                  </TR>
                  <TR>
                    <TD>
                      <B>Casino Commission: </B>
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterCComm1,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterCComm2,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterCComm3,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterCComm4,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterCComm5,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterCComm6,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterCComm7,'###,##0')" />
                    </TD>
                    <TD>
                      <b>
                        <xsl:value-of select="format-number(@CasinoComm,'###,##0')" />
                      </b>
                    </TD>
                  </TR>
                  <TR>
                    <TD>
                      <B>Horses Commission: </B>
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterHComm1,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterHComm2,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterHComm3,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterHComm4,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterHComm5,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterHComm6,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@MasterHComm7,'###,##0')" />
                    </TD>
                    <TD>
                      <b>
                        <xsl:value-of select="format-number(@HorsesComm,'###,##0')" />
                      </b>
                    </TD>
                  </TR>
                </xsl:if>
                <TR>
                  <TD colspan="10">
                    <HR></HR>
                  </TD>
                </TR>
              </TABLE>

            </div>
        </xsl:if>

    </xsl:template>

    <xsl:template name="SimpleAgent">

        <xsl:if test="count(DETAIL)>0">
            <div class="table-responsive">
                <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm hidden-md-down">
                    <THEAD>
                        <TR class="trAgent">
                            <TH colspan="14">
                                Agent
                                <xsl:value-of select="@Agent" />
                            </TH>
                        </TR>
                        <TR>
                            <TH WIDTH="10%">Player</TH>
                            <TH WIDTH="10%">Fwd</TH>
                            <xsl:for-each select="//WEEK">
                                <xsl:for-each select="@*">
                                    <TH>
                                        <xsl:value-of select="." />
                                    </TH>
                                </xsl:for-each>
                            </xsl:for-each>
                            <TH>Week</TH>
                            <TH>Pmts</TH>
                            <TH>Balance</TH>
                            <TH>Settled</TH>
                        </TR>
                    </THEAD>
                    <xsl:for-each select="DETAIL">
                        <TR>
                            <TD>
                                <xsl:value-of select="concat(@Player,' ')" />
                              <br/>
                              <xsl:value-of select="@Password" />
                            </TD>
                            <xsl:if test="name() != 'Player' and name() != 'Password'">
                                <TD>
                                    <xsl:value-of select="@BalFwd" />
                                </TD>
                                <TD>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                                        <xsl:choose>
                                            <xsl:when test="@Week1 != 0">
                                                <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',1);">
                                                    <xsl:value-of select="format-number(@Week1,'###,##0')" />
                                                </a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-number(@Week1,'###,##0')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                                        <xsl:value-of select="format-number(@Week1,'###,##0')" />
                                    </xsl:if>
                                </TD>
                                <TD>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                                        <xsl:choose>
                                            <xsl:when test="@Week2 != 0">
                                                <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',2);">
                                                    <xsl:value-of select="format-number(@Week2,'###,##0')" />
                                                </a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-number(@Week2,'###,##0')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                                        <xsl:value-of select="format-number(@Week2,'###,##0')" />
                                    </xsl:if>
                                </TD>
                                <TD>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                                        <xsl:choose>
                                            <xsl:when test="@Week3 != 0">
                                                <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',3);">
                                                    <xsl:value-of select="format-number(@Week3,'###,##0')" />
                                                </a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-number(@Week3,'###,##0')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                                        <xsl:value-of select="format-number(@Week3,'###,##0')" />
                                    </xsl:if>
                                </TD>
                                <TD>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                                        <xsl:choose>
                                            <xsl:when test="@Week4 != 0">
                                                <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',4);">
                                                    <xsl:value-of select="format-number(@Week4,'###,##0')" />
                                                </a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-number(@Week4,'###,##0')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                                        <xsl:value-of select="format-number(@Week4,'###,##0')" />
                                    </xsl:if>
                                </TD>
                                <TD>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                                        <xsl:choose>
                                            <xsl:when test="@Week5 != 0">
                                                <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',5);">
                                                    <xsl:value-of select="format-number(@Week5,'###,##0')" />
                                                </a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-number(@Week5,'###,##0')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                                        <xsl:value-of select="format-number(@Week5,'###,##0')" />
                                    </xsl:if>
                                </TD>
                                <TD>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                                        <xsl:choose>
                                            <xsl:when test="@Week6 != 0">
                                                <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',6);">
                                                    <xsl:value-of select="format-number(@Week6,'###,##0')" />
                                                </a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-number(@Week6,'###,##0')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                                        <xsl:value-of select="format-number(@Week6,'###,##0')" />
                                    </xsl:if>
                                </TD>
                                <TD>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                                        <xsl:choose>
                                            <xsl:when test="@Week7 != 0">
                                                <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',7);">
                                                    <xsl:value-of select="format-number(@Week7,'###,##0')" />
                                                </a>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="format-number(@Week7,'###,##0')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:if>
                                    <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                                        <xsl:value-of select="format-number(@Week7,'###,##0')" />
                                    </xsl:if>
                                </TD>
                                <TD>
                                    <xsl:value-of select="format-number(@ThisWeek,'###,##0')" />
                                </TD>
                                <TD>
                                    <xsl:value-of select="format-number(@Pmts,'#####0')" />
                                </TD>
                                <TD>
                                    <xsl:value-of select="format-number(@Balance,'###,##0')" />
                                </TD>
                                <TD>
                                    <xsl:value-of select="format-number(@Settled,'###,##0')" />
                                </TD>
                            </xsl:if>
                        </TR>
                    </xsl:for-each>
                    <TR>
                        <TD COLSPAN="14">
                            <B>
                              Total Players <xsl:value-of select="concat(' ', @TPlayers)" />
                              Total Active <xsl:value-of select="concat(' ', @TActive)" />
                            </B>
                        </TD>
                    </TR>
                    <TR>
                        <TD height="10"></TD>
                    </TR>
                    <!--Agent totals-->
                    <TR>
                        <TD colspan="2">
                            <B>
                              Agent <xsl:value-of select="@Agent" /> Totals:
                            </B>
                        </TD>
                        <xsl:for-each select="TOTAL">
                            <TD>
                                <B>
                <xsl:value-of select="@Week1" />
              </B>
                            </TD>
                            <TD>
                                <B>
                <xsl:value-of select="@Week2" />
              </B>
                            </TD>
                            <TD>
                                <B>
                <xsl:value-of select="@Week3" />
              </B>
                            </TD>
                            <TD>
                                <B>
                <xsl:value-of select="@Week4" />
              </B>
                            </TD>
                            <TD>
                                <B>
                <xsl:value-of select="@Week5" />
              </B>
                            </TD>
                            <TD>
                                <B>
                <xsl:value-of select="@Week6" />
              </B>
                            </TD>
                            <TD>
                                <B>
                <xsl:value-of select="@Week7" />
              </B>
                            </TD>
                            <TD>
                                <B>
                <xsl:value-of select="@ThisWeek" />
              </B>
                            </TD>
                            <TD colspan="3"></TD>
                        </xsl:for-each>
                    </TR>
                    <TR>
                        <TD colspan="14"></TD>
                    </TR>
                    <!--Agent commissions-->
                    <xsl:if test="@AgentType = '2'">
                        <TR>
                            <TD colspan="9">
                                <B>Commission: </B>
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@TotalComm,'###,##0')" />
                            </TD>
                        </TR>
                        <TR>
                            <TD colspan="9">
                                <B>New MakeUp: 5</B>
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@NewMakeUp,'###,##0')" />
                            </TD>
                        </TR>
                    </xsl:if>
                    <xsl:if test="@AgentType != '2'">
                        <TR>
                            <TD colspan="2">
                                <B>Sports Commission: </B>
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@SCommD1,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@SCommD2,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@SCommD3,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@SCommD4,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@SCommD5,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@SCommD6,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@SCommD7,'###,##0')" />
                            </TD>
                            <TD>
                                <b>
                                    <xsl:value-of select="format-number(@SportComm,'###,##0')" />
                                  </b>
                            </TD>
                            <TD colSpan="2" rowspan="3">
                                <B>Total Commission: </B>
                            </TD>
                            <TD  rowspan="3">
                                <xsl:value-of select="format-number(@TotalComm,'###,##0')" />
                            </TD>
                        </TR>
                        <TR>
                            <TD colspan="2">
                                <B>Casino Commission: </B>
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@CCommD1,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@CCommD2,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@CCommD3,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@CCommD4,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@CCommD5,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@CCommD6,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@CCommD7,'###,##0')" />
                            </TD>
                            <TD>
                                <b>
                <xsl:value-of select="format-number(@CasinoComm,'###,##0')" />
              </b>
                            </TD>
                        </TR>
                        <TR>
                            <TD colspan="2">
                                <B>Horses Commission: </B>
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@HCommD1,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@HCommD2,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@HCommD3,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@HCommD4,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@HCommD5,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@HCommD6,'###,##0')" />
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(@HCommD7,'###,##0')" />
                            </TD>
                            <TD>
                                <b>
                <xsl:value-of select="format-number(@HorsesComm,'###,##0')" />
              </b>
                            </TD>
                        </TR>
                    </xsl:if>
                    <TR>
                        <TD colspan="14">
                            <HR></HR>
                        </TD>
                    </TR>
                </TABLE>

              <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm d-lg-none">
                <THEAD>
                  <TR class="trAgent">
                    <TH colspan="10">
                      Agent
                      <xsl:value-of select="@Agent" />
                    </TH>
                  </TR>
                  <TR>
                    <TH WIDTH="10%">Player</TH>
                    <xsl:for-each select="//WEEK">
                      <xsl:for-each select="@*">
                        <TH>
                          <xsl:value-of select="." />
                        </TH>
                      </xsl:for-each>
                    </xsl:for-each>
                    <TH>Week</TH>
                    <TH>Sett</TH>
                  </TR>
                </THEAD>
                <xsl:for-each select="DETAIL">
                  <TR>
                    <TD>
                      <xsl:value-of select="concat(@Player,' ')" />
                    </TD>
                    <xsl:if test="name() != 'Player' and name() != 'Password'">

                      <TD>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                          <xsl:choose>
                            <xsl:when test="@Week1 != 0">
                              <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',1);">
                                <xsl:value-of select="format-number(@Week1,'###,##0')" />
                              </a>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="format-number(@Week1,'###,##0')" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                          <xsl:value-of select="format-number(@Week1,'###,##0')" />
                        </xsl:if>
                      </TD>
                      <TD>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                          <xsl:choose>
                            <xsl:when test="@Week2 != 0">
                              <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',2);">
                                <xsl:value-of select="format-number(@Week2,'###,##0')" />
                              </a>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="format-number(@Week2,'###,##0')" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                          <xsl:value-of select="format-number(@Week2,'###,##0')" />
                        </xsl:if>
                      </TD>
                      <TD>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                          <xsl:choose>
                            <xsl:when test="@Week3 != 0">
                              <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',3);">
                                <xsl:value-of select="format-number(@Week3,'###,##0')" />
                              </a>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="format-number(@Week3,'###,##0')" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                          <xsl:value-of select="format-number(@Week3,'###,##0')" />
                        </xsl:if>
                      </TD>
                      <TD>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                          <xsl:choose>
                            <xsl:when test="@Week4 != 0">
                              <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',4);">
                                <xsl:value-of select="format-number(@Week4,'###,##0')" />
                              </a>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="format-number(@Week4,'###,##0')" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                          <xsl:value-of select="format-number(@Week4,'###,##0')" />
                        </xsl:if>
                      </TD>
                      <TD>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                          <xsl:choose>
                            <xsl:when test="@Week5 != 0">
                              <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',5);">
                                <xsl:value-of select="format-number(@Week5,'###,##0')" />
                              </a>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="format-number(@Week5,'###,##0')" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                          <xsl:value-of select="format-number(@Week5,'###,##0')" />
                        </xsl:if>
                      </TD>
                      <TD>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                          <xsl:choose>
                            <xsl:when test="@Week6 != 0">
                              <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',6);">
                                <xsl:value-of select="format-number(@Week6,'###,##0')" />
                              </a>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="format-number(@Week6,'###,##0')" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                          <xsl:value-of select="format-number(@Week6,'###,##0')" />
                        </xsl:if>
                      </TD>
                      <TD>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'True'">
                          <xsl:choose>
                            <xsl:when test="@Week7 != 0">
                              <a href="javascript:GetPlayerHistory({@IdPlayer},'{//DATA/@STARTDATE}',7);">
                                <xsl:value-of select="format-number(@Week7,'###,##0')" />
                              </a>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="format-number(@Week7,'###,##0')" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                        <xsl:if test="//DATA/@DisplayHistoryRight = 'False'">
                          <xsl:value-of select="format-number(@Week7,'###,##0')" />
                        </xsl:if>
                      </TD>
                      <TD>
                        <xsl:value-of select="format-number(@ThisWeek,'###,##0')" />
                      </TD>
                      <TD>
                        <xsl:value-of select="format-number(@Settled,'###,##0')" />
                      </TD>
                    </xsl:if>
                  </TR>
                </xsl:for-each>
                <TR>
                  <TD COLSPAN="10">
                    <B>
                      Total Players <xsl:value-of select="concat(' ', @TPlayers)" />
                      Total Active <xsl:value-of select="concat(' ', @TActive)" />
                    </B>
                  </TD>
                </TR>
                <TR>
                  <TD height="10"></TD>
                </TR>
                <!--Agent totals-->
                <TR>
                  <TD>
                    <B>
                      Agent <xsl:value-of select="@Agent" /> Totals:
                    </B>
                  </TD>
                  <xsl:for-each select="TOTAL">
                    <TD>
                      <B>
                        <xsl:value-of select="@Week1" />
                      </B>
                    </TD>
                    <TD>
                      <B>
                        <xsl:value-of select="@Week2" />
                      </B>
                    </TD>
                    <TD>
                      <B>
                        <xsl:value-of select="@Week3" />
                      </B>
                    </TD>
                    <TD>
                      <B>
                        <xsl:value-of select="@Week4" />
                      </B>
                    </TD>
                    <TD>
                      <B>
                        <xsl:value-of select="@Week5" />
                      </B>
                    </TD>
                    <TD>
                      <B>
                        <xsl:value-of select="@Week6" />
                      </B>
                    </TD>
                    <TD>
                      <B>
                        <xsl:value-of select="@Week7" />
                      </B>
                    </TD>
                    <TD>
                      <B>
                        <xsl:value-of select="@ThisWeek" />
                      </B>
                    </TD>
                    <TD></TD>
                  </xsl:for-each>
                </TR>
                <TR>
                  <TD colspan="10"></TD>
                </TR>
                <!--Agent commissions-->
                <xsl:if test="@AgentType = '2'">
                  <TR>
                    <TD colspan="9">
                      <B>Commission: </B>
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@TotalComm,'###,##0')" />
                    </TD>
                  </TR>
                  <TR>
                    <TD colspan="9">
                      <B>New MakeUp: 6</B>
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@NewMakeUp,'###,##0')" />
                    </TD>
                  </TR>
                </xsl:if>
                <xsl:if test="@AgentType != '2'">
                  <TR>
                    <TD>
                      <B>Sports Commission: </B>
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@SCommD1,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@SCommD2,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@SCommD3,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@SCommD4,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@SCommD5,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@SCommD6,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@SCommD7,'###,##0')" />
                    </TD>
                    <TD>
                      <b>
                        <xsl:value-of select="format-number(@SportComm,'###,##0')" />
                      </b>
                    </TD>
                    <TD rowspan="3">
                      <B>Total: </B>
                      <br/>
                      <xsl:value-of select="format-number(@TotalComm,'###,##0')" />
                    </TD>
                  </TR>
                  <TR>
                    <TD>
                      <B>Casino Commission: </B>
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@CCommD1,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@CCommD2,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@CCommD3,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@CCommD4,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@CCommD5,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@CCommD6,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@CCommD7,'###,##0')" />
                    </TD>
                    <TD>
                      <b>
                        <xsl:value-of select="format-number(@CasinoComm,'###,##0')" />
                      </b>
                    </TD>
                  </TR>
                  <TR>
                    <TD>
                      <B>Horses Commission: </B>
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@HCommD1,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@HCommD2,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@HCommD3,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@HCommD4,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@HCommD5,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@HCommD6,'###,##0')" />
                    </TD>
                    <TD>
                      <xsl:value-of select="format-number(@HCommD7,'###,##0')" />
                    </TD>
                    <TD>
                      <b>
                        <xsl:value-of select="format-number(@HorsesComm,'###,##0')" />
                      </b>
                    </TD>
                  </TR>
                </xsl:if>
                <TR>
                  <TD colspan="10">
                    <HR></HR>
                  </TD>
                </TR>
              </TABLE>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="DistAgent">
        <div class="table-responsive">
            <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm ">
                <THEAD>
                    <TR class="trAgent">
                        <TH colspan="11">
                          Distributor: <xsl:value-of select="@Agent" />
                        </TH>
                    </TR>
                    <TR>
                        <TH colspan="2">
                            
                        </TH>
                        <xsl:for-each select="//WEEK">
                            <xsl:for-each select="@*">
                                <TH>
                                    <xsl:value-of select="." />
                                </TH>
                            </xsl:for-each>
                        </xsl:for-each>
                        <TH>Pmts</TH>
                        <TH>Balance</TH>
                    </TR>
                </THEAD>
                <TR>
                    <TD colspan="2">
                        <b>Agent Totals:</b>
                    </TD>
                    <TD>
                        <xsl:value-of select="format-number(TOTAL/@MasterTotal1,'###,##0')" />
                    </TD>
                    <TD>
                        <xsl:value-of select="format-number(TOTAL/@MasterTotal2,'###,##0')" />
                    </TD>
                    <TD>
                        <xsl:value-of select="format-number(TOTAL/@MasterTotal3,'###,##0')" />
                    </TD>
                    <TD>
                        <xsl:value-of select="format-number(TOTAL/@MasterTotal4,'###,##0')" />
                    </TD>
                    <TD>
                        <xsl:value-of select="format-number(TOTAL/@MasterTotal5,'###,##0')" />
                    </TD>
                    <TD>
                        <xsl:value-of select="format-number(TOTAL/@MasterTotal6,'###,##0')" />
                    </TD>
                    <TD>
                        <xsl:value-of select="format-number(TOTAL/@MasterTotal7,'###,##0')" />
                    </TD>
                    <TD>
                        <xsl:value-of select="format-number(@Ptms,'###,##0')" />
                    </TD>
                    <TD>
                        <xsl:value-of select="format-number(@WBal,'###,##0')" />
                    </TD>
                </TR>
                <TR>
                    <TD colSpan="11">
                        <strong>
                            Total Players <xsl:value-of select="@MasterPlayersTotal"/>  Total Active <xsl:value-of select="@MasterPlayersActive"/>
                          </strong>
                    </TD>
                </TR>

                <xsl:if test="@AgentType = '1' or @AgentType = '4' or @AgentType = '5'">
                    <TR>
                        <TD colspan="2">
                            <b>Sports Comm:</b>
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterSComm1)),'###,##0')" />
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterSComm2)),'###,##0')" />
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterSComm3)),'###,##0')" />
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterSComm4)),'###,##0')" />
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterSComm5)),'###,##0')" />
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterSComm6)),'###,##0')" />
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterSComm7)),'###,##0')" />
                        </TD>
                        <TD colspan="2">
                            <b>Total:</b>
                            <xsl:value-of select="format-number(round(number(@MasterSCommTotal)),'###,##0')" />
                        </TD>
                    </TR>
                    <TR>
                        <TD colspan="2">
                            <b>Casino Comm:</b>
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterCComm1)),'###,##0')" />
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterCComm2)),'###,##0')" />
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterCComm3)),'###,##0')" />
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterCComm4)),'###,##0')" />
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterCComm5)),'###,##0')" />
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterCComm6)),'###,##0')" />
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterCComm7)),'###,##0')" />
                        </TD>
                        <TD colspan="2">
                            <b>Total:</b>
                            <xsl:value-of select="format-number(round(number(@MasterCCommTotal)),'###,##0')" />
                        </TD>
                    </TR>
                    <TR>
                        <TD colspan="2">
                            <b>Horses Comm:</b>
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterHComm1)),'###,##0')" />
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterHComm2)),'###,##0')" />
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterHComm3)),'###,##0')" />
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterHComm4)),'###,##0')" />
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterHComm5)),'###,##0')" />
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterHComm6)),'###,##0')" />
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterHComm7)),'###,##0')" />
                        </TD>
                        <TD colspan="2">
                            <b>Total:</b>
                            <xsl:value-of select="format-number(round(number(@MasterHCommTotal)),'###,##0')" />
                        </TD>
                    </TR>
                    <TR>
                        <TD colspan="10">
                            <B>Total Commission: </B>
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(round(number(@MasterSCommTotal + @MasterCCommTotal + @MasterHCommTotal)),'###,##0')" />
                        </TD>
                    </TR>
                </xsl:if>

                <xsl:if test="@AgentType = '2'">

                    <TR>
                        <TD colspan="8">
                            <B>Commission: </B>
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(number(@MasterCommission),'###,##0')" />
                        </TD>
                    </TR>
                    <TR>
                        <TD colspan="8">
                            <B>New MakeUp: 7</B>
                        </TD>
                        <TD>
                            <xsl:value-of select="format-number(number(@MasterNewMakeUp),'###,##0')" />
                        </TD>
                    </TR>

                </xsl:if>

                <xsl:if test="@AgentType = 3">
                    <TR>
                        <xsl:if test="@MasterThisWeek > 0">
                            <TD colspan="8">
                                <B>Commission: </B>
                            </TD>
                            <TD>
                                <xsl:value-of select="format-number(number(@MasterCommission),'###,##0')" />
                            </TD>
                        </xsl:if>
                    </TR>
                </xsl:if>

            </TABLE>
        </div>
        <HR></HR>
    </xsl:template>

    <xsl:template name="MasterEnd" match="//AGENT">
        <div class="table-responsive">
            <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm ">
                <THEAD>
                    <TR class="trAgent">
                        <TH colspan="11">
                            Master Agent
                            <xsl:value-of select="//DATA/@AGENT" />
                        </TH>
                    </TR>
                    <TR>
                        <TH></TH>
                        <xsl:for-each select="//WEEK">
                            <xsl:for-each select="@*">
                                <TH>
                                    <xsl:value-of select="." />
                                </TH>
                            </xsl:for-each>
                        </xsl:for-each>
                        <TH>Pmts</TH>
                        <TH>Bal</TH>
                    </TR>
                </THEAD>
                <TR>
                    <TD width="15%">

                        <B>Players Totals:</B>

                    </TD>
                    <TD width="10%">

                        <xsl:value-of select="format-number(sum(//AGENT/TOTAL/@MasterTotal1),'###,##0')" />

                    </TD>
                    <TD width="10%">

                        <xsl:value-of select="format-number(sum(//AGENT/TOTAL/@MasterTotal2),'###,##0')" />

                    </TD>
                    <TD width="10%">

                        <xsl:value-of select="format-number(sum(//AGENT/TOTAL/@MasterTotal3),'###,##0')" />

                    </TD>
                    <TD width="10%">

                        <xsl:value-of select="format-number(sum(//AGENT/TOTAL/@MasterTotal4),'###,##0')" />

                    </TD>
                    <TD width="10%">

                        <xsl:value-of select="format-number(sum(//AGENT/TOTAL/@MasterTotal5),'###,##0')" />

                    </TD>
                    <TD width="10%">

                        <xsl:value-of select="format-number(sum(//AGENT/TOTAL/@MasterTotal6),'###,##0')" />

                    </TD>
                    <TD width="10%">

                        <xsl:value-of select="format-number(sum(//AGENT/TOTAL/@MasterTotal7),'###,##0')" />

                    </TD>
                    <TD width="7%">

                        <xsl:value-of select="format-number(@PTMS,'###,##0')" />

                    </TD>
                    <TD width="7%">

                        <xsl:value-of select="format-number(sum(//AGENT/TOTAL/@MasterTotal1) + sum(//AGENT/TOTAL/@MasterTotal2) + sum(//AGENT/TOTAL/@MasterTotal3) + sum(//AGENT/TOTAL/@MasterTotal4) + sum(//AGENT/TOTAL/@MasterTotal5) + sum(//AGENT/TOTAL/@MasterTotal6) + sum(//AGENT/TOTAL/@MasterTotal7),'###,##0')" />

                    </TD>
                </TR>
                <TR>
                    <TD>

                        <B>Agents Commisions:</B>

                    </TD>
                    <TD>

                        <xsl:value-of select="format-number(sum(//AGENT/@MasterSComm1) + sum(//AGENT/@MasterCComm1) + sum(//AGENT/@MasterHComm1),'###,##0')" />

                    </TD>
                    <TD>

                        <xsl:value-of select="format-number(sum(//AGENT/@MasterSComm2) + sum(//AGENT/@MasterCComm2) + sum(//AGENT/@MasterHComm2),'###,##0')" />

                    </TD>
                    <TD>

                        <xsl:value-of select="format-number(sum(//AGENT/@MasterSComm3) + sum(//AGENT/@MasterCComm3) + sum(//AGENT/@MasterHComm3),'###,##0')" />

                    </TD>
                    <TD>

                        <xsl:value-of select="format-number(sum(//AGENT/@MasterSComm4) + sum(//AGENT/@MasterCComm4) + sum(//AGENT/@MasterHComm4),'###,##0')" />

                    </TD>
                    <TD>

                        <xsl:value-of select="format-number(sum(//AGENT/@MasterSComm5) + sum(//AGENT/@MasterCComm5) + sum(//AGENT/@MasterHComm5),'###,##0')" />

                    </TD>
                    <TD>

                        <xsl:value-of select="format-number(sum(//AGENT/@MasterSComm6) + sum(//AGENT/@MasterCComm6) + sum(//AGENT/@MasterHComm6),'###,##0')" />

                    </TD>
                    <TD>

                        <xsl:value-of select="format-number(sum(//AGENT/@MasterSComm7) + sum(//AGENT/@MasterCComm7) + sum(//AGENT/@MasterHComm7),'###,##0')" />

                    </TD>

                    <TD></TD>
                    <TD></TD>
                </TR>
                <TR>
                    <TD colSpan="11">
                        <strong>
                            Total Players <xsl:value-of select="sum(//AGENT/@MasterPlayersTotal)"/>  Total Active <xsl:value-of select="sum(//AGENT/@MasterPlayersActive)"/>
                          </strong>
                    </TD>
                </TR>
                <TR>
                    <TD colspan="11">Master Agent Commission</TD>
                </TR>

                <xsl:if test="@AGENTTYPE = '1' or @AGENTTYPE = '4'">
                    <xsl:variable name="SComm">
                        <xsl:value-of select="sum(//AGENT/@MasterSCommTotal)" />
                    </xsl:variable>
                    <xsl:variable name="CComm">
                        <xsl:value-of select="sum(//AGENT/@MasterCCommTotal)" />
                    </xsl:variable>
                    <xsl:variable name="HComm">
                        <xsl:value-of select="sum(//AGENT/@MasterHCommTotal)" />
                    </xsl:variable>

                    <TR>
                        <TD>

                            <B>Sports Commission: </B>

                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterSComm1) * //DATA/@SPORTS))" />
                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterSComm2) * //DATA/@SPORTS))" />
                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterSComm3) * //DATA/@SPORTS))" />
                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterSComm4) * //DATA/@SPORTS))" />
                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterSComm5) * //DATA/@SPORTS))" />
                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterSComm6) * //DATA/@SPORTS))" />
                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterSComm7) * //DATA/@SPORTS))" />
                        </TD>
                        <TD colspan="2">
                            <strong>
                              <xsl:value-of select="round(number(sum(//AGENT/@MasterSCommTotal) * //DATA/@SPORTS))" />
                            </strong>
                        </TD>
                    </TR>
                    <TR>
                        <TD>

                            <B>Casino Commission: </B>

                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterCComm1) * //DATA/@CASINO))" />
                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterCComm2) * //DATA/@CASINO))" />
                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterCComm3) * //DATA/@CASINO))" />
                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterCComm4) * //DATA/@CASINO))" />
                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterCComm5) * //DATA/@CASINO))" />
                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterCComm6) * //DATA/@CASINO))" />
                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterCComm7) * //DATA/@CASINO))" />
                        </TD>
                        <TD colspan="2">
                            <strong>
                              <xsl:value-of select="round(number(sum(//AGENT/@MasterCCommTotal) * //DATA/@CASINO))" />
                            </strong>
                        </TD>
                    </TR>
                    <TR>
                        <TD>

                            <B>Horses Commission: </B>

                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterHComm1) * //DATA/@HORSES))" />
                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterHComm2) * //DATA/@HORSES))" />
                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterHComm3) * //DATA/@HORSES))" />
                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterHComm4) * //DATA/@HORSES))" />
                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterHComm5) * //DATA/@HORSES))" />
                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterHComm6) * //DATA/@HORSES))" />
                        </TD>
                        <TD>
                            <xsl:value-of select="round(number(sum(//AGENT/@MasterHComm7) * //DATA/@HORSES))" />
                        </TD>
                        <TD colspan="2">
                            <strong>
                              <xsl:value-of select="round(number(sum(//AGENT/@MasterHCommTotal) * //DATA/@HORSES))" />
                            </strong>
                        </TD>
                    </TR>
                    <TR>
                        <TD colspan="8">

                            <B>Total Commission: </B>

                        </TD>
                        <TD colspan="2">
                            <strong>
              <xsl:value-of select="round(number($HComm * //DATA/@HORSES)) + round(number($CComm * //DATA/@CASINO)) + round(number($SComm * //DATA/@SPORTS))" />
            </strong>
                        </TD>
                    </TR>
                </xsl:if>

                <xsl:if test="@AGENTTYPE = '2'">

                    <xsl:variable name="SComm">
                        <xsl:value-of select="sum(//AGENT/TOTAL/@MasterThisWeek)" />
                    </xsl:variable>

                    <xsl:if test="($SComm + @MAKEUP) > '0'">
                        <TR>
                            <TD colspan="2">
                                <B>Commission: </B>
                            </TD>
                            <TD>0</TD>
                        </TR>
                        <TR>
                            <TD colspan="8">
                                <B>New MakeUp: 1 </B>
                            </TD>
                            <TD>
                                <xsl:value-of select="number($SComm + //DATA/@MAKEUP)" />
                            </TD>
                        </TR>
                    </xsl:if>

                    <xsl:if test="($SComm + @MAKEUP) &lt; '0'">
                        <TR>
                            <TD colspan="8">
                                <B>Commission: </B>
                            </TD>
                            <TD>
                                <xsl:value-of select="round(number($SComm + //DATA/@SPORTS)) * -1" />
                            </TD>
                        </TR>
                        <TR>
                            <TD colspan="8">
                                <B>New MakeUp: 2</B>
                            </TD>
                            <TD>0</TD>
                        </TR>
                    </xsl:if>
                </xsl:if>

                <xsl:if test="@AGENTTYPE = '3'">

                    <xsl:variable name="SComm">
                        <xsl:value-of select="sum(//AGENT/TOTAL/@MasterThisWeek)" />
                    </xsl:variable>

                    <TR>
                        <xsl:if test="$SComm > 0">
                            <TD colspan="8">
                                <B>Commission: </B>
                            </TD>
                            <TD>
                                <xsl:value-of select="number(round($SComm * //DATA/@SPORTS) * -1)" />
                            </TD>
                        </xsl:if>
                    </TR>

                </xsl:if>

                <xsl:if test="@AGENTTYPE = '5'">
                    <xsl:variable name="SComm">
                        <xsl:value-of select="sum(//AGENT/@SumSports)" />
                    </xsl:variable>
                    <xsl:variable name="CComm">
                        <xsl:value-of select="sum(//AGENT/@SumCasino)" />
                    </xsl:variable>
                    <xsl:variable name="HComm">
                        <xsl:value-of select="sum(//AGENT/@SumHorses)" />
                    </xsl:variable>

                    <TR>
                        <TD>

                            <B>Commission By: </B>

                        </TD>
                        <TD colspan="2">
                            Sports:
                            <xsl:value-of select="round(number(sum(//AGENT/@SumSports) * //DATA/@SPORTS))" />
                        </TD>
                        <TD colspan="2">
                            Casino:
                            <xsl:value-of select="round(number(sum(//AGENT/@SumCasino) * //DATA/@CASINO))" />
                        </TD>
                        <TD colspan="2">
                            Horses:
                            <xsl:value-of select="round(number(sum(//AGENT/@SumHorses) * //DATA/@HORSES))" />
                        </TD>
                        <TD></TD>
                        <TD colspan="2"></TD>
                    </TR>

                    <TR>
                        <TD colspan="8">

                            <B>Total Commission: </B>

                        </TD>
                        <TD colspan="2">
                            <strong>
              <xsl:value-of select="round(number(sum(//AGENT/@SumSports) * //DATA/@SPORTS)) + round(number(sum(//AGENT/@SumCasino) * //DATA/@CASINO)) + round(number(sum(//AGENT/@SumHorses) * //DATA/@HORSES))" />
            </strong>
                        </TD>
                    </TR>
                </xsl:if>

                <TR>
                    <TD colspan="11">
                        <HR></HR>
                    </TD>
                </TR>
            </TABLE>
        </div>
    </xsl:template>

</xsl:stylesheet>
