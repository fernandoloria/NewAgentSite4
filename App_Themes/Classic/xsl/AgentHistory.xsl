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
>Agent History
</h3>          
    </div>
        </div>
        <div class="row">
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
                                <div class="form-group">
                                    <label for="Date1">Initial Date:</label><br></br>
                                    <INPUT TYPE="text" class="form-control form-control-sm datepicker" NAME="Date1" value="{@StartDate}" />
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
                                <div class="form-group">
                                    <label for="Date2">End Date:</label><br></br>
                                    <INPUT TYPE="text" class="form-control form-control-sm datepicker" NAME="Date2" value="{@EndDate}" />
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
                                <div class="form-group">
                                    <label for="Filter">Transaction:</label><br></br>
                                    <SELECT class="form-control form-control-sm" NAME="Filter" OnChange="post();">
                                      <xsl:for-each select="combobox">
                                        <OPTION VALUE="{@Value}">
                                          <xsl:if test="@Value='1'">
                                            <xsl:attribute name="Selected">Selected</xsl:attribute>
                                          </xsl:if>
                                          <xsl:value-of select="@Text" />
                                        </OPTION>
                                      </xsl:for-each>
                                    </SELECT>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
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
                            <xsl:value-of select="//@StartDate" /> To
                            <xsl:value-of select="//@EndDate" />
                        </h4>
                        <div class="table-responsive">
                            <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm">
                                <THEAD>
                                    <TR>
                                        <TH>Date</TH>
                                        <TH>Type</TH>
                                        <TH>Description</TH>
                                        <TH>Amount</TH>
                                        <TH>Balance</TH>
                                    </TR>
                                    <TR>
                                        <TH></TH>
                                        <TH>BWF</TH>
                                        <TH>BALANCE FORWARD</TH>
                                        <TH></TH>
                                        <TH>
                                            <xsl:value-of select="format-number(//xml/@BWD,'###,##0')" />
                                        </TH>
                                    </TR>
                                </THEAD>
                                <xsl:for-each select="detail">
                                    <TR>
                                        <TD>
                                            <xsl:value-of select="@LastModification" />
                                        </TD>
                                        <TD>
                                            <xsl:value-of select="@TransactionType" />
                                        </TD>
                                        <TD>
                                            <xsl:value-of select="@Description" />
                                        </TD>
                                        <TD>
                                            <xsl:value-of select="format-number(@Amount,'###,##0')" />
                                        </TD>
                                        <TD>
                                            <xsl:value-of select="format-number(@NewBalance,'###,##0')" />
                                        </TD>
                                    </TR>
                                </xsl:for-each>
                                <xsl:if test="count(//detail)=0">
                                    <TR>
                                        <TD COLSPAN="5"> No History Transactions</TD>
                                    </TR>
                                </xsl:if>
                                <xsl:if test="count(//detail)!=0">
                                    <TR>
                                        <TD colspan="5">
                                            <b>
                                              <xsl:value-of disable-output-escaping="yes" select="count(//detail/@Amount)"/> Trans
                                              Total Amount: <xsl:value-of disable-output-escaping="yes" select="format-number(sum(//detail/@Amount),'###,##0')"/>
                                              (<xsl:value-of disable-output-escaping="yes" select="//xml/@StartDate"/> thru <xsl:value-of disable-output-escaping="yes" select="//xml/@EndDate"/>)
                                            </b>
                                        </TD>
                                    </TR>
                                </xsl:if>
                            </TABLE>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet>
