<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="no" encoding="UTF-8" />

    <xsl:template match="//xml">
        <div class="row page-titles">
            <div 
class="col-md-12 col-12 align-self-center"
>
                <h3 
class="main-title m-b-0 m-t-0"
>
Player Count</h3>          
    </div>
        </div>
        <div class="row">
    <div class="col-lg-12">
        <div class="card">
            <div class="card-body">
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-4 col-lg-4">
                <div class="form-group">
                    <label for="Date1">Initial Date:</label><br></br>
                    <INPUT TYPE="text" NAME="Date1" value="{@StartDate}" class="form-control form-control-sm datepicker" />
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-4 col-lg-4">
                <div class="form-group">
                    <label for="Date2">End Date:</label><br></br>
                    <INPUT TYPE="text" NAME="Date2" value="{@EndDate}" class="form-control form-control-sm datepicker" />
                </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-4 col-lg-4">
                <div class="form-group">

                </div>
            </div>
        </div>

        <div class="table-responsive">
            <TABLE class="table color-table success-table table-bordered table-striped table-sm hover-table">
                <TR>
                    <TD colspan="4">ACTIVITY</TD>
                </TR>
                <TR>
                    <TD width="25%">
                        <label style="padding-right:10px">With Bets</label>
                        <input type="radio" name="FilterActivity" value="0">
                        <xsl:if test="@Activity = '0'">
                            <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                        </input>
                    </TD>
                    <TD width="25%">
                        <label style="padding-right:10px">Only Access</label>
                        <input type="radio" name="FilterActivity" value="1">
                        <xsl:if test="@Activity = '1'">
                            <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                        </input>
                    </TD>
                    <TD width="25%">
                        <label style="padding-right:10px">Any Activity</label>
                        <input type="radio" name="FilterActivity" value="2">
                        <xsl:if test="@Activity = '2'">
                            <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                        </input>
                    </TD>
                    <TD width="25%">
                        <label style="padding-right:10px">No Activity</label>
                        <input type="radio" name="FilterActivity" value="3">
                        <xsl:if test="@Activity = '3'">
                            <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                        </input>
                    </TD>
                </TR>
            </TABLE>
        </div>
        <div class="table-responsive">
            <TABLE class="table color-table success-table table-bordered table-striped table-sm hover-table">
                <TR>
                    <TD colspan="4">ACCESS</TD>
                </TR>
                <TR>
                    <TD width="25%">
                        <label style="padding-right:10px">Online</label>
                        <input type="radio" name="FilterAccess" value="0">
                        <xsl:if test="@Access = '0'">
                            <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                        </input>
                    </TD>
                    <TD width="25%">
                        <label style="padding-right:10px">Local</label>
                        <input type="radio" name="FilterAccess" value="1">
                        <xsl:if test="@Access = '1'">
                            <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                        </input>
                    </TD>
                    <TD width="25%">
                        <label style="padding-right:10px">Both</label>
                        <input type="radio" name="FilterAccess" value="2">
                        <xsl:if test="@Access = '2'">
                            <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                        </input>
                    </TD>
                    <TD width="25%">
                        <label style="padding-right:10px">All</label>
                        <input type="radio" name="FilterAccess" value="3">
                        <xsl:if test="@Access = '3'">
                            <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                        </input>
                    </TD>
                </TR>
            </TABLE>
        </div>
        <div class="table-responsive">
            <TABLE class="table color-table success-table table-bordered table-striped table-sm hover-table">
                <TR>
                    <TD colspan="4">WAGER SOURCE</TD>
                </TR>
                <TR>
                    <TD width="25%">
                        <label style="padding-right:10px">Online</label>
                        <input type="radio" name="FilterWS" value="0">
                        <xsl:if test="@WagerSource = '0'">
                            <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                        </input>
                    </TD>
                    <TD width="25%">
                        <label style="padding-right:10px">Local</label>
                        <input type="radio" name="FilterWS" value="1">
                        <xsl:if test="@WagerSource = '1'">
                            <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                        </input>
                    </TD>
                    <TD width="25%">
                        <label style="padding-right:10px">Both</label>
                        <input type="radio" name="FilterWS" value="2">
                        <xsl:if test="@WagerSource = '2'">
                            <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                        </input>
                    </TD>
                    <TD width="25%">
                        <label style="padding-right:10px">All</label>
                        <input type="radio" name="FilterWS" value="3">
                        <xsl:if test="@WagerSource = '3'">
                            <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                        </input>
                    </TD>
                </TR>
            </TABLE>
        </div>
        <div class="table-responsive">
            <TABLE class="table color-table success-table table-bordered table-striped table-sm hover-table">
                <TR>
                    <TD colspan="3">WAGER STATUS</TD>
                </TR>
                <TR>
                    <TD width="33%">
                        <label style="padding-right:10px">Pending</label>
                        <input type="radio" name="FilterWT" value="0">
                        <xsl:if test="@WagerStatus = '0'">
                            <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                        </input>
                    </TD>
                    <TD width="33%">
                        <label style="padding-right:10px">Settled</label>
                        <input type="radio" name="FilterWT" value="1">
                        <xsl:if test="@WagerStatus = '1'">
                            <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                        </input>
                    </TD>
                    <TD width="33%">
                        <label style="padding-right:10px">All</label>
                        <input type="radio" name="FilterWT" value="2">
                        <xsl:if test="@WagerStatus = '2'">
                            <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                        </input>
                    </TD>
                </TR>
            </TABLE>
        </div>
        <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-4 col-lg-4">
                <div class="form-group">
                    <INPUT type="SUBMIT" value="Submit" name="Submit" class="btn btn-primary" style="padding-left:10px;" />
                </div>
            </div>
        </div>
        <br></br>
        <h4 class="card-title">From
            <xsl:value-of select="@StartDate" /> To
            <xsl:value-of select="@EndDate" />
        </h4>
        <div class="table-responsive">
            <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-sm">
                <xsl:for-each select="Agent">
                    <THEAD>
                      <TR class="trAgent">
                        <th colspan="5" align="center">
                          Agent <xsl:value-of select="@Agent" />
                        </th>
                      </TR>
                    <TR>
                        <TH colspan="2">Player</TH>
                        <TH>Access</TH>
                        <TH>Pending</TH>
                      <TH>Settled</TH>
                    </TR>
                    </THEAD>
                    <xsl:for-each select="Player">
                        <TR>
                          <xsl:attribute name="class">
                            <xsl:choose>
                              <xsl:when test="count(preceding::Player) mod 2 = 0">TrGameOdd</xsl:when>
                              <xsl:otherwise>TrGameEven</xsl:otherwise>
                            </xsl:choose>
                          </xsl:attribute>
                            <TD align="left" rowspan="3">
                                <xsl:value-of select="@Player" disable-output-escaping="no" />
                            </TD>
                          <td>Phone</td>
                            <TD>
                                <xsl:value-of select="@PhoneAccess" disable-output-escaping="no" />
                            </TD>
                          
                            <TD>
                                <xsl:value-of select="@OpenWagerLocal" />
                            </TD>
                          
                            <TD>
                                <xsl:value-of select="@GradedWagerLocal" disable-output-escaping="no" />
                            </TD>      
                        </TR>
                      <tr>
                        <xsl:attribute name="class">
                          <xsl:choose>
                            <xsl:when test="count(preceding::Player) mod 2 = 0">TrGameOdd</xsl:when>
                            <xsl:otherwise>TrGameEven</xsl:otherwise>
                          </xsl:choose>
                        </xsl:attribute>
                        <td>Online</td>
                        <TD>
                          <xsl:value-of select="@OnLineAccess" disable-output-escaping="no" />
                        </TD>
                        <TD>
                          <xsl:value-of select="@OpenWagerOnline" />
                        </TD>
                        <TD>
                          <xsl:value-of select="@GradedWagerOnline" disable-output-escaping="no" />
                        </TD>
                      </tr>
                      <tr>
                        <xsl:attribute name="class">
                          <xsl:choose>
                            <xsl:when test="count(preceding::Player) mod 2 = 0">TrGameOdd</xsl:when>
                            <xsl:otherwise>TrGameEven</xsl:otherwise>
                          </xsl:choose>
                        </xsl:attribute>
                        <td>Total</td>
                        <TD>
                          <xsl:value-of select="@PhoneAccess + @OnLineAccess" disable-output-escaping="no" />
                        </TD>
                        <td>
                          <xsl:value-of select="@OpenWagerLocal + @OpenWagerOnline" disable-output-escaping="no" />
                        </td>
                        <TD>
                          <xsl:value-of select="@OpenWagerLocal + @OpenWagerOnline" disable-output-escaping="no" />
                        </TD>
                      </tr>
                    </xsl:for-each>
                    <TR class="GameHeader">
                        <TD rowspan="3">
                            Totals:
                            <xsl:value-of select="count(Player/@Player)" />
                        </TD>
                      <td>Phone</td>
                        <TD>
                            <xsl:value-of select="sum(Player/@PhoneAccess)" />
                        </TD> 
                        <TD>
                            <xsl:value-of select="sum(Player/@OpenWagerLocal)" />
                        </TD>
                        
                        <TD>
                            <xsl:value-of select="sum(Player/@GradedWagerLocal)" />
                        </TD>
                        
                        
                    </TR>
                  <tr class="GameHeader">
                    <td>Online</td>
                    <TD>
                      <xsl:value-of select="sum(Player/@OnLineAccess)" />
                    </TD>
                    <TD>
                      <xsl:value-of select="sum(Player/@OpenWagerOnline)" />
                    </TD>
                    <td>
                      <xsl:value-of select="sum(Player/@GradedWagerOnline)" />
                    </td>
                  </tr>
                  <tr class="GameHeader">
                    <td>Total</td>
                    <TD>
                      <xsl:value-of select="sum(Player/@PhoneAccess) + sum(Player/@OnLineAccess)" />
                    </TD>
                    <TD>
                      <xsl:value-of select="sum(Player/@OpenWagerLocal) + sum(Player/@OpenWagerOnline)" />
                    </TD>
                    <TD>
                      <xsl:value-of select="sum(Player/@GradedWagerLocal) + sum(Player/@GradedWagerOnline)" />
                    </TD>
                  </tr>
                </xsl:for-each>
            </TABLE>
        </div>
        <xsl:if test="count(//Agent) > 1">
            <div class="table-responsive">
                <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm">
                    <THEAD>
                      <TR class="trAgent">
                        <th colspan="5" align="center">
                          Totals
                        </th>
                        </TR>
                    <TR>
                        <TH>Player</TH>
                        <TH>Access</TH>
                        <TH>Pending</TH>
                        <TH>Settled</TH>
                    </TR>
                    </THEAD>
                    <TR>
                        <TD rowspan="3">
                            <xsl:value-of select="count(//Player/@Player)" />
                        </TD>
                        <TD>
                            <xsl:value-of select="sum(//Player/@PhoneAccess)" />
                        </TD>
                        <TD>
                            <xsl:value-of select="sum(//Player/@OpenWagerLocal)" />
                        </TD>
                        
                        <TD>
                            <xsl:value-of select="sum(//Player/@GradedWagerLocal)" />
                        </TD>
                    </TR>
                  <tr>
                    <TD>
                      <xsl:value-of select="sum(//Player/@OnLineAccess)" />
                    </TD>
                    <TD>
                      <xsl:value-of select="sum(//Player/@OpenWagerOnline)" />
                    </TD>
                    <TD>
                      <xsl:value-of select="sum(//Player/@GradedWagerOnline)" />
                    </TD>  
                  </tr>
                  <tr>
                    <TD>
                      <xsl:value-of select="sum(//Player/@PhoneAccess) + sum(//Player/@OnLineAccess)" />
                    </TD>
                    <TD>
                      <xsl:value-of select="sum(//Player/@OpenWagerLocal) + sum(//Player/@OpenWagerOnline)" />
                    </TD>
                    <TD>
                      <xsl:value-of select="sum(//Player/@GradedWagerLocal) + sum(//Player/@GradedWagerOnline)" />
                    </TD>
                    
                  </tr>
                </TABLE>
            </div>
        </xsl:if>
        </div>
        </div>
    </div>
</div>
    </xsl:template>

</xsl:stylesheet>
