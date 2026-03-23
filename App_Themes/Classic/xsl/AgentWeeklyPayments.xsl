<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="no" encoding="UTF-8" />

    <xsl:template match="//xml">
        <style>
            table {
            table-layout: fixed;
            }
        </style>

		<div class="row page-titles">
        <div class="col-md-12 col-12 align-self-center">
            <h3 class="main-title m-b-0 m-t-0">Agent Weekly Payments</h3>          
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
                                    <INPUT TYPE="text" class="form-control form-control-sm datepicker" NAME="Date1" value="{@StartDate}" />
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
                                    <INPUT type="SUBMIT" class="btn btn-primary" style="margin-top:24px;" value="Submit" name="Submit" />
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
                                <div class="form-group">

                                </div>
                            </div>
                        </div>

                        <h4 class="card-title">
                            <xsl:value-of select="@StartDate" /> To
                            <xsl:value-of select="@EndDate" />
                        </h4>

                        <xsl:if test="count(Agent) != 0">
                            <xsl:for-each select="Agent">
                                <div class="table-responsive">
                                    <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm">
                                        <thead>
                                        <tr class="trAgent">
                                            <th colspan="8">
                                                <xsl:value-of select="@Agent" disable-output-escaping="yes" />
                                            </th>
                                        </tr>
                                        <tr>
                                            <th>Player</th>
                                            <th>
                                                <xsl:value-of select="//@Day1" />
                                            </th>
                                            <th>
                                                <xsl:value-of select="//@Day2" />
                                            </th>
                                            <th>
                                                <xsl:value-of select="//@Day3" />
                                            </th>
                                            <th>
                                                <xsl:value-of select="//@Day4" />
                                            </th>
                                            <th>
                                                <xsl:value-of select="//@Day5" />
                                            </th>
                                            <th>
                                                <xsl:value-of select="//@Day6" />
                                            </th>
                                            <th>
                                                <xsl:value-of select="//@Day7" />
                                            </th>
                                        </tr>
                                        </thead>
                                        <xsl:for-each select="Player">
                                            <tr>
                                                <td>
                                                    <xsl:value-of select="@Player" />
                                                </td>
                                                <td>
                                                    <xsl:value-of select="format-number(@Day1,'###,##0')" />
                                                </td>
                                                <td>
                                                    <xsl:value-of select="format-number(@Day2,'###,##0')" />
                                                </td>
                                                <td>
                                                    <xsl:value-of select="format-number(@Day3,'###,##0')" />
                                                </td>
                                                <td>
                                                    <xsl:value-of select="format-number(@Day4,'###,##0')" />
                                                </td>
                                                <td>
                                                    <xsl:value-of select="format-number(@Day5,'###,##0')" />
                                                </td>
                                                <td>
                                                    <xsl:value-of select="format-number(@Day6,'###,##0')" />
                                                </td>
                                                <td>
                                                    <xsl:value-of select="format-number(@Day7,'###,##0')" />
                                                </td>
                                            </tr>
                                        </xsl:for-each>
                                        <tr>
                                            <td>Totals</td>
                                            <td>
                                                <xsl:value-of select="format-number(sum(Player/@Day1),'###,##0')" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="format-number(sum(Player/@Day2),'###,##0')" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="format-number(sum(Player/@Day3),'###,##0')" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="format-number(sum(Player/@Day4),'###,##0')" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="format-number(sum(Player/@Day5),'###,##0')" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="format-number(sum(Player/@Day6),'###,##0')" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="format-number(sum(Player/@Day7),'###,##0')" />
                                            </td>
                                        </tr>
                                    </TABLE>
                                </div>
                            </xsl:for-each>

                            <xsl:if test="count(Agent) > 1">
                                <div class="table-responsive">
                                    <TABLE class="table color-table success-table table-bordered table-striped table-sm hover-table">
                                        <thead>
                                        <tr>
                                            <td colspan="8">
                                                Master Totals
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Player</td>
                                            <td>
                                                <xsl:value-of select="//@Day1" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="//@Day2" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="//@Day3" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="//@Day4" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="//@Day5" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="//@Day6" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="//@Day7" />
                                            </td>
                                        </tr>
                                        </thead>
                                        <tr>
                                            <td>
                                                <xsl:value-of select="format-number(count(//Player),'###,##0')" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="format-number(sum(//Player/@Day1),'###,##0')" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="format-number(sum(//Player/@Day2),'###,##0')" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="format-number(sum(//Player/@Day3),'###,##0')" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="format-number(sum(//Player/@Day4),'###,##0')" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="format-number(sum(//Player/@Day5),'###,##0')" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="format-number(sum(//Player/@Day6),'###,##0')" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="format-number(sum(//Player/@Day7),'###,##0')" />
                                            </td>
                                        </tr>
                                    </TABLE>
                                </div>
                            </xsl:if>

                        </xsl:if>

                        <xsl:if test="count(Agent) = 0">
                            <div class="table-responsive">
                                <TABLE class="table color-table success-table table-bordered table-striped table-sm">
                                    <tr>
                                        <td>No data.</td>
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
