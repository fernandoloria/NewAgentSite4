<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output  method="html" indent="no" encoding="UTF-8" />
  <xsl:template match="//xml">
    

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/JavaScript">
      function post(){
      document.forms[0].submit();
      }
    </SCRIPT>

   
	  <div class="row">
			<div class="page-titles">
				<h4>Players Standing</h4>
			</div>
		</div>
    <div class="row">
      <div class="col-lg-12">
        <div class="card">
          <div class="card-body">
            <div class="row">
              <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                <div class="form-group">
                  <label for="Date1">Day Week Date:</label>
                  <br></br>
                  <INPUT TYPE="text" class="form-control form-control-sm datepicker" NAME="Date1" value="{@StartDate}" />
                </div>
              </div>
              <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                <div class="form-group">
                  <label for="cCurrency">Currency:</label>
                  <br></br>
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
                </div>
              </div>
              <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                <div class="form-group">
                  <INPUT type="SUBMIT" class="btn btn-primary" style="margin-top:24px;" value="Submit" name="Submit" />
                </div>
              </div>
              <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                <div class="form-group">

                </div>
              </div>
            </div>
            <h4 class="card-title">
              <xsl:value-of select="@StartDate"/> To <xsl:value-of select="@EndDate"/>
            </h4>
		  </div>
	  </div>
  </div>
</div>
            <xsl:if test="count(//agent) &lt; 2" >
              <div class="table-responsive">
                <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm">
                  <THEAD>
                    <TR>
                      <TH>Player</TH>
                      <TH>Password</TH>
                      <TH align="right">Credit Limit</TH>
                      <TH align="right">This Week</TH>
                      <TH align="right">At Risk</TH>
                      <TH align="right">Current Balance</TH>
                      <TH align="right">This Week Sports</TH>
                      <TH align="right">This Week Horses</TH>
                      <TH align="right">This Week Casino</TH>
                    </TR>
                  </THEAD>
                  <xsl:for-each select="//player">
                    <TR>
                      <TD>
                        <xsl:value-of select="@Player"/>
                      </TD>
                      <TD>
                        <xsl:value-of select="@Password"/>
                      </TD>
                      <TD align="right">
                        <xsl:value-of select="@Symbol"/>
                        <xsl:value-of select="format-number(@CreditLimit,'###,##0')"/>
                      </TD>
                      <TD align="right">
                        <xsl:value-of select="format-number(@ThisWeek,'###,##0')"/>
                      </TD>
                      <TD align="right">
                        <xsl:value-of select="format-number(@AtRisk,'###,##0')"/>
                      </TD>
                      <TD align="right">
                        <xsl:value-of select="format-number(@CurrentBalance,'###,##0')"/>
                      </TD>
                      <TD align="right">
                        <xsl:value-of select="format-number(@ThisWeekSports,'###,##0')"/>
                      </TD>
                      <TD align="right">
                        <xsl:value-of select="format-number(@ThisWeekHorses,'###,##0')"/>
                      </TD>
                      <TD align="right">
                        <xsl:value-of select="format-number(@ThisWeekCasino,'###,##0')"/>
                      </TD>
                    </TR>
                  </xsl:for-each>
                  <xsl:if test="count(//player) > 0 ">
                    <TFOOT>
                      <TR>
                        <TD colspan="2">Totals</TD>
                        <TD align="right">
                        </TD>
                        <TD align="right">
                          <xsl:value-of select="format-number(sum(//player/@ThisWeek),'###,##0')" />
                        </TD>
                        <TD align="right">
                          <xsl:value-of select="format-number(sum(//player/@AtRisk),'###,##0')" />
                        </TD>
                        <TD align="right">
                          <xsl:value-of select="format-number(sum(//player/@CurrentBalance),'###,##0')" />
                        </TD>
                        <TD align="right">
                          <xsl:value-of select="format-number(sum(//player/@ThisWeekSports),'###,##0')" />
                        </TD>
                        <TD align="right">
                          <xsl:value-of select="format-number(sum(//player/@ThisWeekHorses),'###,##0')" />
                        </TD>
                        <TD align="right">
                          <xsl:value-of select="format-number(sum(//player/@ThisWeekCasino),'###,##0')" />
                        </TD>
                      </TR>
                    </TFOOT>
                  </xsl:if>
                </TABLE>
              </div>
              <br></br>
            </xsl:if>

            <xsl:if test="count(//agent)>1">

              <xsl:for-each select="//agent">

                <xsl:if test="count(player)>0">
                  <div class="table-responsive">
                    <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm">

                      <thead>
                        <TR class="trAgent">
                          <th colspan="9" align="center">
                            Agent <xsl:value-of select="@Agent" />
                          </th>
                        </TR>
                        <TR CLASS="GameHeader">
                          <TH>Player</TH>
                          <TH>Password</TH>
                          <TH align="right">Credit Limit</TH>
                          <TH align="right">This Week</TH>
                          <TH align="right">At Risk</TH>
                          <TH align="right">Current Balance</TH>
                          <TH align="right">This Week Sports</TH>
                          <TH align="right">This Week Horses</TH>
                          <TH align="right">This Week Casino</TH>
                        </TR>
                      </thead>
                      <xsl:for-each select="player">
                        <TR>
                          <TD>
                            <xsl:value-of select="@Player"/>
                          </TD>
                          <TD>
                            <xsl:value-of select="@Password"/>
                          </TD>
                          <TD align="right">
                            <xsl:value-of select="@Symbol"/>
                            <xsl:value-of select="format-number(@CreditLimit,'###,##0')"/>
                          </TD>
                          <TD align="right">
                            <xsl:value-of select="format-number(@ThisWeek,'###,##0')"/>
                          </TD>
                          <TD align="right">
                            <xsl:value-of select="format-number(@AtRisk,'###,##0')"/>
                          </TD>
                          <TD align="right">
                            <xsl:value-of select="format-number(@CurrentBalance,'###,##0')"/>
                          </TD>
                          <TD align="right">
                            <xsl:value-of select="format-number(@ThisWeekSports,'###,##0')"/>
                          </TD>
                          <TD align="right">
                            <xsl:value-of select="format-number(@ThisWeekHorses,'###,##0')"/>
                          </TD>
                          <TD align="right">
                            <xsl:value-of select="format-number(@ThisWeekCasino,'###,##0')"/>
                          </TD>
                        </TR>
                      </xsl:for-each>
                      <xsl:if test="count(player) > 0 ">
                        <TR>
                          <TD colspan="2">Totals</TD>
                          <TD align="right">

                          </TD>
                          <TD align="right">
                            <xsl:value-of select="format-number(sum(player/@ThisWeek),'###,##0')" />
                          </TD>
                          <TD align="right">
                            <xsl:value-of select="format-number(sum(player/@AtRisk),'###,##0')" />
                          </TD>
                          <TD align="right">
                            <xsl:value-of select="format-number(sum(player/@CurrentBalance),'###,##0')" />
                          </TD>
                          <TD align="right">
                            <xsl:value-of select="format-number(sum(player/@ThisWeekSports),'###,##0')" />
                          </TD>
                          <TD align="right">
                            <xsl:value-of select="format-number(sum(player/@ThisWeekHorses),'###,##0')" />
                          </TD>
                          <TD align="right">
                            <xsl:value-of select="format-number(sum(player/@ThisWeekCasino),'###,##0')" />
                          </TD>

                        </TR>
                      </xsl:if>
                      <TR CLASS="TrGameBottom">
                        <TD colspan="9"></TD>
                      </TR>
                    </TABLE>
                  </div>
                  <br></br>
                </xsl:if>
                <xsl:if test="@IsDistributor = 'True'">
                  <div class="table-responsive">
                    <TABLE class="table color-table success-table table-bordered table-striped table-sm">
                      <thead>
                        <TR class="trAgent">
                          <th colspan="9" align="center">
                            Agent <xsl:value-of select="@Agent" /> Distributor
                          </th>
                        </TR>
                        <TR CLASS="GameHeader" >
                          <TH>Player</TH>
                          <TH>Password</TH>
                          <TH align="right">Credit Limit</TH>
                          <TH align="right">This Week</TH>
                          <TH align="right">At Risk</TH>
                          <TH align="right">Current Balance</TH>
                          <TH align="right">This Week Sports</TH>
                          <TH align="right">This Week Horses</TH>
                          <TH align="right">This Week Casino</TH>
                        </TR>
                      </thead>
                      <TR>
                        <TD colspan="9" align="left">No Players</TD>
                      </TR>
                      <TR CLASS="TrGameBottom">
                        <TD colspan="9"></TD>
                      </TR>
                    </TABLE>
                  </div>
                  <br></br>
                </xsl:if>
              </xsl:for-each>

              <div class="table-responsive">
                <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm">
                  <thead>
                    <TR class="trAgent">
                      <th colspan="8" align="center">
                        Master Agent
                      </th>
                    </TR>
                    <TR CLASS="GameHeader" >
                      <th>Totals</th>
                      <th align="right">Credit Limit</th>
                      <th align="right">This Week</th>
                      <th align="right">At Risk</th>
                      <th align="right">Current Balance</th>
                      <th align="right">This Week Sports</th>
                      <th align="right">This Week Horses</th>
                      <th align="right">This Week Casino</th>
                    </TR>
                  </thead>
                  <TR>
                    <xsl:attribute name="class">
                      TrGameEven
                    </xsl:attribute>
                    <TD></TD>
                    <TD align="right">

                    </TD>
                    <TD align="right">
                      <xsl:value-of select="format-number(sum(//agent/@ThisWeekTotal),'###,##0')" />
                    </TD>
                    <TD align="right">
                      <xsl:value-of select="format-number(sum(//agent/@AtRiskTotal),'###,##0')" />
                    </TD>
                    <TD align="right">
                      <xsl:value-of select="format-number(sum(//agent/@CurrentBalanceTotal),'###,##0')" />
                    </TD>
                    <TD align="right">
                      <xsl:value-of select="format-number(sum(//agent/@ThisSportsTotal),'###,##0')" />
                    </TD>
                    <TD align="right">
                      <xsl:value-of select="format-number(sum(//agent/@ThisHorsesTotal),'###,##0')" />
                    </TD>
                    <TD align="right">
                      <xsl:value-of select="format-number(sum(//agent/@ThisCasinoTotal),'###,##0')" />
                    </TD>
                  </TR>
                  <TR CLASS="TrGameBottom">
                    <TD colspan="8"></TD>
                  </TR>
                </TABLE>
              </div>
              <BR/>
            </xsl:if>
         
  </xsl:template>

</xsl:stylesheet>
