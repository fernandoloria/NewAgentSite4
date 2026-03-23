<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output  method="html" indent="no" encoding="UTF-8" />

  <xsl:template match="/*">
    <SCRIPT LANGUAGE="JavaScript" SRC="../App_Themes/Classic/CalendarPopup.js"></SCRIPT>
        <SCRIPT LANGUAGE="JavaScript">
          var cal = new CalendarPopup();
        </SCRIPT>
      
      <SCRIPT LANGUAGE="JavaScript" TYPE="text/JavaScript">
        function post(){
        var strNum = 'Page=1';
        var strID = 'IdPlayer=' + document.forms[0].cPlayer.value;

        var str = strNum + '&amp;' + strID;

        document.forms[0].action = 'PlayerHistory.aspx?' + str;
        document.forms[0].submit();
        }
        function ChangePage(){
        var strNum = 'Page=' + document.forms[0].PageNum.value;
        var strID = 'IdPlayer=' + document.forms[0].cPlayer.value;

        var str = strNum + '&amp;' + strID;

        document.forms[0].action = 'PlayerHistory.aspx?' + str;
        document.forms[0].submit();
        }
        
        function ChangeWithLink(str){

        document.forms[0].action = 'PlayerHistory.aspx?' + str;
        document.forms[0].submit();
        }
      </SCRIPT>
     
          <xsl:if test="//xml/@SpcWeek = '0'">
            </xsl:if>  

			<div class="row page-titles">
        <div class="col-md-12 col-12 align-self-center">
            <h3 class="main-title m-b-0 m-t-0">Player History</h3>          
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
                        <INPUT TYPE="text" class="form-control form-control-sm datepicker" NAME="Date1" value="{//xml/@StartDate}" />
                    </div>
                </div>
                <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                    <div class="form-group">
                        <label for="Date2">Initial Date:</label><br></br>
                        <INPUT TYPE="text" class="form-control form-control-sm datepicker" NAME="Date2" value="{//xml/@EndDate}" />
                    </div>
                </div>
                <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                    <div class="form-group">
                        <label for="cCurrency">Currency:</label><br></br>
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
                    <INPUT type="SUBMIT" class="btn btn-primary" style="margin-top:28px;" value="Submit" name="Submit" />
                </div>
            </div>

          <xsl:if test="//xml/@SpcWeek != '0'">
            <input type="hidden" name="Date1" value="{//xml/@StartDate}"/>
            <input type="hidden" name="Date2" value="{//xml/@EndDate}"/>
            <TABLE class="table color-table success-table table-bordered table-striped table-sm">
              <xsl:for-each select="week">
                <tr>
                  <td>
                    <a href="PlayerHistory.aspx?cDateWeek={@StartDate}_{@EndDate}">
                      <xsl:value-of select="@Text"/>
                    </a>
                  </td>
                </tr>
              </xsl:for-each>
            </TABLE>
          </xsl:if>
            
            <div class="row">
                <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                    <div class="form-group form-control-sm">
                        <label for="cCurrency">History for Player:</label><br></br>
                        <SELECT class="form-control form-control-sm"  NAME="cPlayer" OnChange="post();">
                        <xsl:for-each select="player">
                          <OPTION VALUE="{@Value}">
                            <xsl:if test="@Selected='1'">
                              <xsl:attribute name="Selected">Selected</xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="@Text" />
                          </OPTION>
                        </xsl:for-each>
                      </SELECT>
                    </div>
                </div>
                <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                    <div class="form-group">

                    </div>
                </div>
                <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                    <div class="form-group">

                    </div>
                </div>
                <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                    <div class="form-group">

                    </div>
                </div>
            </div>
            <h4 class="card-title"><xsl:value-of select="//xml/@StartDate"/> To <xsl:value-of select="//xml/@EndDate"/></h4>
            <div class="table-responsive">
            <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm hidden-md-down">
              <THEAD>
                <TR>
                <xsl:if test="//xml/@OnlyPlayer = 'True'">
                  <TH>User/Phone</TH>
                  <TH>Date</TH>
                  <TH>Sport</TH>
                  <TH>Description</TH>
                  <TH>Risk/Win</TH>
                  <TH>Amount</TH>
                  <TH>Result</TH>
                  <TH>Placed</TH>
                </xsl:if>
                <xsl:if test="//xml/@OnlyPlayer = 'False'">
                  <TH>Player</TH>
                  <TH>User/Phone</TH>
                  <TH>Date</TH>
                  <TH>Sport</TH>
                  <TH>Description</TH>
                  <TH>Risk/Win</TH>
                  <TH>Amount</TH>
                  <TH>Result</TH>
                  <TH>Placed</TH>
                </xsl:if>
              </TR>
            </THEAD>
              <xsl:for-each select="historybet">
                <TR>
                  <xsl:if test="//xml/@OnlyPlayer = 'False'">
                    <TD>
                      <xsl:value-of disable-output-escaping="yes" select="@Player"/>
                    </TD>
                  </xsl:if>
                  <TD ALIGN="center">
                    <xsl:value-of disable-output-escaping="yes" select="@Text1"/>
                  </TD>
                  <TD>
                    <xsl:call-template name="replaceLongDateMonth">
                      <xsl:with-param name="text" select="@Text2" />
                    </xsl:call-template>
                  </TD>
                  <TD>
                    <xsl:value-of disable-output-escaping="yes" select="@Text3"/>
                  </TD>
                  <TD>
                    <xsl:value-of disable-output-escaping="yes" select="@Text4"/>
                  </TD>
                  <TD>
                    <xsl:value-of disable-output-escaping="yes" select="@Text5"/>
                  </TD>
                  <TD>
                    <xsl:value-of disable-output-escaping="yes" select="@Text6 + @TTaxAmount"/>
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
                  <TD>
                    <xsl:call-template name="replaceLongDateMonth">
                      <xsl:with-param name="text" select="@Text8" />
                    </xsl:call-template>
                  </TD>
                </TR>
              </xsl:for-each>
              <xsl:if test="count(//historybet)=0">
                <TR>
                  <TD CLASS="TrGameBottom" COLSPAN="9" align="center"> No History Wagers</TD>
                </TR>
              </xsl:if>
              <xsl:if test="count(//historybet)!=0">
                <TR CLASS="TrGameBottom">
                  <TD></TD>
                  <TD colspan="9">
                    <xsl:value-of disable-output-escaping="yes" select="count(//historybet/@Text1)"/> Bet(s) - 
                    Total Risk: <xsl:value-of disable-output-escaping="yes" select="format-number(sum(//historybet/@TRisk),'###,##0')"/>
                    Total Win: <xsl:value-of disable-output-escaping="yes" select="format-number(sum(//historybet/@TWin),'###,##0')"/>
                    Total Amount: <xsl:value-of disable-output-escaping="yes" select="format-number(sum(//historybet/@Text6) + sum(//historybet/@TTaxAmount),'###,##0')"/>
                    (<xsl:value-of disable-output-escaping="yes" select="//xml/@StartDate"/> thru <xsl:value-of disable-output-escaping="yes" select="//xml/@EndDate"/>)
                  </TD>
                </TR>
                <TR CLASS="TrGameBottom">
                  <TD></TD>
                  <TD colspan="9">
                    Grand Total Transactions: <xsl:value-of disable-output-escaping="yes" select="format-number(//xml/@GrandTotalTransacion,'###,##0')"/>
                    Grand Total Amount: <xsl:value-of disable-output-escaping="yes" select="format-number(//xml/@GrandTotalAmount,'###,##0')"/>
                  </TD>
                </TR>
              </xsl:if>
            </TABLE>

              <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-sm d-lg-none">
                <THEAD>
                  <TR>
                      <TH>
                        Player <br/>
                      </TH>
                      <Th>
                        User/Phone <br/>Date
                      </Th>
                      <TH>
                        Sport
                      </TH>
                      <TH>
                        Description
                      </TH>
                      <TH>
                        Result
                      </TH>
                      <th>
                        Amount<br/>Risk/Win
                      </th>
                  </TR>
                </THEAD>
                <xsl:for-each select="historybet">

                  <!--background: #f2f4f8;-->
                  <tr>
                    <xsl:attribute name="class">
                      <xsl:choose>
                        <xsl:when test="count(preceding::historybet) mod 2 = 0">TrGameOdd</xsl:when>
                        <xsl:otherwise>TrGameEven</xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>

                    <td>
                      <xsl:value-of disable-output-escaping="yes" select="@Player"/>
                    </td>
                    <td>
                      <xsl:value-of disable-output-escaping="yes" select="@Text1"/>
                    </td>
                    <TD rowspan="2">
                      <xsl:value-of disable-output-escaping="yes" select="@Text3"/>
                    </TD>
                    <TD rowspan="2">
                      <xsl:value-of disable-output-escaping="yes" select="@Text4"/>
                    </TD>

                    <xsl:if test="@Score != ''">
                      <TD rowspan="2">
                        <a href="javascript:GetScore({@Score});" title="View Games Score">
                          <xsl:value-of disable-output-escaping="yes" select="@Text7"/>
                        </a>
                      </TD>
                    </xsl:if>
                    <xsl:if test="@Score = ''">
                      <TD rowspan="2">
                        <xsl:value-of disable-output-escaping="yes" select="@Text7"/>
                      </TD>
                    </xsl:if>

                    <TD>
                      <xsl:value-of disable-output-escaping="yes" select="@Text6 + @TTaxAmount"/>
                    </TD>
                  </tr>
                  <TR>
                    <xsl:attribute name="class">
                      <xsl:choose>
                        <xsl:when test="count(preceding::historybet) mod 2 = 0">TrGameOdd</xsl:when>
                        <xsl:otherwise>TrGameEven</xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                    <td>
                      Placed:<br/>
                      <xsl:call-template name="replaceLongDateMonth">
                        <xsl:with-param name="text" select="@Text8" />
                      </xsl:call-template>
                    </td>
                    <!--<xsl:if test="//xml/@OnlyPlayer = 'False'">
                    <TD>  
                      <xsl:value-of disable-output-escaping="yes" select="@Text1"/>
                    </TD>
                  </xsl:if>
                  -->
                    <TD>
                      <xsl:call-template name="replaceLongDateMonth">
                        <xsl:with-param name="text" select="@Text2" />
                      </xsl:call-template>
                    </TD>
                    <TD>
                      <xsl:value-of disable-output-escaping="yes" select="@Text5"/>
                    </TD>
                  </TR>
                </xsl:for-each>
                <xsl:if test="count(//historybet)=0">
                  <TR>
                    <TD CLASS="TrGameBottom" COLSPAN="9" align="center"> No History Wagers</TD>
                  </TR>
                </xsl:if>
                <xsl:if test="count(//historybet)!=0">
                  <TR CLASS="TrGameBottom">
                    <TD></TD>
                    <TD colspan="8">
                      <xsl:value-of disable-output-escaping="yes" select="count(//historybet/@Text1)"/> Bet(s) -
                      Total Risk: <xsl:value-of disable-output-escaping="yes" select="format-number(sum(//historybet/@TRisk),'###,##0')"/>
                      Total Win: <xsl:value-of disable-output-escaping="yes" select="format-number(sum(//historybet/@TWin),'###,##0')"/>
                      Total Amount: <xsl:value-of disable-output-escaping="yes" select="format-number(sum(//historybet/@Text6) + sum(//historybet/@TTaxAmount),'###,##0')"/>
                      (<xsl:value-of disable-output-escaping="yes" select="//xml/@StartDate"/> thru <xsl:value-of disable-output-escaping="yes" select="//xml/@EndDate"/>)
                    </TD>
                  </TR>
                  <TR CLASS="TrGameBottom">
                    <TD></TD>
                    <TD colspan="8">
                      Grand Total Transactions: <xsl:value-of disable-output-escaping="yes" select="format-number(//xml/@GrandTotalTransacion,'###,##0')"/>
                      Grand Total Amount: <xsl:value-of disable-output-escaping="yes" select="format-number(//xml/@GrandTotalAmount,'###,##0')"/>
                    </TD>
                  </TR>
                </xsl:if>
              </TABLE>
              
            </div>
            <div class="table-responsive">
              <TABLE class="table color-table success-table table-bordered table-striped table-sm hover-table">
                <TR>
                  <TD>
                    <xsl:if test="//xml/@Prev != ''">
                      <A href="#" onclick="ChangeWithLink('{//xml/@Prev}');">Previous Page </A>
                    </xsl:if>
                    <xsl:if test="//xml/@View != ''">
                      <xsl:value-of select="//xml/@View"/> detail(s)
                    </xsl:if>
                    <xsl:if test="//xml/@Next != ''">
                      <A href="#" onclick="ChangeWithLink('{//xml/@Next}');"> Next Page</A>
                    </xsl:if>
                  </TD>
                    <TD align="right"><STRONG>Go to:</STRONG></TD>
                    <TD align="right">
                    <xsl:if test="count(//pagenum) > 0">
                      <SELECT class="form-control form-control-sm" NAME="PageNum" OnChange="ChangePage();">
                        <xsl:for-each select="//pagenum">
                          <OPTION VALUE="{@Value}">
                            <xsl:if test="@Selected='1'">
                              <xsl:attribute name="Selected">Selected</xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="@Text" />
                          </OPTION>
                        </xsl:for-each>
                      </SELECT>
                    </xsl:if>
                  </TD>
                </TR>
              </TABLE>
            </div>
        </div>
        </div>
    </div>
</div>
  </xsl:template>




  <xsl:template name="replaceLongDateMonth">
    <xsl:param name="text" />
    <xsl:choose>
      <xsl:when test="contains($text, 'January')">
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="$text" />
          <xsl:with-param name="replace" select="'January'" />
          <xsl:with-param name="by" select="'Jan'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($text, 'February')">
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="$text" />
          <xsl:with-param name="replace" select="'February'" />
          <xsl:with-param name="by" select="'Feb'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($text, 'March')">
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="$text" />
          <xsl:with-param name="replace" select="'March'" />
          <xsl:with-param name="by" select="'Mar'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($text, 'April')">
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="$text" />
          <xsl:with-param name="replace" select="'April'" />
          <xsl:with-param name="by" select="'Apr'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($text, 'June')">
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="$text" />
          <xsl:with-param name="replace" select="'June'" />
          <xsl:with-param name="by" select="'Jun'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($text, 'July')">
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="$text" />
          <xsl:with-param name="replace" select="'July'" />
          <xsl:with-param name="by" select="'Jul'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($text, 'August')">
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="$text" />
          <xsl:with-param name="replace" select="'August'" />
          <xsl:with-param name="by" select="'Aug'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($text, 'September')">
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="$text" />
          <xsl:with-param name="replace" select="'September'" />
          <xsl:with-param name="by" select="'Sep'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($text, 'Oct')">
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="$text" />
          <xsl:with-param name="replace" select="'October'" />
          <xsl:with-param name="by" select="'Oct'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($text, 'November')">
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="$text" />
          <xsl:with-param name="replace" select="'November'" />
          <xsl:with-param name="by" select="'Nov'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($text, 'December')">
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="$text" />
          <xsl:with-param name="replace" select="'December'" />
          <xsl:with-param name="by" select="'Dec'" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of disable-output-escaping="yes" select="substring-before($text,$replace)" />
        <xsl:value-of disable-output-escaping="yes" select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text" select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of disable-output-escaping="yes" select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>

