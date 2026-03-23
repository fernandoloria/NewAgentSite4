<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="no" encoding="UTF-8" />

    <xsl:template match="/*">
        		<div class="row page-titles">
        <div class="col-md-12 col-12 align-self-center">
            <h3 class="main-title m-b-0 m-t-0">Player Access</h3>          
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
                                    <INPUT TYPE="text" class="form-control form-control-sm datepicker" NAME="Date1" value="{//xml/@StartDate}" />
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
                                <div class="form-group">
                                    <label for="Date2">End Date:</label><br></br>
                                    <INPUT TYPE="text" class="form-control form-control-sm datepicker" NAME="Date2" value="{//xml/@EndDate}" />
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
                                <div class="form-group">
                                    <label for="cPlayer">Access For Player:</label><br></br>
                                    <SELECT class="form-control form-control-sm" NAME="cPlayer">
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
                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
                                <div class="form-group">
                                    <label for="txtIP">or IP Access:</label><br></br>
                                    <input TYPE="text" class="form-control form-control-sm" name="txtIP" id="txtIP"></input>
                                </div>
                            </div>
                            <div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
                                <INPUT type="SUBMIT" class="btn btn-primary" style="margin-top:28px;" value="Submit" name="Submit" />
                            </div>
                        </div>

                        <xsl:for-each select="//Agent">
                            <div class="table-responsive">
                                <TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm">
                                    <thead>
                                        <tr class="trAgent">
                                            <th colspan="5">
                                                Agent
                                                <xsl:value-of select="@Agent" />
                                            </th>
                                        </tr>
                                        <tr>
                                            <th>Player</th>
                                            <th>Call ID</th>
                                            <th>Start Time</th>
                                            <!--<th>End Time</th>-->
                                            <th>IP Access</th>
                                        </tr>
                                    </thead>
                                    <xsl:for-each select="//Player">
                                        <tr>
                                            <td>
                                                <xsl:value-of select="@Player" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="@IdCall" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="@StartTime" />
                                            </td>
                                            <!--<td>
                                                <xsl:value-of select="@EndTime" />
                                            </td>-->
                                            <td>
												  <xsl:call-template name="convertcommas">
                                                    <xsl:with-param name="text" select="@IP"/>
                                                  </xsl:call-template>
                                                  
                                                
                                            </td>
                                        </tr>
                                    </xsl:for-each>
                                </TABLE>
                            </div>
                        </xsl:for-each>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>


  <xsl:template match="ZNAME" name="convertcommas">
  <xsl:param name="text" select="."/>
    <a href="http://www.ip-tracker.org/locator/ip-lookup.php?ip={substring-before(concat($text,','),',')}" target="_blank">
      <xsl:value-of select="substring-before(concat($text,','),',')" />
    </a>
  <xsl:if test="contains($text,',')">
    <br />
    <a href="http://www.ip-tracker.org/locator/ip-lookup.php?ip={substring-after($text,',')}" target="_blank">
    <xsl:call-template name="convertcommas">
      <xsl:with-param name="text" select="substring-after($text,',')" />
    </xsl:call-template>
    </a>
  </xsl:if>    
</xsl:template>

</xsl:stylesheet>
